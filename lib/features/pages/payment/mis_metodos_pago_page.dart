import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe_sdk;
import 'package:lavoauto/data/models/request/user/payment_method_request.dart';
import 'package:lavoauto/data/models/response/user/payment_method_response.dart';
import 'package:lavoauto/data/repositories/user_repo.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class MisMetodosPagoPage extends StatefulWidget {
  const MisMetodosPagoPage({super.key});

  @override
  State<MisMetodosPagoPage> createState() => _MisMetodosPagoPageState();
}

class _MisMetodosPagoPageState extends State<MisMetodosPagoPage> {
  late UserRepo _userRepo;
  List<PaymentMethodData> _paymentMethods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userRepo = AppContainer.getIt.get<UserRepo>();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final request = GetPaymentMethodsRequest(token: token);
      final response = await _userRepo.getPaymentMethods(request);

      if (response.data != null && response.data!.paymentMethods.isNotEmpty) {
        setState(() {
          _paymentMethods = response.data!.paymentMethods;
          _isLoading = false;
        });
      } else {
        setState(() {
          _paymentMethods = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error loading payment methods: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mis Métodos de Pago",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryNew),
            onPressed: _loadPaymentMethods,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryNew,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPaymentMethods,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_paymentMethods.isEmpty)
                        _buildEmptyState()
                      else
                        _buildPaymentMethodsList(),
                      const SizedBox(height: 20),
                      // Add new payment method button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showAddCardBottomSheet,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            _paymentMethods.isEmpty
                                ? "Agregar Tarjeta"
                                : "Agregar Otra Tarjeta",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNew,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Security info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            "Pagos seguros con Stripe",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryNew.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.credit_card_off,
              size: 60,
              color: AppColors.primaryNew,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No tienes métodos de pago",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNewDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Agrega una tarjeta para poder solicitar servicios de lavado",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    return Column(
      children: _paymentMethods.map((pm) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getCardColor(pm.brand).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: _getCardColor(pm.brand),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${pm.brand.toUpperCase()} •••• ${pm.last4}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          if (pm.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryNew.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Principal",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryNew,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Vence ${pm.expiryMonth.toString().padLeft(2, '0')}/${pm.expiryYear}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.grey),
                  onSelected: (value) {
                    if (value == 'default') {
                      _setDefaultPaymentMethod(pm.id);
                    } else if (value == 'delete') {
                      _confirmDeletePaymentMethod(pm);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!pm.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 20),
                            SizedBox(width: 8),
                            Text('Hacer principal'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getCardColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF3498D8);
      default:
        return AppColors.primaryNew;
    }
  }

  Future<void> _setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      final token = Utils.getAuthenticationToken();
      final request = SetDefaultPaymentMethodRequest(
        token: token,
        paymentMethodId: paymentMethodId,
      );
      final response = await _userRepo.setDefaultPaymentMethod(request);

      if (response.data == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Método de pago actualizado'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadPaymentMethods();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Error al actualizar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDeletePaymentMethod(PaymentMethodData pm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarjeta'),
        content: Text(
          '¿Estás seguro que deseas eliminar la tarjeta ${pm.brand.toUpperCase()} •••• ${pm.last4}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePaymentMethod(pm.id);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePaymentMethod(String paymentMethodId) async {
    try {
      final token = Utils.getAuthenticationToken();
      final request = DeletePaymentMethodRequest(
        token: token,
        paymentMethodId: paymentMethodId,
      );
      final response = await _userRepo.deletePaymentMethod(request);

      if (response.data == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarjeta eliminada'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadPaymentMethods();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Error al eliminar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddCardBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddCardBottomSheet(
        onCardAdded: () {
          Navigator.pop(context);
          _loadPaymentMethods();
        },
      ),
    );
  }
}

class _AddCardBottomSheet extends StatefulWidget {
  final VoidCallback onCardAdded;

  const _AddCardBottomSheet({required this.onCardAdded});

  @override
  State<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<_AddCardBottomSheet> {
  stripe_sdk.CardFormEditController? _cardFormController;
  bool _isLoading = false;
  bool _isCardComplete = false;

  @override
  void initState() {
    super.initState();
    _cardFormController = stripe_sdk.CardFormEditController();
  }

  @override
  void dispose() {
    _cardFormController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryNew,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text(
                  "Agregar Tarjeta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                        const Text(
                          "Datos de la Tarjeta",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        stripe_sdk.CardFormField(
                          controller: _cardFormController!,
                          onCardChanged: (card) {
                            setState(() {
                              _isCardComplete = card?.complete ?? false;
                            });
                          },
                          style: stripe_sdk.CardFormStyle(
                            backgroundColor: Colors.white,
                            borderColor: Colors.grey.withOpacity(0.4),
                            borderRadius: 10,
                            borderWidth: 1,
                            textColor: Colors.black,
                            fontSize: 16,
                            placeholderColor: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isLoading || !_isCardComplete)
                          ? null
                          : _addPaymentMethod,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNew,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Agregar Tarjeta",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        "Pago seguro con Stripe",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addPaymentMethod() async {
    if (!_isCardComplete) {
      _showError("Por favor completa todos los datos de la tarjeta");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = Utils.getAuthenticationToken();
      debugPrint("Token obtenido: ${token.isNotEmpty ? 'OK' : 'VACÍO'}");

      if (token.isEmpty) {
        _showError(
            "Error: No se encontró token de autenticación. Inicia sesión nuevamente.");
        setState(() => _isLoading = false);
        return;
      }

      debugPrint("Creando SetupIntent...");

      // Step 1: Create SetupIntent on backend
      final userRepo = AppContainer.getIt.get<UserRepo>();
      final setupIntentRequest = CreateSetupIntentRequest(token: token);
      final setupIntentResponse =
          await userRepo.createSetupIntent(setupIntentRequest);

      debugPrint(
          "SetupIntent response: data=${setupIntentResponse.data != null}, error=${setupIntentResponse.errorMessage}");

      if (setupIntentResponse.data == null) {
        final errorMsg =
            setupIntentResponse.errorMessage ?? 'Error al crear setup intent';
        debugPrint("SetupIntent error: $errorMsg");
        _showError(errorMsg);
        setState(() => _isLoading = false);
        return;
      }

      final clientSecret = setupIntentResponse.data!.clientSecret;
      debugPrint("ClientSecret obtenido: ${clientSecret.substring(0, 20)}...");

      // Step 2: Confirm SetupIntent with Stripe SDK
      debugPrint("Confirmando SetupIntent con Stripe...");
      final result = await stripe_sdk.Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret,
        params: const stripe_sdk.PaymentMethodParams.card(
          paymentMethodData: stripe_sdk.PaymentMethodData(),
        ),
      );

      // Check if setup was successful
      final statusString = result.status.toString().toLowerCase();
      debugPrint("Stripe result status: $statusString");

      if (statusString.contains('succeeded')) {
        debugPrint("Tarjeta agregada exitosamente");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarjeta agregada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onCardAdded();
        }
      } else {
        debugPrint("Estado inesperado: $statusString");
        _showError("Error al confirmar método de pago: $statusString");
      }
    } on stripe_sdk.StripeException catch (e) {
      debugPrint("StripeException: ${e.error.message}");
      final errorMessage = e.error.localizedMessage ??
          e.error.message ??
          "Error de Stripe desconocido";
      _showError(errorMessage);
    } catch (e, stackTrace) {
      debugPrint("Error adding payment method: $e");
      debugPrint("Stack trace: $stackTrace");
      _showError("Error al agregar tarjeta: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
