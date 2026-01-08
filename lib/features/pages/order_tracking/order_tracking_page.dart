import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';
import 'package:lavoauto/data/models/request/worker/collect_order_modal.dart';
import 'package:lavoauto/data/models/request/worker/deliver_order_modal.dart';
import 'package:lavoauto/data/models/request/worker/my_work_request_modal.dart';
import 'package:lavoauto/data/models/response/worker/my_work_response_modal.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class OrderTrackingPage extends StatefulWidget {
  final MyWorkOrder order;

  const OrderTrackingPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  String? selectedStatus;
  bool _isSubmitting = false;
  final TextEditingController _weightController = TextEditingController();

  final List<Map<String, dynamic>> statusOptions = [
    {'value': 'recogida', 'label': 'Ropa recogida'},
    {'value': 'en_lavado', 'label': 'En lavado'},
    {'value': 'en_camino_entrega', 'label': 'En camino a entrega'},
    {'value': 'entregado', 'label': 'Entregado'},
  ];

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set current status as default
    selectedStatus = _getCurrentStatusValue(widget.order.estatus);
  }

  String _getCurrentStatusValue(String currentStatus) {
    final status = currentStatus.toLowerCase();
    if (status.contains('recog')) return 'recogida';
    if (status.contains('lavado') || status.contains('lavand'))
      return 'en_lavado';
    if (status.contains('camino')) return 'en_camino_entrega';
    if (status.contains('entrega')) return 'entregado';
    return 'recogida';
  }

  void _updateOrderStatus() async {
    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un estado'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate weight for "recogida" status
    if (selectedStatus == 'recogida') {
      if (_weightController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingresa el peso final de la ropa'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final weight = double.tryParse(_weightController.text);
      if (weight == null || weight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingresa un peso válido'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      final token = Utils.getAuthenticationToken();

      // Depending on the selected status, call the appropriate API
      if (selectedStatus == 'recogida') {
        final weight = double.parse(_weightController.text);
        // Call collect order API
        final request = CollectOrderRequest(
          token: token,
          ordenId: widget.order.ordenId,
          pesoFinalKg: weight,
        );
        context.read<ServicesBloc>().add(CollectOrderEvent(request));
      } else if (selectedStatus == 'entregado') {
        // Show confirmation dialog with total cost
        final costoFinal = widget.order.costoFinal ?? 0.0;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar entrega'),
            content: Text(
              '¿Confirmas que has entregado el pedido?\n\n'
              'Se cobrará al cliente: \$${costoFinal.toStringAsFixed(2)} MXN\n\n'
              'Este cobro se procesará automáticamente vía Stripe.',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNew,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );

        if (confirmed != true) {
          setState(() => _isSubmitting = false);
          return;
        }

        // Call deliver order API
        final request = DeliverOrderRequest(
          token: token,
          ordenId: widget.order.ordenId,
          fotoS3Entrega: null, // Optional photo
        );
        context.read<ServicesBloc>().add(DeliverOrderEvent(request));
      } else {
        // For intermediate states, show success (would need backend support)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Estado actualizado exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
        return;
      }

      // Listen for the collect/deliver response
      final subscription = context.read<ServicesBloc>().stream.listen((state) {
        if (state is CollectOrderSuccess || state is DeliverOrderSuccess) {
          if (mounted) {
            final message = state is CollectOrderSuccess
                ? state.message
                : (state as DeliverOrderSuccess).message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.success,
              ),
            );

            // Trigger refresh of work orders before navigating back
            final token = Utils.getAuthenticationToken();
            context
                .read<ServicesBloc>()
                .add(FetchMyWorkEvent(MyWorkRequest(token: token)));

            Navigator.pop(context);
          }
        } else if (state is ServicesFailure) {
          if (mounted) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      });

      // Cancel subscription after timeout
      Future.delayed(const Duration(seconds: 5), () {
        subscription.cancel();
        if (mounted && _isSubmitting) {
          setState(() => _isSubmitting = false);
        }
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
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
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.primaryNew, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Seguimiento del\nPedido",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Status options
            ...statusOptions.map((option) {
              final isSelected = selectedStatus == option['value'];
              final isCurrentOrPast =
                  _isStatusCurrentOrPast(option['value'] as String);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = option['value'] as String;
                    });
                  },
                  child: Row(
                    children: [
                      // Radio circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryNew
                                : AppColors.grey,
                            width: 2,
                          ),
                          color: isSelected
                              ? AppColors.primaryNew
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.circle,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Label
                      Expanded(
                        child: Text(
                          option['label'] as String,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.black
                                : AppColors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            // Weight input field (only show when "Ropa recogida" is selected)
            if (selectedStatus == 'recogida') ...[
              const Text(
                "Peso final de la ropa (kg)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ingresa el peso en kg",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.borderGrey, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.borderGrey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryNew, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 30),
            ],
            // Action buttons - Single save button at the bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNew,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isSubmitting ? null : _updateOrderStatus,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _getButtonLabel(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonLabel() {
    switch (selectedStatus) {
      case 'recogida':
        return 'Ropa recogida';
      case 'en_lavado':
        return 'En lavado';
      case 'en_camino_entrega':
        return 'En camino a entrega';
      case 'entregado':
        return 'Entregado';
      default:
        return 'Guardar';
    }
  }

  bool _isStatusCurrentOrPast(String statusValue) {
    final statusOrder = [
      'recogida',
      'en_lavado',
      'en_camino_entrega',
      'entregado'
    ];
    final currentIndex =
        statusOrder.indexOf(_getCurrentStatusValue(widget.order.estatus));
    final checkIndex = statusOrder.indexOf(statusValue);
    return checkIndex <= currentIndex;
  }
}
