import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/presentation/common_widgets/text_field.dart';
import 'package:lavoauto/presentation/router/router.gr.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/loadersUtils/LoaderClass.dart';
import 'package:lavoauto/utils/utils.dart';

import '../../../bloc/bloc/user_info_bloc.dart';
import '../../../data/models/request/user/create_user_order_modal.dart';
import '../../../data/models/request/user/payment_method_request.dart';
import '../../../data/models/response/user/orders_response_modal.dart';
import '../../../data/models/response/user/payment_method_response.dart';
import '../../../data/repositories/user_repo.dart';
import '../../../dependencyInjection/di.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';

@RoutePage()
class NewOrder extends StatefulWidget {
  final UserOrder? existingOrder;

  const NewOrder({super.key, this.existingOrder});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  String selectedDateTime = '';
  bool _isCheckingPaymentMethods = false;
  bool _isCreatingOrder = false;
  List<PaymentMethodData> _paymentMethods = [];
  PaymentMethodData? _selectedPaymentMethod;
  String? selectedUrgentOption;

  @override
  void initState() {
    super.initState();
    debugPrint("🚀 NewOrder page initialized");
    // Check payment methods first, then load user info
    _checkPaymentMethods();
  }

  Future<void> _checkPaymentMethods() async {
    setState(() {
      _isCheckingPaymentMethods = true;
    });

    debugPrint("🔍 Checking payment methods...");

    try {
      final token = Utils.getAuthenticationToken();

      if (token.isEmpty) {
        debugPrint("❌ No token found, skipping payment method check");
        setState(() {
          _isCheckingPaymentMethods = false;
        });
        _loadUserInfo();
        return;
      }

      debugPrint("🔑 Token found: ${token.substring(0, 10)}...");

      // Use the same repository pattern as payment_methods.dart for consistency
      final userRepo = AppContainer.getIt.get<UserRepo>();
      final request = GetPaymentMethodsRequest(token: token);
      final response = await userRepo.getPaymentMethods(request);

      setState(() {
        _isCheckingPaymentMethods = false;
      });

      if (response.data != null) {
        final paymentMethods = response.data!.paymentMethods;

        if (paymentMethods.isNotEmpty) {
          debugPrint("✅ Found ${paymentMethods.length} payment methods");

          // Convert from Stripe payment method format
          List<PaymentMethodData> parsedPaymentMethods = [];
          for (var pm in paymentMethods) {
            try {
              final paymentMethodData = PaymentMethodData(
                id: pm.id,
                type: pm.type,
                brand: pm.brand ?? 'unknown',
                last4: pm.last4 ?? '****',
                expiryMonth: int.tryParse(pm.expiryMonth.toString() ?? '0') ?? 0,
                expiryYear: int.tryParse(pm.expiryYear.toString() ?? '0') ?? 0,
                isDefault: pm.isDefault ?? false,
              );
              parsedPaymentMethods.add(paymentMethodData);
              debugPrint("✅ Parsed payment method: ${paymentMethodData.id} (default: ${paymentMethodData.isDefault})");
            } catch (e) {
              debugPrint("❌ Error parsing payment method: $e");
            }
          }

          setState(() {
            _paymentMethods = parsedPaymentMethods;
            // Seleccionar automáticamente el método principal, o el primero si no hay principal
            if (_paymentMethods.isNotEmpty) {
              final defaultMethod = _paymentMethods.firstWhere(
                (pm) => pm.isDefault,
                orElse: () => _paymentMethods.first,
              );
              _selectedPaymentMethod = defaultMethod;
              debugPrint("✅ Selected payment method: ${defaultMethod.id} (**** ${defaultMethod.last4})");
            }
          });

          _loadUserInfo();
        } else {
          debugPrint("⚠️ No payment methods found");
          setState(() {
            _paymentMethods = [];
            _selectedPaymentMethod = null;
          });
          // No payment methods found, show alert and redirect
          _showNoPaymentMethodsAlert();
        }
      } else {
        debugPrint("❌ Payment methods API error: ${response.errorMessage}");
        setState(() {
          _paymentMethods = [];
          _selectedPaymentMethod = null;
        });
        // On API error, still allow user to proceed but show warning
        _showNoPaymentMethodsAlert();
      }
    } catch (e) {
      setState(() {
        _isCheckingPaymentMethods = false;
        _paymentMethods = [];
        _selectedPaymentMethod = null;
      });
      debugPrint("💥 Error checking payment methods: $e");
      // On error, show no payment methods alert
      _showNoPaymentMethodsAlert();
    }
  }

  void _showNoPaymentMethodsAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.payment,
            color: Colors.orange,
            size: 64,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Método de pago requerido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Necesitas agregar un método de pago antes de poder crear un pedido.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to payment methods page
                context.router.replaceAll([const PaymentMethods()]);
              },
              child: const Text(
                'Agregar método de pago',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _loadUserInfo() {
    // Ensure user info is loaded
    final userInfoState = context.read<UserInfoBloc>().state;
    if (userInfoState is! UserInfoSuccess) {
      String token = Utils.getAuthenticationToken();
      if (token.isNotEmpty) {
        context.read<UserInfoBloc>().add(
              FetchUserProfileInfoEvent(token: token),
            );
      }
    }
  }

  String _formatDateTimeForDisplay(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _formatDateTimeForAPI(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);

    if (_isCheckingPaymentMethods) {
      return const Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.menuNewOrder,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.myServices,
        ontap: () {
          debugPrint("click ");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
        ),
        child: ListView(
          children: [
            const YMargin(20.0),
            _buildCustomCardWidget(context,
                title: AppStrings.currentPaymentCycle, subtitle: AppStrings.exampleFinanceDate, loader: loader),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCardWidget(BuildContext context, {String title = '', subtitle = '', loader}) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGrey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de campos editables

          const YMargin(8.0),
          CustomTextFieldWidget(
            controller: Utils.approxWeightController,
            maxLength: 4,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            fillcolour: AppColors.white,
            hintColor: AppColors.grey,
            maxLines: 1,
            suffixWidget: null,
            isVisible: true,
            hintText: AppStrings.approxWeight,
            onChanged: (v) {},
          ),
          const YMargin(10.0),
          // Detergent Type Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.screenBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderGrey,
                width: 1.4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.opacity_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(14),
                    dropdownColor: AppColors.white,
                    underline: const SizedBox.shrink(),
                    icon: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    hint: const Text(
                      'Selecciona tipo de detergente',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: Utils.detergentTypeController.text.isEmpty ? null : Utils.detergentTypeController.text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    items: [
                      'En polvo',
                      'Líquido',
                      'Blanqueador',
                      'Desengrasante',
                    ]
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          Utils.detergentTypeController.text = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const YMargin(10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar suavizante',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const YMargin(12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => Utils.suavizante = true);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Utils.suavizante ? AppColors.toggleSelectedBg : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Utils.suavizante ? AppColors.secondary : AppColors.borderGrey,
                            width: Utils.suavizante ? 2 : 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sí',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => Utils.suavizante = false);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: !Utils.suavizante ? AppColors.toggleSelectedBg : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !Utils.suavizante ? AppColors.secondary : AppColors.borderGrey,
                            width: !Utils.suavizante ? 2 : 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const YMargin(10.0),
          // Drying Method Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.screenBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.borderGrey,
                width: 1.4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    underline: const SizedBox.shrink(),
                    icon: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    hint: const Text(
                      "Método de secado",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: Utils.dryingMethodTypeController.text.isEmpty ? null : Utils.dryingMethodTypeController.text,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    items: ['Sol', 'Secadora'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        Utils.dryingMethodTypeController.text = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const YMargin(10.0),
          // Ironing Type Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.screenBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.borderGrey,
                width: 1.3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.18),
                  ),
                  child: const Icon(
                    Icons.iron_rounded,
                    size: 22,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    dropdownColor: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    hint: const Text(
                      "Tipo de planchado (opcional)",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: Utils.selectedIroningType,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text("Sin planchado"),
                      ),
                      DropdownMenuItem(
                        value: "con_gancho",
                        child: Text("Con gancho"),
                      ),
                      DropdownMenuItem(
                        value: "sin_gancho",
                        child: Text("Sin gancho"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        Utils.selectedIroningType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const YMargin(10.0),
          // Number of Garments to Iron
          if (Utils.selectedIroningType != null) ...[
            CustomTextFieldWidget(
              controller: Utils.ironingNumberController,
              maxLength: 4,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*')),
              ],
              fillcolour: AppColors.white,
              hintColor: AppColors.grey,
              maxLines: 1,
              suffixWidget: null,
              isVisible: true,
              hintText: 'Número de prendas a planchar',
              onChanged: (v) {},
            ),
            const YMargin(10.0),
          ],
          // EXPRESS OPTIONS — PREMIUM REDESIGN
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.screenBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.borderGrey,
                width: 1.3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Opciones urgentes (tarifa más elevada):',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withValues(alpha: 0.22),
                      ),
                      child: const Icon(
                        Icons.flash_on_rounded,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<String?>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(14),
                        dropdownColor: AppColors.white,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        hint: const Text(
                          'Selecciona una opción urgente (opcional)',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: selectedUrgentOption,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('Sin urgencia'),
                          ),
                          DropdownMenuItem(
                            value: 'lavado_urgente',
                            child: Text('Lavado urgente'),
                          ),
                          DropdownMenuItem(
                            value: 'lavado_secado_urgente',
                            child: Text('Lavado y secado urgente'),
                          ),
                          DropdownMenuItem(
                            value: 'lavado_secado_planchado_urgente',
                            child: Text('Lavado, secado y planchado urgente'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedUrgentOption = value;
                            Utils.lavadoUrgente = value == 'lavado_urgente';
                            Utils.lavadoSecadoUrgente = value == 'lavado_secado_urgente';
                            Utils.lavadoSecadoPlanchadoUrgente = value == 'lavado_secado_planchado_urgente';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const YMargin(10.0),
          // Client Pickup and Delivery Times
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.screenBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderGrey, width: 1.4),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Horas propuestas (opcional):',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimeSelector(
                  label: 'Hora de recogida propuesta',
                  value: Utils.pickupTimeClientController.text.isNotEmpty
                      ? _formatDateTimeForDisplay(DateTime.parse(Utils.pickupTimeClientController.text))
                      : 'Selecciona una hora',
                  onTap: () {
                    Utils.selectDateAndTime(context, (dateTime) {
                      String isoFormat = _formatDateTimeForAPI(dateTime);
                      setState(() {
                        Utils.pickupTimeClientController.text = isoFormat;
                        Utils.serviceScheduleDateController.text = isoFormat;
                      });
                    });
                  },
                ),
                const SizedBox(height: 16),
                Divider(color: AppColors.borderGrey.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                _buildTimeSelector(
                  label: 'Hora de entrega propuesta',
                  value: Utils.deliveryTimeClientController.text.isNotEmpty
                      ? _formatDateTimeForDisplay(DateTime.parse(Utils.deliveryTimeClientController.text))
                      : 'Selecciona una hora',
                  onTap: () {
                    Utils.selectDateAndTime(context, (dateTime) {
                      String isoFormat = _formatDateTimeForAPI(dateTime);
                      setState(() {
                        Utils.deliveryTimeClientController.text = isoFormat;
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          const YMargin(10.0),
          CustomTextFieldWidget(
            controller: Utils.specialInstructionsController,
            maxLength: 200,
            fillcolour: AppColors.white,
            hintColor: AppColors.grey,
            maxLines: 6,
            keyboardType: TextInputType.text,
            isVisible: true,
            hintText: AppStrings.specialInstructions,
            onChanged: (v) {},
          ),
          // Sección de método de pago
          const YMargin(30.0),
          const Divider(color: AppColors.tertiary, thickness: 2, height: 20),
          const YMargin(10.0),
          Center(
            child: CustomText(
              text: 'Método de pago',
              fontSize: 24.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ).setText(),
          ),
          const YMargin(20.0),
          _buildPaymentMethodSelector(),
          // Sección de dirección
          const YMargin(10.0),
          const Divider(
            color: AppColors.white,
            thickness: 2,
          ),
          const YMargin(10.0),
          Center(
            child: CustomText(
              text: 'Confirmar dirección',
              fontSize: 24.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ).setText(),
          ),
          const YMargin(20.0),
          _buildUserInfoWidget(),
          const YMargin(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PrimaryButton.secondaryIconbutton(
                  color: AppColors.secondary,
                  text: AppStrings.clear,
                  onpressed: clear,
                ),
              ),
              const SizedBox(width: 10),
              BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
                // Since OrderLoading is no longer emitted, handle loading state manually
                if (state is OrderFailure) {
                  debugPrint("❌ OrderFailure detectado: ${state.errorMessage}");
                  setState(() {
                    _isCreatingOrder = false;
                  });
                  Utils.showSnackbar(
                    duration: 3000,
                    msg: state.errorMessage,
                    context: context,
                  );
                } else if (state is OrderSuccess) {
                  debugPrint("✅ OrderSuccess detectado");
                  setState(() {
                    _isCreatingOrder = false;
                  });

                  if (state.orderResponse != null) {
                    debugPrint("🎉 Pedido creado exitosamente con ID: ${state.orderResponse!.ordenId}");
                    clear();

                    // Mostrar alerta de "Pedido realizado"
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Pedido realizado',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Su pedido ha sido creado exitosamente',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Limpiar el estado del OrderBloc y navegar
                                context.read<OrderBloc>().add(const OrderInitialEvent());
                                // Usar Future para asegurar que el estado se limpie antes de navegar
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  context.router.replaceAll([const MyOrders()]);
                                });
                              },
                              child: const Text(
                                'Ver mis pedidos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              }, buildWhen: (previous, current) {
                // Solo reconstruir si hay cambios en el estado que afecten la UI del botón
                return current is OrderFailure ||
                    (current is OrderSuccess && current.orderResponse != null) ||
                    current is OrderInitial;
              }, builder: (context, state) {
                return Expanded(
                  child: PrimaryButton.secondaryIconbutton(
                    color: _isCreatingOrder ? AppColors.grey : AppColors.secondary,
                    text: _isCreatingOrder ? 'Procesando...' : AppStrings.requestOrder,
                    onpressed: _isCreatingOrder
                        ? null
                        : () {
                            _handleOrderRequest();
                          },
                  ),
                );
              })
            ],
          ),
          const YMargin(4.0),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String value,
    required Function() onTap,
  }) {
    bool isSelected = value != 'Selecciona una hora';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF7EB5D6) : const Color(0xFFE4E6E7),
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: isSelected ? const Color(0xFF7EB5D6) : const Color(0xFF9CA3AF),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF324D88) : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 28,
              color: Color(0xFF324D88),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    if (_paymentMethods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey, width: 1.4),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.credit_card_off, color: AppColors.textSecondary, size: 26),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sin métodos de pago",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Agrega un método de pago para continuar",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryButton.secondaryIconbutton(
              color: AppColors.secondary,
              text: "Agregar",
              onpressed: () {
                context.router.push(const PaymentMethods());
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey, width: 1.3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selecciona método de pago",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._paymentMethods.map((paymentMethod) {
            final isSelected = _selectedPaymentMethod?.id == paymentMethod.id;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedPaymentMethod = paymentMethod);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary.withValues(alpha: 0.12) : AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.borderGrey,
                      width: isSelected ? 2 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _getPaymentMethodIcon(paymentMethod.brand),
                        color: _getPaymentMethodIconColor(paymentMethod.brand),
                        size: 26,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "**** **** **** ${paymentMethod.last4}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${paymentMethod.brand.toUpperCase()} • ${paymentMethod.expiryMonth.toString().padLeft(2, '0')}/${paymentMethod.expiryYear}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (paymentMethod.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Principal",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Center(
            child: PrimaryButton.secondaryIconbutton(
              color: AppColors.secondary,
              text: "Administrar métodos de pago",
              onpressed: () {
                context.router.push(const PaymentMethods());
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentMethodIconColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71); // Azul oficial de Visa
      case 'mastercard':
        return const Color(0xFFEB001B); // Rojo oficial de Mastercard
      case 'amex':
        return const Color(0xFF3498D8); // Azul de American Express
      default:
        return AppColors.primary;
    }
  }

  void _handleOrderRequest() {
    // Validar campos requeridos (instrucciones especiales es opcional)
    if (Utils.approxWeightController.text.isEmpty ||
        Utils.detergentTypeController.text.isEmpty ||
        Utils.dryingMethodTypeController.text.isEmpty ||
        Utils.serviceScheduleDateController.text.isEmpty) {
      Utils.showSnackbar(
        msg: "Por favor, complete todos los campos obligatorios antes de continuar.",
        context: context,
      );
      return;
    }

    // Validar método de pago seleccionado
    if (_selectedPaymentMethod == null) {
      Utils.showSnackbar(
        msg: "Por favor, selecciona un método de pago antes de continuar.",
        context: context,
      );
      return;
    }

    // Validar dirección
    if (Utils.calleController.text.isEmpty ||
        Utils.numExtController.text.isEmpty ||
        Utils.coloniaController.text.isEmpty) {
      Utils.showSnackbar(
        msg: "Por favor, completa la información de dirección antes de continuar.",
        context: context,
      );
      return;
    }

    // Si ya se está procesando un pedido, no permitir duplicados
    if (_isCreatingOrder) {
      debugPrint("⚠️ Ya se está procesando un pedido, ignorando...");
      return;
    }

    // Set loading state manually since OrderLoading is no longer emitted
    setState(() {
      _isCreatingOrder = true;
    });

    // Construir dirección completa
    String direccionCompleta = "${Utils.calleController.text} ${Utils.numExtController.text}";
    if (Utils.numIntController.text.isNotEmpty) {
      direccionCompleta += " Int. ${Utils.numIntController.text}";
    }
    direccionCompleta += ", ${Utils.coloniaController.text}";

    // Coordenadas por defecto (puedes implementar geolocalización aquí)
    double lat = 19.4326; // Coordenadas de ejemplo para México
    double lon = -99.1332;

    debugPrint("🚀 Creando pedido con método de pago ID: ${_selectedPaymentMethod!.id}");
    debugPrint("🚀 Dirección: $direccionCompleta");
    debugPrint("🚀 Coordenadas: $lat, $lon");

    // Usar el payment method ID directamente como string (IDs de Stripe son strings)
    String paymentMethodId = _selectedPaymentMethod!.id;

    debugPrint("🚀 Disparando CreateOrderEvent al OrderBloc...");
    context.read<OrderBloc>().add(
          CreateOrderEvent(CreateUserOrderRequest(
            token: Utils.getAuthenticationToken(),
            fechaProgramada: Utils.serviceScheduleDateController.text,
            pesoAproximadoKg: double.tryParse(Utils.approxWeightController.text) ?? 0.0,
            tipoDetergente: Utils.detergentTypeController.text,
            suavizante: Utils.suavizante,
            metodoSecado: Utils.dryingMethodTypeController.text,
            tipoPlanchado: Utils.selectedIroningType,
            numeroPrendasPlanchado: int.tryParse(Utils.ironingNumberController.text) ?? 0,
            instruccionesEspeciales: Utils.specialInstructionsController.text,
            paymentMethodId: paymentMethodId,
            lat: lat,
            lon: lon,
            direccion: direccionCompleta,
            fechaRecogidaPropuestaCliente:
                Utils.pickupTimeClientController.text.isNotEmpty ? Utils.pickupTimeClientController.text : null,
            fechaEntregaPropuestaCliente:
                Utils.deliveryTimeClientController.text.isNotEmpty ? Utils.deliveryTimeClientController.text : null,
            lavadoUrgente: Utils.lavadoUrgente,
            lavadoSecadoUrgente: Utils.lavadoSecadoUrgente,
            lavadoSecadoPlanchadoUrgente: Utils.lavadoSecadoPlanchadoUrgente,
          )),
        );
  }

  void clear() {
    Utils.approxWeightController.clear();
    Utils.detergentTypeController.clear();
    Utils.dryingMethodTypeController.clear();
    Utils.serviceScheduleDateController.clear();
    Utils.specialInstructionsController.clear();
    Utils.pickupTimeClientController.clear();
    Utils.deliveryTimeClientController.clear();
    Utils.ironingNumberController.clear();
    setState(() {
      selectedDateTime = '';
      selectedUrgentOption = null;
      _selectedPaymentMethod = _paymentMethods.isNotEmpty ? _paymentMethods.first : null;
      Utils.suavizante = false;
      Utils.lavadoUrgente = false;
      Utils.lavadoSecadoUrgente = false;
      Utils.lavadoSecadoPlanchadoUrgente = false;
      Utils.selectedIroningType = null;
    });
  }

  Widget _buildUserInfoWidget() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      buildWhen: (previous, current) => current is UserInfoSuccess,
      builder: (context, state) {
        // Pre-fill the controllers when user info is loaded
        if (state is UserInfoSuccess && state.userWorkerInfo?.data != null) {
          final data = state.userWorkerInfo!.data!;
          Utils.calleController.text = data.calle ?? '';
          Utils.numExtController.text = data.numeroexterior ?? '';
          Utils.numIntController.text = data.numerointerior ?? '';
          Utils.coloniaController.text = data.colonia ?? '';
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.router.push(const UserProviderPersonalInfo()),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 20, color: AppColors.secondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      AppStrings.street,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CustomTextFieldWidget(
                controller: Utils.calleController,
                maxLength: 100,
                fillcolour: AppColors.white,
                hintColor: AppColors.textSecondary,
                maxLines: 1,
                isVisible: true,
                readOnly: true,
                prefixWidget: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.location_on_outlined, size: 22, color: AppColors.secondary),
                ),
                hintText: (state is UserInfoSuccess)
                    ? state.userWorkerInfo?.data?.calle.toString() ?? ""
                    : AppStrings.addressStreet,
                onChanged: (v) {},
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 0.5),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: AppStrings.exteriorNumber,
                          fontSize: 16.0,
                          fontColor: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ).setText(),
                        const SizedBox(height: 6),
                        CustomTextFieldWidget(
                          controller: Utils.numExtController,
                          maxLength: 100,
                          suffixWidget: null,
                          fillcolour: AppColors.white,
                          hintColor: AppColors.textSecondary,
                          maxLines: 1,
                          readOnly: true,
                          isVisible: true,
                          hintText: (state is UserInfoSuccess)
                              ? state.userWorkerInfo?.data?.numeroexterior.toString() ?? ""
                              : "Ex 50",
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: AppStrings.interiorNumber,
                          fontSize: 16.0,
                          fontColor: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ).setText(),
                        const SizedBox(height: 6),
                        CustomTextFieldWidget(
                          controller: Utils.numIntController,
                          maxLength: 100,
                          fillcolour: AppColors.white,
                          hintColor: AppColors.textSecondary,
                          maxLines: 1,
                          suffixWidget: null,
                          isVisible: true,
                          readOnly: true,
                          hintText: (state is UserInfoSuccess)
                              ? state.userWorkerInfo?.data?.numerointerior.toString() ?? ""
                              : "Ex 20",
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 0.5),
              const SizedBox(height: 10),
              const Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    AppStrings.neighborhood,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomTextFieldWidget(
                controller: Utils.coloniaController,
                maxLength: 100,
                fillcolour: AppColors.white,
                hintColor: AppColors.textSecondary,
                prefixWidget: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.home_outlined, size: 20, color: AppColors.secondary),
                ),
                maxLines: 1,
                isVisible: true,
                readOnly: true,
                hintText: (state is UserInfoSuccess) ? state.userWorkerInfo?.data?.colonia.toString() ?? "" : "",
                onChanged: (v) {},
              ),
            ],
          ),
        );
      },
    );
  }
}
