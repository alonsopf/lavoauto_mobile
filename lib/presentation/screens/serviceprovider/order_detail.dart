import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/assets.dart';
import '../../../data/models/request/worker/collect_order_modal.dart';
import '../../../data/models/request/worker/deliver_order_modal.dart';
import '../../../data/models/request/rating/rate_client_modal.dart';
import '../../../data/models/response/worker/my_work_response_modal.dart';
import '../../../data/models/request/worker/order_details_modal.dart';
import '../../../dependencyInjection/di.dart';
import '../../../data/repositories/worker_repo.dart';
import '../../../theme/app_color.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/text_field.dart';
import '../../common_widgets/rating_widget.dart';

@RoutePage()
class OrderDetail extends StatefulWidget {
  final MyWorkOrder order;

  const OrderDetail({super.key, required this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final TextEditingController _pesoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? _calculatedTotal;
  double? _calculatedCommission;
  double? _calculatedNet;
  double? _precioPorKg; // Preferir el valor de detalle si no viene en MyWorkOrder
  dynamic _loader; // Mantener referencia al loader para poder ocultarlo correctamente

  @override
  void initState() {
    super.initState();
    _pesoController.addListener(_recalculateTotals);
    // Si no viene el precio en la lista, intentar obtenerlo del endpoint de detalles
    if (widget.order.precioPorKg != null) {
      _precioPorKg = widget.order.precioPorKg;
    } else {
      _fetchPrecioPorKg();
    }
  }

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _fetchPrecioPorKg() async {
    try {
      final token = Utils.getAuthenticationToken() ?? '';
      if (token.isEmpty) return;
      final repo = AppContainer.getIt<WorkerRepo>();
      final res = await repo.getOrderDetails(
        OrderDetailsRequest(token: token, orderId: widget.order.ordenId),
      );
      final detail = res.data?.orders?.isNotEmpty == true ? res.data!.orders!.first : null;
      if (detail?.precioPorKg != null) {
        setState(() {
          _precioPorKg = detail!.precioPorKg;
        });
        _recalculateTotals();
      }
    } catch (_) {
      // Silenciar; si falla, mantenemos "No disponible"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: "Detalle de Orden #${widget.order.ordenId}",
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset(
              Assets.placeholderUserPhoto,
              height: 40.0,
              width: 40.0,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesLoading) {
            // Inserta loader solo una vez y conserva la referencia
            _loader ??= Loader.getLoader(context);
            Loader.insertLoader(context, _loader);
          } else if (state is ServicesFailure) {
            if (_loader != null) {
              Loader.hideLoader(_loader);
              _loader = null;
            }
            _showErrorDialog(state.errorMessage);
          } else if (state is CollectOrderSuccess) {
            if (_loader != null) {
              Loader.hideLoader(_loader);
              _loader = null;
            }
            _showSuccessDialog(state.message);
          } else if (state is DeliverOrderSuccess) {
            if (_loader != null) {
              Loader.hideLoader(_loader);
              _loader = null;
            }
            // Reset the BLoC state immediately after success
            context.read<ServicesBloc>().add(const ResetServicesEvent());
            _showRatingDialog(); // Show rating dialog instead of success dialog
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderInfoCard(),
                const YMargin(20.0),
                _buildActionSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.order.estatus),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: CustomText(
                  text: _getStatusDisplayName(widget.order.estatus),
                  fontSize: 12.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ).setText(),
              ),
              const Spacer(),
              CustomText(
                text: "Cliente ID: ${widget.order.clienteId}",
                fontSize: 16.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w600,
              ).setText(),
            ],
          ),
          const YMargin(16.0),
          CustomText(
            text: "Información de la Orden",
            fontSize: 20.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(12.0),
          _buildDetailRow("Peso Aproximado", "${widget.order.pesoAproximadoKg ?? 0.0} kg"),
          _buildDetailRow("Detergente", widget.order.tipoDetergente ?? "No especificado"),
          _buildDetailRow("Método de Secado", widget.order.metodoSecado ?? "No especificado"),
          _buildDetailRow("Fecha Programada", Utils.formatDateTime(widget.order.fechaProgramada)),
          _buildDetailRow("Fecha de Creación", Utils.formatDateTime(widget.order.fechaCreacion)),
          if (widget.order.direccion?.isNotEmpty == true)
            _buildDetailRow("Dirección", widget.order.direccion!),
          if (widget.order.instruccionesEspeciales?.isNotEmpty == true)
            _buildDetailRow("Instrucciones Especiales", widget.order.instruccionesEspeciales!),
          // 💰 Mostrar información de comisión si el pedido está pagado
          if (widget.order.estatus.toLowerCase() == 'completado')
            _buildPaymentInfoSection(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomText(
              text: "$label:",
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ).setText(),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: value,
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w500,
              maxLines: 3,
            ).setText(),
          ),
        ],
      ),
    );
  }

  // Variante con más ancho para el label (ideal para textos largos)
  Widget _buildDetailRowWide(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              text: "$label:",
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ).setText(),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: value,
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w500,
              maxLines: 2,
            ).setText(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoSection() {
    // Calcular ejemplo de comisión (esto vendrá del backend en la respuesta real)
    double weight = widget.order.pesoAproximadoKg ?? 0.0;
    double estimatedTotal = weight * 20.0; // Asumiendo $20/kg
    double platformFee = estimatedTotal * 0.10; // 10%
    double lavadorAmount = estimatedTotal * 0.90; // 90%

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const YMargin(16.0),
        Container(
          width: double.infinity,
          height: 1.0,
          color: AppColors.primary.withOpacity(0.2),
        ),
        const YMargin(16.0),
        CustomText(
          text: "💰 Información de Pago",
          fontSize: 18.0,
          fontColor: AppColors.primary,
          fontWeight: FontWeight.bold,
        ).setText(),
        const YMargin(8.0),
        _buildDetailRow("Monto Total Cobrado", "\$${estimatedTotal.toStringAsFixed(2)}"),
        _buildDetailRow("Comisión Plataforma (10%)", "\$${platformFee.toStringAsFixed(2)}"),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: _buildDetailRow("💚 Tu Ganancia (90%)", "\$${lavadorAmount.toStringAsFixed(2)}"),
        ),
        const YMargin(8.0),
        CustomText(
          text: "* El dinero ya fue transferido automáticamente a tu cuenta de Stripe",
          fontSize: 12.0,
          fontColor: AppColors.primary.withOpacity(0.7),
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ).setText(),
      ],
    );
  }

  Widget _buildActionSection() {
    // Show different UI based on order status
    String status = widget.order.estatus.toLowerCase();
    
    if (status == 'laundry_in_progress') {
      return _buildDeliverySection();
    } else if (status == 'completed' || status == 'completado') {
      return _buildCompletedSection();
    } else {
      return _buildCollectForm();
    }
  }

  Widget _buildCollectForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Recolección de Ropa",
              fontSize: 20.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ).setText(),
            const YMargin(16.0),
            _buildDetailRowWide(
              "Precio aceptado por kg",
              _precioPorKg != null
                  ? "\$${_precioPorKg!.toStringAsFixed(2)}"
                  : "No disponible",
            ),
            const YMargin(8.0),
            CustomText(
              text: "Ingrese el peso real de la ropa:",
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            const YMargin(8.0),
            TextFormField(
              controller: _pesoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: "Ej: 12.34",
                suffixText: "kg",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.secondary, width: 2.0),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (value) {
                _recalculateTotals();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el peso';
                }
                final peso = double.tryParse(value);
                if (peso == null || peso <= 0) {
                  return 'Por favor ingrese un peso válido';
                }
                return null;
              },
            ),
            const YMargin(12.0),
            // Bloque SIEMPRE visible debajo del textfield de peso
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRowWide(
                    "Precio a cobrar a cliente",
                    _calculatedTotal != null
                        ? "\$${_calculatedTotal!.toStringAsFixed(2)}"
                        : "—",
                  ),
                  _buildDetailRowWide(
                    "Comisiones 13.5% (aprox) ",
                    _calculatedCommission != null
                        ? "\$${_calculatedCommission!.toStringAsFixed(2)}"
                        : "—",
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: _buildDetailRowWide(
                      "Precio real a percibir",
                      _calculatedNet != null
                          ? "\$${_calculatedNet!.toStringAsFixed(2)}"
                          : "—",
                    ),
                  ),
                ],
              ),
            ),
            const YMargin(20.0),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton.primarybutton(
                text: "RECOLECTAR ROPA",
                onpressed: _submitCollectOrder,
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

  Widget _buildDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Entrega de Pedido",
            fontSize: 20.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(16.0),
          CustomText(
            text: "La ropa está lista para ser entregada al cliente.",
            fontSize: 16.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w600,
          ).setText(),
          const YMargin(20.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton.primarybutton(
              text: "PEDIDO COMPLETADO",
              onpressed: _showDeliveryConfirmationDialog,
              isPrimary: true,
              isEnable: true,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 28.0,
              ),
              const SizedBox(width: 12.0),
              CustomText(
                text: "Pedido Completado",
                fontSize: 20.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ],
          ),
          const YMargin(16.0),
          CustomText(
            text: "Este pedido ha sido completado exitosamente. La ropa fue entregada al cliente y el servicio ha finalizado.",
            fontSize: 16.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ).setText(),
        ],
      ),
    );
  }

  void _submitCollectOrder() {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text);
      final token = Utils.getAuthenticationToken() ?? '';
      
      final collectRequest = CollectOrderRequest(
        token: token,
        ordenId: widget.order.ordenId,
        pesoFinalKg: peso,
      );

      debugPrint("Collecting order with data: ${collectRequest.toJson()}");
      
      // Dispatch collect order event
      context.read<ServicesBloc>().add(CollectOrderEvent(collectRequest));
    }
  }

  void _recalculateTotals() {
    // Preferir precioPorKg de la orden. Si no está y ya se obtuvo detalle de orden,
    // podría venir como null: en ese caso, no calcular.
    final pricePerKg = _precioPorKg;
    final weight = double.tryParse(_pesoController.text);
    if (pricePerKg == null || weight == null) {
      setState(() {
        _calculatedTotal = null;
        _calculatedCommission = null;
        _calculatedNet = null;
      });
      return;
    }
    final total = pricePerKg * weight;
    final commission = total * 0.135; // 13.5%
    final net = total - commission;
    setState(() {
      _calculatedTotal = total;
      _calculatedCommission = commission;
      _calculatedNet = net;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'puja_accepted':
        return Colors.green.shade700;
      case 'en_proceso':
        return Colors.blue.shade700;
      case 'laundry_in_progress':
        return Colors.orange.shade700;
      case 'completado':
        return Colors.purple.shade700;
      case 'cancelado':
        return Colors.red.shade700;
      default:
        return AppColors.secondary;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'puja_accepted':
        return 'OFERTA ACEPTADA';
      case 'en_proceso':
        return 'EN PROCESO';
      case 'laundry_in_progress':
        return 'LAVADO EN PROGRESO';
      case 'completado':
        return 'COMPLETADO';
      case 'cancelado':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }

  void _showSuccessDialog(String message) {
    const DialogCustom().getCustomDialog(
      null,
      title: "¡Éxito!",
      subtitle: message,
      cancelEnable: false,
      context: context,
      onSuccess: () {
        Navigator.of(context).pop(); // Close dialog
        // Reset the BLoC state to avoid showing the dialog again
        context.read<ServicesBloc>().add(const ResetServicesEvent());
        context.router.maybePop(true); // Go back with result = true to refresh
      },
    );
  }

  void _showErrorDialog(String message) {
    const DialogCustom().getCustomDialog(
      null,
      title: "Error",
      subtitle: message,
      cancelEnable: false,
      context: context,
      onSuccess: () {
        Navigator.of(context).pop(); // Close dialog
        // Reset the BLoC state to clear the error state
        context.read<ServicesBloc>().add(const ResetServicesEvent());
      },
    );
  }

  void _showDeliveryConfirmationDialog() {
    const DialogCustom().getCustomDialog(
      null,
      title: "Confirmar Entrega",
      subtitle: "Certifico que ya entregué la ropa y el cliente está satisfecho",
      cancelEnable: true,
      context: context,
      onCancel: () {
        Navigator.of(context).pop(); // Close dialog
      },
      onSuccess: () {
        Navigator.of(context).pop(); // Close dialog
        _submitDeliverOrder(); // Proceed with delivery
      },
    );
  }

  void _submitDeliverOrder() {
    final token = Utils.getAuthenticationToken() ?? '';
    
    // Validate required fields before creating request
    if (widget.order.ordenId == null || widget.order.ordenId! <= 0) {
      Utils.showSnackbar(
        msg: "Error: Invalid order ID",
        context: context,
        duration: 3000,
      );
      return;
    }

    final deliverRequest = DeliverOrderRequest(
      token: token,
      ordenId: widget.order.ordenId!,
      // Photo delivery is no longer used, so we pass null
      fotoS3Entrega: null,
    );

    debugPrint("Delivering order with platform fee processing: ${deliverRequest.toJson()}");
    
    // 🎯 IMPORTANTE: Este evento ahora procesará el pago con la comisión del 10%
    // El backend automáticamente:
    // 1. Cobrará al cliente el monto total
    // 2. Enviará el 10% a tu cuenta de plataforma 
    // 3. Enviará el 90% a la cuenta del lavador
    context.read<ServicesBloc>().add(DeliverOrderEvent(deliverRequest));
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RatingWidget(
            title: "¡Servicio Completado!",
            subtitle: "¿Cómo calificarías a este cliente?",
            onSubmitRating: (rating, comments) {
              Navigator.of(context).pop(); // Close rating dialog
              _submitClientRating(rating, comments);
            },
            onCancel: () {
              Navigator.of(context).pop(); // Close rating dialog
              // Don't reset state again since it was already reset after DeliverOrderSuccess
              _showSuccessDialog("Pedido completado exitosamente");
            },
          ),
        );
      },
    );
  }

  void _submitClientRating(double rating, String comments) {
    final token = Utils.getAuthenticationToken() ?? '';
    
    final rateRequest = RateClientRequest(
      token: token,
      orderId: widget.order.ordenId,
      rating: rating,
      comentarios: comments,
    );

    // TODO: Add rating event to bloc and handle response
    // For now, just show success dialog
    // Don't reset state again since it was already reset after DeliverOrderSuccess
    _showSuccessDialog("Cliente calificado exitosamente con $rating estrellas");
  }
} 