import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_bloc.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_event.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_state.dart';
import 'package:lavoauto/data/models/vehiculo_model.dart';
import 'package:lavoauto/data/models/request/user/payment_method_request.dart';
import 'package:lavoauto/data/repositories/user_repo.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/order_flow/seleccionar_lavador_page.dart';
import 'package:lavoauto/features/pages/payment/mis_metodos_pago_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class SeleccionarVehiculoPage extends StatefulWidget {
  const SeleccionarVehiculoPage({super.key});

  @override
  State<SeleccionarVehiculoPage> createState() =>
      _SeleccionarVehiculoPageState();
}

class _SeleccionarVehiculoPageState extends State<SeleccionarVehiculoPage> {
  late OrderFlowBloc _orderFlowBloc;
  late UserRepo _userRepo;
  bool _isCheckingPayment = true;
  bool _hasPaymentMethod = false;

  @override
  void initState() {
    super.initState();
    _orderFlowBloc = context.read<OrderFlowBloc>();
    _userRepo = AppContainer.getIt.get<UserRepo>();
    _checkPaymentMethodsFirst();
  }

  Future<void> _checkPaymentMethodsFirst() async {
    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        setState(() {
          _isCheckingPayment = false;
        });
        return;
      }

      final request = GetPaymentMethodsRequest(token: token);
      final response = await _userRepo.getPaymentMethods(request);

      if (response.data != null && response.data!.paymentMethods.isNotEmpty) {
        setState(() {
          _hasPaymentMethod = true;
          _isCheckingPayment = false;
        });
        _loadVehiculos();
      } else {
        setState(() {
          _isCheckingPayment = false;
        });
        // Show modal after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNoPaymentMethodModal();
        });
      }
    } catch (e) {
      print('Error checking payment methods: $e');
      setState(() {
        _isCheckingPayment = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoPaymentMethodModal();
      });
    }
  }

  void _showNoPaymentMethodModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_off,
                size: 60,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Método de Pago Requerido',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Para crear una orden de lavado necesitas tener al menos un método de pago registrado.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MisMetodosPagoPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNew,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Agregar Método de Pago',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadVehiculos() {
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _orderFlowBloc.add(LoadClienteVehiculosForOrderEvent(token));
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
          "Selecciona tu Vehículo",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: _isCheckingPayment
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryNew),
                  SizedBox(height: 16),
                  Text(
                    'Verificando método de pago...',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : !_hasPaymentMethod
              ? const Center(
                  child: Text(
                    'Redirigiendo...',
                    style: TextStyle(color: AppColors.grey),
                  ),
                )
              : BlocConsumer<OrderFlowBloc, OrderFlowState>(
                  bloc: _orderFlowBloc,
                  listener: (context, state) {
                    if (state is OrderFlowError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.error,
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    } else if (state is VehiculoSelectedForOrder) {
                      // Navigate to Step 2 - Select Lavador
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _orderFlowBloc,
                            child: const SeleccionarLavadorPage(),
                          ),
                        ),
                      ).then((_) {
                        // Reload vehicles when returning from lavador selection
                        _loadVehiculos();
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is OrderFlowLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ClienteVehiculosLoadedForOrder) {
                      return _buildVehiculosList(state.vehiculos);
                    }

                    return _buildEmptyState();
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tienes vehículos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega un vehículo desde "Mis Vehículos" para poder crear una orden',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ir a Mis Vehículos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiculosList(List<ClienteVehiculoModel> vehiculos) {
    if (vehiculos.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Paso 1 de 2: Selecciona el vehículo que deseas lavar',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: vehiculos.length,
            itemBuilder: (context, index) {
              final vehiculo = vehiculos[index];
              return _buildVehiculoCard(vehiculo);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVehiculoCard(ClienteVehiculoModel vehiculo) {
    final vehiculoInfo = '${vehiculo.marca} ${vehiculo.modelo}'
        '${vehiculo.alias != null && vehiculo.alias!.isNotEmpty ? ' (${vehiculo.alias})' : ''}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderGrey.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        onTap: () {
          _orderFlowBloc.add(SelectVehiculoEvent(
            vehiculoClienteId: vehiculo.vehiculoClienteId,
            vehiculoInfo: vehiculoInfo,
            categoriaVehiculo: vehiculo.tipoVehiculo,
          ));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Vehicle icon with category-specific background
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(vehiculo.tipoVehiculo).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(vehiculo.tipoVehiculo),
                  size: 32,
                  color: _getCategoryColor(vehiculo.tipoVehiculo),
                ),
              ),
              const SizedBox(width: 16),
              // Vehicle details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehiculo.marca} ${vehiculo.modelo}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNewDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (vehiculo.alias != null && vehiculo.alias!.isNotEmpty)
                      Text(
                        vehiculo.alias!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (vehiculo.color != null && vehiculo.color!.isNotEmpty) ...[
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: _parseColor(vehiculo.color!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vehiculo.color!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                        if (vehiculo.placas != null &&
                            vehiculo.placas!.isNotEmpty) ...[
                          if (vehiculo.color != null && vehiculo.color!.isNotEmpty)
                            const Text(
                              ' • ',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          Text(
                            vehiculo.placas!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'moto':
        return Icons.two_wheeler;
      case 'compacto':
        return Icons.directions_car;
      case 'sedan':
        return Icons.directions_car;
      case 'suv':
        return Icons.airport_shuttle;
      case 'pickup':
        return Icons.local_shipping;
      case 'camionetagrande':
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'moto':
        return Colors.orange;
      case 'compacto':
        return Colors.blue;
      case 'sedan':
        return Colors.green;
      case 'suv':
        return Colors.purple;
      case 'pickup':
        return Colors.red;
      case 'camionetagrande':
        return Colors.brown;
      default:
        return AppColors.primaryNew;
    }
  }

  Color _parseColor(String colorName) {
    // Simple color mapping - can be expanded
    final colorMap = {
      'rojo': Colors.red,
      'azul': Colors.blue,
      'negro': Colors.black,
      'blanco': Colors.white,
      'gris': Colors.grey,
      'plata': Colors.grey[400]!,
      'verde': Colors.green,
      'amarillo': Colors.yellow,
      'naranja': Colors.orange,
      'cafe': Colors.brown,
      'café': Colors.brown,
      'morado': Colors.purple,
      'rosa': Colors.pink,
    };

    return colorMap[colorName.toLowerCase()] ?? AppColors.grey;
  }
}
