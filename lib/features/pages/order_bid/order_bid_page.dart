import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/lavador/available_order_detail_bloc.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/data/models/request/lavador/available_order_detail_modal.dart';
import 'package:lavoauto/data/models/request/worker/create_bid_modal.dart';
import 'package:lavoauto/data/models/response/lavador/available_order_detail_response_modal.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class OrderBidPage extends StatefulWidget {
  final int orderId;

  const OrderBidPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderBidPage> createState() => _OrderBidPageState();
}

class _OrderBidPageState extends State<OrderBidPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;
  DateTime? _selectedPickupDate;
  TimeOfDay? _selectedPickupTime;
  DateTime? _selectedDeliveryDate;
  TimeOfDay? _selectedDeliveryTime;

  @override
  void initState() {
    super.initState();
    final token = Utils.getAuthenticationToken();
    context.read<AvailableOrderDetailBloc>().add(
          FetchAvailableOrderDetailEvent(
            AvailableOrderDetailRequest(
              token: token,
              orderId: widget.orderId,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _getServiceType(AvailableOrderDetailResponse order) {
    if (order.metodoSecado.toLowerCase().contains('plancha')) {
      return "Lavado, secado y planchado";
    } else if (order.metodoSecado.isNotEmpty) {
      return "Lavado y secado";
    }
    return "Lavado";
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "No especificado";
    try {
      final date = DateTime.parse(dateTime);
      final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
      final day = date.day;
      final month = months[date.month - 1];
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'p.m.' : 'a.m.';
      return "$day $month, $hour:$minute $period";
    } catch (e) {
      return dateTime;
    }
  }

  Future<void> _selectPickupDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedPickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryNew,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedPickupTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryNew,
                onPrimary: Colors.white,
                surface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedPickupDate = date;
          _selectedPickupTime = time;
        });
      }
    }
  }

  Future<void> _selectDeliveryDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryNew,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedDeliveryTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryNew,
                onPrimary: Colors.white,
                surface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDeliveryDate = date;
          _selectedDeliveryTime = time;
        });
      }
    }
  }

  String _getFormattedDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return "Seleccionar fecha y hora";
    final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    final day = date.day;
    final month = months[date.month - 1];
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'p.m.' : 'a.m.';
    return "$day $month, $hour:$minute $period";
  }

  void _showPricingInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryNew.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: AppColors.primaryNew,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Información importante",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Recuerda que al llegar con el cliente se pesa la ropa y el total del cobro es:",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNew.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryNew.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "Precio por kg × Número de kg pesados",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNew,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Ten en cuenta que:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoPoint("La plataforma cobra una comisión del 10%"),
                _buildInfoPoint("Incluye en tu precio todos los gastos: transporte, agua, detergente, electricidad, etc."),
                _buildInfoPoint("El peso final en la báscula determina el cobro total"),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNew,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Entendido",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryNew,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitBid(AvailableOrderDetailResponse orderDetail) async {
    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un precio'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un precio válido'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedPickupDate == null || _selectedPickupTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha y hora de recogida propuesta'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedDeliveryDate == null || _selectedDeliveryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha y hora de entrega propuesta'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final token = Utils.getAuthenticationToken();

      // Crear DateTime completo para recogida (en hora local, luego convertir a UTC)
      final pickupDateTime = DateTime(
        _selectedPickupDate!.year,
        _selectedPickupDate!.month,
        _selectedPickupDate!.day,
        _selectedPickupTime!.hour,
        _selectedPickupTime!.minute,
      );

      // Crear DateTime completo para entrega (en hora local, luego convertir a UTC)
      final deliveryDateTime = DateTime(
        _selectedDeliveryDate!.year,
        _selectedDeliveryDate!.month,
        _selectedDeliveryDate!.day,
        _selectedDeliveryTime!.hour,
        _selectedDeliveryTime!.minute,
      );

      // Convertir a RFC3339 (UTC con 'Z' al final)
      final pickupRFC3339 = pickupDateTime.toUtc().toIso8601String();
      final deliveryRFC3339 = deliveryDateTime.toUtc().toIso8601String();

      print('🔍 [OrderBid] Pickup DateTime Local: $pickupDateTime');
      print('🔍 [OrderBid] Pickup DateTime RFC3339: $pickupRFC3339');
      print('🔍 [OrderBid] Delivery DateTime Local: $deliveryDateTime');
      print('🔍 [OrderBid] Delivery DateTime RFC3339: $deliveryRFC3339');

      final request = CreateBidRequest(
        token: token,
        ordenId: orderDetail.ordenId,
        precioPorKg: price,
        nota: _messageController.text.trim(),
        fechaRecogidaPropuesta: pickupRFC3339,
        fechaEntregaPropuesta: deliveryRFC3339,
      );

      context.read<JobsearchBloc>().add(CreateBidEvent(request));

      // Listen for success
      final subscription = context.read<JobsearchBloc>().stream.listen((state) {
        if (state is JobsearchSuccess && state.orderBidResponse != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Oferta enviada exitosamente!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          }
        } else if (state is JobsearchFailure) {
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

      // Cancel subscription after a timeout
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detalle del Pedido",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<AvailableOrderDetailBloc, AvailableOrderDetailState>(
        builder: (context, state) {
          if (state is AvailableOrderDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNew),
              ),
            );
          } else if (state is AvailableOrderDetailSuccess) {
            return _buildContent(state.orderDetail);
          } else if (state is AvailableOrderDetailFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.error,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              "Cargando detalles...",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primaryNewDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(AvailableOrderDetailResponse orderDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service type title
          Text(
            _getServiceType(orderDetail),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Order details
          _detailRow("Preferencias de lavado:", orderDetail.tipoDetergente),
          _detailRow("Ganchos:", "No"), // TODO: Get from order if available
          _detailRow("Dirección:", orderDetail.direccion),
          _detailRow("Fecha y horario:", _formatDateTime(orderDetail.fechaProgramada)),
          
          // Additional details
          if (orderDetail.metodoSecado.isNotEmpty)
            _detailRow("Método de secado:", orderDetail.metodoSecado),
          
          if (orderDetail.pesoAproximadoKg > 0)
            _detailRow("Peso aproximado:", "${orderDetail.pesoAproximadoKg} kg"),
          
          if (orderDetail.instruccionesEspeciales.isNotEmpty)
            _detailRow("Instrucciones especiales:", orderDetail.instruccionesEspeciales),

          const SizedBox(height: 30),
          // Tu oferta con botón de ayuda
          Row(
            children: [
              const Text(
                "Tu oferta (\$)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showPricingInfoDialog,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryNew.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primaryNew,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNew,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Ingresa el precio por kg",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          // Fecha y hora de recogida propuesta
          Row(
            children: [
              const Text(
                "Fecha de recogida propuesta",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "*",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectPickupDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (_selectedPickupDate == null || _selectedPickupTime == null)
                      ? AppColors.borderGrey
                      : AppColors.primaryNew,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: (_selectedPickupDate == null || _selectedPickupTime == null)
                        ? AppColors.borderGrey
                        : AppColors.primaryNew,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getFormattedDateTime(_selectedPickupDate, _selectedPickupTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: (_selectedPickupDate == null || _selectedPickupTime == null)
                            ? AppColors.borderGrey
                            : AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Fecha y hora de entrega propuesta
          Row(
            children: [
              const Text(
                "Fecha de entrega propuesta",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "*",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDeliveryDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (_selectedDeliveryDate == null || _selectedDeliveryTime == null)
                      ? AppColors.borderGrey
                      : AppColors.primaryNew,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    color: (_selectedDeliveryDate == null || _selectedDeliveryTime == null)
                        ? AppColors.borderGrey
                        : AppColors.primaryNew,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getFormattedDateTime(_selectedDeliveryDate, _selectedDeliveryTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: (_selectedDeliveryDate == null || _selectedDeliveryTime == null)
                            ? AppColors.borderGrey
                            : AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Mensaje al cliente
          const Text(
            "Mensaje al cliente (opcional)",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Escribe un mensaje",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 30),
          // Enviar oferta button
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
              onPressed: _isSubmitting ? null : () => _submitBid(orderDetail),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Enviar oferta",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.black,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            const TextSpan(text: "  "),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

