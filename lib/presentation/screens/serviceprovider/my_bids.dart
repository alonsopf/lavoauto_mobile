import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/presentation/common_widgets/text_field.dart';
import 'package:lavoauto/theme/apptheme.dart';
import 'package:lavoauto/data/models/response/worker/orders_response_modal.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/data/models/request/worker/create_bid_modal.dart';
import 'package:lavoauto/data/models/request/worker/availableOrdersRequest_modal.dart';
import 'package:lavoauto/utils/loadersUtils/LoaderClass.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/assets.dart';
import '../../../theme/app_color.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/image_.dart';
import '../../common_widgets/primary_button.dart';

@RoutePage()
class MyBids extends StatefulWidget {
  final WorkerOrder? order;
  const MyBids({super.key, this.order});

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _pickupDateProposedController = TextEditingController();
  final TextEditingController _deliveryDateProposedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar con valores por defecto si hay una orden
    if (widget.order != null) {
      _pickupDateController.text = Utils.formatDateTime(widget.order!.fechaProgramada);
      // Agregar un día para la fecha de entrega estimada
      final pickupDate = DateTime.parse(widget.order!.fechaProgramada);
      final deliveryDate = pickupDate.add(const Duration(days: 1));
      _deliveryDateController.text = Utils.formatDateTime(deliveryDate.toIso8601String());
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    _pickupDateController.dispose();
    _deliveryDateController.dispose();
    _pickupDateProposedController.dispose();
    _deliveryDateProposedController.dispose();
    super.dispose();
  }

  void _submitBid() {
    if (widget.order == null) {
      Utils.showSnackbar(
        msg: "No hay información de la orden",
        context: context,
        duration: 3000,
      );
      return;
    }

    if (_priceController.text.isEmpty) {
      Utils.showSnackbar(
        msg: "Por favor ingresa el precio por kg",
        context: context,
        duration: 3000,
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      Utils.showSnackbar(
        msg: "Por favor ingresa un precio válido",
        context: context,
        duration: 3000,
      );
      return;
    }

    final token = Utils.getAuthenticationToken();
    final pickupDate = _pickupDateController.text.isNotEmpty
        ? widget.order!.fechaProgramada
        : widget.order!.fechaProgramada;

    final deliveryDate = _deliveryDateController.text.isNotEmpty
        ? DateTime.parse(widget.order!.fechaProgramada).add(const Duration(days: 1)).toIso8601String()
        : DateTime.parse(widget.order!.fechaProgramada).add(const Duration(days: 1)).toIso8601String();

    final createBidRequest = CreateBidRequest(
      token: token,
      ordenId: widget.order!.ordenId,
      precioPorKg: price,
      nota: _notesController.text.isEmpty ? "Sin observaciones" : _notesController.text,
      fechaRecogida: pickupDate,
      fechaEstimada: deliveryDate,
      fechaRecogidaPropuesta: _pickupDateProposedController.text.isNotEmpty
        ? _pickupDateProposedController.text
        : null,
      fechaEntregaPropuesta: _deliveryDateProposedController.text.isNotEmpty
        ? _deliveryDateProposedController.text
        : null,
    );

    context.read<JobsearchBloc>().add(CreateBidEvent(createBidRequest));
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: widget.order != null ? "Ofertar - Orden #${widget.order!.ordenId}" : AppStrings.myBids,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ImagesPng.assetPNG(Assets.placeholderUserPhoto,
                height: 40.0, width: 40.0),
          ),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.myServices,
        ontap: () {
          debugPrint("click ");
        },
      ),
      body: BlocConsumer<JobsearchBloc, JobsearchState>(
        listener: (context, state) {
          if (state is JobsearchLoading) {
            Loader.insertLoader(context, loader);
          } else if (state is JobsearchFailure) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: state.errorMessage,
              context: context,
            );
          } else if (state is JobsearchSuccess && state.orderBidResponse != null) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: "¡Oferta creada exitosamente! ID: ${state.orderBidResponse!.pujaId}",
              context: context,
            );
            // Primero resetear el estado para limpiar datos corruptos
            context.read<JobsearchBloc>().add(const ResetJobsearchStateEvent());
            // Luego refrescar la lista de órdenes disponibles después de crear la oferta
            final token = Utils.getAuthenticationToken();
            context.read<JobsearchBloc>().add(
              FetchAvailableOrdersEvent(ListAvailableOrdersRequest(token: token)),
            );
            // Navegar de vuelta a la búsqueda de trabajos
            context.router.maybePop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: ListView(
              children: [
                const YMargin(16.0),
                if (widget.order != null) 
                  _buildOrderInfoCard(context, widget.order!),
                if (widget.order != null) 
                  const YMargin(16.0),
                _buildBidFormWidget(context),
                const YMargin(16.0),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderInfoCard(BuildContext context, WorkerOrder order) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Información de la Orden",
            fontSize: 24.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(10.0),
          _buildInfoRow("Cliente ID:", order.clienteId.toString()),
          _buildInfoRow("Fecha Programada:", Utils.formatDateTime(order.fechaProgramada)),
          _buildInfoRow("Peso Aproximado:", "${order.pesoAproximadoKg ?? 0.0} kg"),
          _buildInfoRow("Detergente:", order.tipoDetergente ?? "No especificado"),
          _buildInfoRow("Método de Secado:", order.metodoSecado ?? "No especificado"),
          _buildInfoRow("Dirección:", order.direccion ?? "No especificada"),
          if (order.instruccionesEspeciales?.isNotEmpty == true)
            _buildInfoRow("Instrucciones:", order.instruccionesEspeciales!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomText(
              text: label,
              fontSize: 18.0,
              fontColor: AppColors.grey,
              fontWeight: FontWeight.bold,
            ).setText(),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: value,
              fontSize: 18.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w400,
            ).setText(),
          ),
        ],
      ),
    );
  }

  Widget _buildBidFormWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Crear Oferta",
            fontSize: 24.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(16.0),
          
          // Campo de precio
          CustomText(
            text: "Precio por kg (\$)",
            fontSize: 18.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ).setText(),
          const YMargin(8.0),
                     CustomTextFieldWidget(
             controller: _priceController,
             maxLength: 10,
             fillcolour: AppColors.white,
             hintColor: AppColors.grey,
             isVisible: true,
             hintText: "Ej: 70.35",
             keyboardType: TextInputType.numberWithOptions(decimal: true),
             onChanged: (v) {},
           ),
          const YMargin(16.0),
          
          // Campo de observaciones
          CustomText(
            text: "Observaciones",
            fontSize: 18.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ).setText(),
          const YMargin(8.0),
          CustomTextFieldWidget(
            controller: _notesController,
            maxLength: 500,
            fillcolour: AppColors.white,
            hintColor: AppColors.grey,
            maxLines: 4,
            isVisible: true,
            hintText: "Escribe cualquier observación o comentario...",
            onChanged: (v) {},
          ),
          const YMargin(16.0),
          
          // Información importante
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border(left: BorderSide(color: Colors.deepOrange.shade900, width: 4)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'IMPORTANTE: ',
                    style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16.0,
                        color: Colors.deepOrange.shade900,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: "La fecha de recogida será la programada en la orden. La fecha de entrega se calculará automáticamente (1 día después).",
                    style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16.0,
                        height: 1.4,
                        color: Colors.deepOrange.shade800,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          const YMargin(20.0),

          // Worker's Proposed Times (Optional)
          CustomText(
            text: "Horas propuestas (opcional)",
            fontSize: 18.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ).setText(),
          const YMargin(8.0),

          CustomText(
            text: "Hora de recogida propuesta",
            fontSize: 16.0,
            fontColor: AppColors.grey,
            fontWeight: FontWeight.w400,
          ).setText(),
          const YMargin(4.0),
          TextFormField(
            controller: _pickupDateProposedController,
            decoration: InputDecoration(
              hintText: 'Selecciona hora de recogida propuesta',
              fillColor: AppColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            readOnly: true,
            onTap: () async {
              Utils.selectDateAndTime(context, (dateTime) {
                setState(() {
                  _pickupDateProposedController.text = dateTime.toUtc().toIso8601String();
                });
              });
            },
          ),
          const YMargin(12.0),

          CustomText(
            text: "Hora de entrega propuesta",
            fontSize: 16.0,
            fontColor: AppColors.grey,
            fontWeight: FontWeight.w400,
          ).setText(),
          const YMargin(4.0),
          TextFormField(
            controller: _deliveryDateProposedController,
            decoration: InputDecoration(
              hintText: 'Selecciona hora de entrega propuesta',
              fillColor: AppColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            readOnly: true,
            onTap: () async {
              Utils.selectDateAndTime(context, (dateTime) {
                setState(() {
                  _deliveryDateProposedController.text = dateTime.toUtc().toIso8601String();
                });
              });
            },
          ),
          const YMargin(20.0),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                             PrimaryButton.secondarybutton(
                 text: AppStrings.back,
                 onpressed: () {
                   context.router.maybePop();
                 },
               ),
              PrimaryButton.secondarybutton(
                text: AppStrings.bid,
                onpressed: _submitBid,
              ),
            ],
          ),
          const YMargin(4.0),
        ],
      ),
    );
  }
}
