import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_dialog.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/request/user/payment_method_request.dart';
import '../../../data/models/response/user/payment_method_response.dart';
import '../../../data/repositories/user_repo.dart';
import '../../../dependencyInjection/di.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import 'add_payment_method_screen.dart';

@RoutePage()
class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  List<PaymentMethodData> _paymentMethods = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint("🚀 PaymentMethods page initialized");
    _loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.menuPaymentMethods,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.menuPaymentMethods,
        ontap: () {
          debugPrint("Drawer clicked");
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const YMargin(16.0),
                  Expanded(
                    child: _paymentMethods.isEmpty ? _buildEmptyState() : _buildPaymentMethodsCard(),
                  ),
                  // Botón para agregar método de pago
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton.primarybutton(
                        text: "AGREGAR MÉTODO DE PAGO",
                        onpressed: _showAddPaymentMethodDialog,
                        isPrimary: true,
                        isEnable: true,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.credit_card, size: 70, color: AppColors.secondary),
            ),
            const SizedBox(height: 26),
            CustomText(
              text: "No tienes métodos de pago",
              fontSize: 24.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ).setText(),
            const SizedBox(height: 10),
            CustomText(
              text: "Agrega una tarjeta para guardar tus datos de pago de manera segura.",
              fontSize: 16.0,
              fontColor: AppColors.textSecondary,
              textAlign: TextAlign.center,
              maxLines: 3,
            ).setText(),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton.secondaryIconbutton(
                color: AppColors.secondary,
                text: "AGREGAR MÉTODO",
                onpressed: _showAddPaymentMethodDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Métodos de pago",
                fontSize: 22.0,
                fontWeight: FontWeight.w800,
                fontColor: AppColors.primary,
              ).setText(),
              const YMargin(8.0),
              CustomText(
                text: "Administra tus tarjetas guardadas",
                fontSize: 16.0,
                fontColor: AppColors.textSecondary,
              ).setText(),
            ],
          ),
        ),
        const YMargin(10.0),
        Expanded(
          child: ListView.separated(
            itemCount: _paymentMethods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final paymentMethod = _paymentMethods[index];
              return _buildPaymentMethodItem(paymentMethod, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodData paymentMethod, int index) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: paymentMethod.isDefault ? AppColors.secondary : AppColors.borderGrey,
          width: paymentMethod.isDefault ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getPaymentMethodIconColor(paymentMethod.brand).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentMethodIcon(paymentMethod.brand),
                  color: _getPaymentMethodIconColor(paymentMethod.brand),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "**** **** **** ${paymentMethod.last4}",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontColor: AppColors.primary,
                    ).setText(),
                    const SizedBox(height: 4),
                    CustomText(
                      text:
                          "${paymentMethod.brand.toUpperCase()} • ${paymentMethod.expiryMonth.toString().padLeft(2, '0')}/${paymentMethod.expiryYear}",
                      fontSize: 14.0,
                      fontColor: AppColors.textSecondary,
                    ).setText(),
                  ],
                ),
              ),
              Column(
                children: [
                  if (paymentMethod.isDefault)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CustomText(
                            text: "Principal",
                            fontSize: 10.0,
                            fontColor: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ).setText(),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: paymentMethod.isDefault ? null : () => _showSetAsDefaultDialog(paymentMethod),
                        child: Icon(
                          paymentMethod.isDefault ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(paymentMethod),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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

  void _showAddPaymentMethodDialog() {
    if (!mounted || !context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Column(
          children: [
            const Icon(
              Icons.credit_card,
              size: 48.0,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8.0),
            CustomText(
              text: "Agregar Método de Pago",
              fontSize: 20.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ).setText(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CustomText(
                text: "Selecciona el tipo de método de pago que deseas agregar",
                fontSize: 16.0,
                fontColor: AppColors.primary.withOpacity(0.8),
                textAlign: TextAlign.center,
                maxLines: 3,
              ).setText(),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton.primarybutton(
                text: "TARJETA DE CRÉDITO/DÉBITO",
                onpressed: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    _navigateToAddPaymentMethod();
                  }
                },
                isPrimary: true,
                isEnable: true,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToAddPaymentMethod() async {
    if (!mounted || !context.mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPaymentMethodScreen(),
      ),
    );

    // If payment method was added successfully, reload the list
    if (result == true) {
      await _loadPaymentMethods();
    }
  }

  // Usando el mismo patrón de API call que la página de nuevo pedido
  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    debugPrint("🔍 Loading Stripe payment methods...");

    try {
      final token = Utils.getAuthenticationToken();

      if (token.isEmpty) {
        debugPrint("❌ No token found");
        setState(() {
          _isLoading = false;
          _paymentMethods = [];
        });
        return;
      }

      debugPrint("🔑 Token found: ${token.substring(0, 10)}...");

      // Use the new secure Stripe API
      final userRepo = AppContainer.getIt.get<UserRepo>();
      final request = GetPaymentMethodsRequest(token: token);
      final response = await userRepo.getPaymentMethods(request);

      setState(() {
        _isLoading = false;
      });

      if (response.data != null) {
        final paymentMethods = response.data!.paymentMethods;

        debugPrint("✅ Found ${paymentMethods.length} Stripe payment methods");

        // Convert from Stripe payment method format
        List<PaymentMethodData> parsedPaymentMethods = [];
        for (var pm in paymentMethods) {
          try {
            final paymentMethodData = PaymentMethodData(
              id: pm.id,
              type: pm.type,
              brand: pm.brand ?? 'unknown',
              last4: pm.last4 ?? '****',
              expiryMonth: int.tryParse(pm.expiryMonth?.toString() ?? '0') ?? 0,
              expiryYear: int.tryParse(pm.expiryYear?.toString() ?? '0') ?? 0,
              isDefault: pm.isDefault ?? false,
            );
            parsedPaymentMethods.add(paymentMethodData);
            debugPrint("✅ Parsed Stripe payment method: ${paymentMethodData.id}");
          } catch (e) {
            debugPrint("❌ Error parsing Stripe payment method: $e");
          }
        }

        setState(() {
          _paymentMethods = parsedPaymentMethods;
        });

        debugPrint("✅ Successfully loaded ${_paymentMethods.length} Stripe payment methods");
      } else {
        debugPrint("❌ Stripe payment methods API error: ${response.errorMessage}");
        if (mounted) {
          _showErrorDialog(response.errorMessage ?? "Error al cargar métodos de pago");
        }
        setState(() {
          _paymentMethods = [];
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _paymentMethods = [];
      });
      debugPrint("💥 Error loading Stripe payment methods: $e");
      if (mounted) {
        _showErrorDialog("Error al cargar métodos de pago: $e");
      }
    }
  }

  void _showSetAsDefaultDialog(PaymentMethodData paymentMethod) {
    if (!mounted || !context.mounted) return;

    const DialogCustom().getCustomDialog(
      null,
      title: "Establecer como principal",
      subtitle: "¿Deseas establecer este método de pago como tu opción principal?",
      cancelEnable: true,
      context: context,
      onCancel: () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      onSuccess: () async {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        _setAsDefault(paymentMethod);
      },
    );
  }

  void _showDeleteDialog(PaymentMethodData paymentMethod) {
    if (!mounted || !context.mounted) return;

    const DialogCustom().getCustomDialog(
      null,
      title: "Eliminar método de pago",
      subtitle: "¿Estás seguro de que deseas eliminar este método de pago?",
      cancelEnable: true,
      context: context,
      onCancel: () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      onSuccess: () async {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        _deletePaymentMethodConfirmed(paymentMethod);
      },
    );
  }

  void _setAsDefault(PaymentMethodData paymentMethod) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final request = SetDefaultPaymentMethodRequest(
        token: token,
        paymentMethodId: paymentMethod.id,
      );

      final userRepo = AppContainer.getIt.get<UserRepo>();
      final response = await userRepo.setDefaultPaymentMethod(request);

      if (response.data != null) {
        // Recargar la lista de métodos de pago para reflejar el cambio
        _loadPaymentMethods();
        if (mounted) {
          Utils.showSnackbar(
            msg: "Método de pago establecido como principal",
            context: context,
          );
        }
      } else {
        if (mounted) {
          _showErrorDialog(response.errorMessage ?? 'Error al establecer método principal');
        }
      }
    } catch (e) {
      debugPrint("Error setting default payment method: $e");
      if (mounted) {
        _showErrorDialog("Error al establecer método principal");
      }
    }
  }

  void _deletePaymentMethodConfirmed(PaymentMethodData paymentMethod) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final request = DeletePaymentMethodRequest(
        token: token,
        paymentMethodId: paymentMethod.id,
      );

      final userRepo = AppContainer.getIt.get<UserRepo>();
      final response = await userRepo.deletePaymentMethod(request);

      if (response.data != null) {
        setState(() {
          _paymentMethods.removeWhere((pm) => pm.id == paymentMethod.id);
        });
        if (mounted) {
          Utils.showSnackbar(
            msg: "Método de pago eliminado",
            context: context,
          );
        }
      } else {
        if (mounted) {
          // Translate common error messages
          String errorMessage = response.errorMessage ?? 'Error al eliminar método de pago';
          if (errorMessage.contains('not found') || errorMessage.contains('already deleted')) {
            errorMessage = 'El método de pago no existe o ya fue eliminado';
          } else if (errorMessage.contains('does not belong')) {
            errorMessage = 'Este método de pago no pertenece a tu cuenta';
          } else if (errorMessage.contains('invalid')) {
            errorMessage = 'ID de método de pago inválido';
          }
          _showErrorDialog(errorMessage);
        }
      }
    } catch (e) {
      debugPrint("Error deleting payment method: $e");
      if (mounted) {
        _showErrorDialog("Error de conexión al eliminar método de pago. Por favor intenta de nuevo.");
      }
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
