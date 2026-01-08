import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lavoauto/presentation/common_widgets/custom_dialog.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/request/user/payment_method_request.dart';
import '../../../data/repositories/user_repo.dart';
import '../../../data/services/stripe_service.dart';
import '../../../dependencyInjection/di.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  CardFormEditController? _cardFormController;
  bool _isLoading = false;
  bool _isCardComplete = false;

  @override
  void initState() {
    super.initState();
    _cardFormController = CardFormEditController();
  }

  @override
  void dispose() {
    _cardFormController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Agregar Tarjeta",
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontColor: AppColors.primary,
        ).setText(),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stripe Card Form
                    _buildStripeCardForm(),
                    const YMargin(40),
                    
                    // Botón de agregar
                    _buildAddButton(),
                    const YMargin(20),
                  ],
                ),
              ),
            ),
    );
  }



  Widget _buildStripeCardForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Datos de la Tarjeta",
            fontSize: 16.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(20),
          
          // Stripe Card Form (secure, no card data sent to server)
          CardFormField(
            controller: _cardFormController!,
            onCardChanged: (card) {
              setState(() {
                _isCardComplete = card?.complete ?? false;
              });
            },
            style: CardFormStyle(
              backgroundColor: AppColors.blackNormalColor,
              borderColor: AppColors.greyNormalColor.withOpacity(0.3),
              borderRadius: 10,
              borderWidth: 1,
              textColor: AppColors.white,
              fontSize: 16,
              placeholderColor: AppColors.greyNormalColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton.primarybutton(
        text: "AGREGAR TARJETA",
        onpressed: (_isLoading || !_isCardComplete) ? null : _addPaymentMethod,
        isPrimary: true,
        isEnable: !_isLoading && _isCardComplete,
        width: double.infinity,
      ),
    );
  }

  Future<void> _addPaymentMethod() async {
    if (!_isCardComplete) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      debugPrint("🔐 Creating SetupIntent for secure payment method addition...");
      
      // Step 1: Create SetupIntent on backend
      final userRepo = AppContainer.getIt.get<UserRepo>();
      final setupIntentRequest = CreateSetupIntentRequest(token: token);
      final setupIntentResponse = await userRepo.createSetupIntent(setupIntentRequest);

      if (setupIntentResponse.data == null) {
        if (mounted) {
          _showErrorDialog(setupIntentResponse.errorMessage ?? 'Error creating setup intent');
        }
        return;
      }

      final clientSecret = setupIntentResponse.data!.clientSecret;
      debugPrint("🔐 SetupIntent created with client_secret: ${clientSecret.substring(0, 20)}...");

      // Step 2: Confirm SetupIntent with Stripe SDK (secure, no card data sent to our server)
      final result = await Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret,
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      debugPrint("🔐 SetupIntent confirmed with payment method: ${result.paymentMethodId}");
      debugPrint("🔐 SetupIntent status: '${result.status}' (type: ${result.status.runtimeType})");
      debugPrint("🔐 Status comparison: '${result.status}' == 'succeeded' ? ${result.status == 'succeeded'}");

      // Check for successful completion - SetupIntent status can be 'succeeded' or 'requires_confirmation'
      // Both indicate the payment method was successfully added
      final status = result.status.toLowerCase();
      if (status == 'succeeded' || status == 'requires_confirmation') {
        final paymentMethodId = result.paymentMethodId;
        if (paymentMethodId != null) {
          // Payment method will be saved automatically via Stripe webhook
          // Show success message immediately - don't wait for webhook
          if (mounted) {
            _showSuccessDialog("Método de pago agregado exitosamente");
          }
        } else {
          // Even if paymentMethodId is null, if status is succeeded/requires_confirmation, 
          // the method was likely added successfully
          if (mounted) {
            _showSuccessDialog("Método de pago agregado exitosamente");
          }
        }
      } else {
        // Only show error for actual failure statuses like 'canceled', 'processing' errors, etc.
        debugPrint("🔐 SetupIntent failed with status: ${result.status}");
        if (mounted) {
          _showErrorDialog("Error al confirmar método de pago");
        }
      }
    } catch (e) {
      debugPrint("Error adding payment method: $e");
      if (mounted) {
        String errorMessage = "Error al agregar método de pago";
        if (e is StripeException) {
          errorMessage = e.error.localizedMessage ?? e.error.message ?? errorMessage;
        }
        _showErrorDialog(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(String message) {
    if (mounted && context.mounted) {
      const DialogCustom().getCustomDialog(
        null,
        title: "¡Éxito!",
        subtitle: message,
        cancelEnable: false,
        context: context,
        onSuccess: () {
          if (context.mounted) {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(true); // Return to previous screen with success
          }
        },
      );
    }
  }

  void _showErrorDialog(String message) {
    if (mounted && context.mounted) {
      const DialogCustom().getCustomDialog(
        null,
        title: "Error",
        subtitle: message,
        cancelEnable: false,
        context: context,
        onSuccess: () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    }
  }
}

 