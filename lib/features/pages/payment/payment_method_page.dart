import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/order/order_model.dart';
import 'package:lavoauto/data/models/request/user/payment_method_request.dart';
import 'package:lavoauto/data/models/response/user/payment_method_response.dart';
import 'package:lavoauto/data/repositories/user_repo.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/reviewOrder/review_order_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class PaymentMethodPage extends StatefulWidget {
  final OrderModel? orderData;

  const PaymentMethodPage({
    super.key,
    this.orderData,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late UserRepo _userRepo;
  List<PaymentMethodData> _paymentMethods = [];
  PaymentMethodData? _selectedPaymentMethod;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userRepo = AppContainer.getIt.get<UserRepo>();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        setState(() {
          _errorMessage = 'Token no encontrado';
          _isLoading = false;
        });
        return;
      }

      final request = GetPaymentMethodsRequest(token: token);
      final response = await _userRepo.getPaymentMethods(request);

      if (response.data != null && response.data!.paymentMethods.isNotEmpty) {
        setState(() {
          _paymentMethods = response.data!.paymentMethods;
          // Select default or first method
          _selectedPaymentMethod = _paymentMethods.firstWhere(
            (pm) => pm.isDefault,
            orElse: () => _paymentMethods.first,
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No hay métodos de pago guardados';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar métodos de pago: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      const Center(
                        child: Text(
                          "Elige cómo\nquieres pagar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNewDark,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ..._paymentMethods.map((pm) {
                        final isSelected = _selectedPaymentMethod?.id == pm.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = pm;
                              });
                            },
                            child: _paymentCard(
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                    size: 28,
                                    color: isSelected ? AppColors.primaryNew : Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${pm.brand.toUpperCase()} •••• ${pm.last4}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Vence ${pm.expiryMonth}/${pm.expiryYear}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: "Atrás",
                              isPrimary: false,
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: CustomButton(
                              title: "Continuar",
                              isPrimary: true,
                              onTap: () {
                                if (_selectedPaymentMethod != null && widget.orderData != null) {
                                  // Create a copy of the orderData with the selected payment method ID
                                  final updatedOrderData = widget.orderData!.copyWith(
                                    paymentMethodId: _selectedPaymentMethod!.id,
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReviewOrderPage(
                                        orderData: updatedOrderData,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _paymentCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

}
