import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/lavador/available_order_detail_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/request/lavador/available_order_detail_modal.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;

import '../../../core/constants/assets.dart';
import '../../../data/models/response/lavador/available_order_detail_response_modal.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../common_widgets/app_bar.dart';

@RoutePage()
class LavadorOrderDetail extends StatefulWidget {
  final dynamic orderId;
  const LavadorOrderDetail({super.key, this.orderId});

  @override
  State<LavadorOrderDetail> createState() => _LavadorOrderDetailState();
}

class _LavadorOrderDetailState extends State<LavadorOrderDetail> {

  // Translate order status to user-friendly Spanish text
  String _translateOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return 'Pendiente';
      case 'puja_accepted':
      case 'oferta_aceptada':
        return 'Oferta Aceptada';
      case 'en_proceso':
      case 'in_progress':
        return 'En Proceso';
      case 'completed':
      case 'completado':
        return 'Completado';
      case 'cancelled':
      case 'cancelado':
        return 'Cancelado';
      case 'laundry_in_progress':
        return 'Lavado en Progreso';
      default:
        return status.replaceAll("_", " ");
    }
  }

  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken();
    
    // Validate authentication before making API call
    if (token.isEmpty || !Utils.getAuthentication()) {
       // Redirect to login screen if not authenticated
       WidgetsBinding.instance.addPostFrameCallback((_) {
         context.router.replaceAll([routeFiles.LoginRoute()]);
       });
      return;
    }
    
    // Trigger the event to fetch available order detail when the screen loads
    context.read<AvailableOrderDetailBloc>().add(
      FetchAvailableOrderDetailEvent(AvailableOrderDetailRequest(
        token: token,
        orderId: widget.orderId,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: "Detalle de Orden",
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      body: BlocConsumer<AvailableOrderDetailBloc, AvailableOrderDetailState>(
        listener: (context, state) {
          if (state is AvailableOrderDetailLoading) {
            debugPrint("🔄 AvailableOrderDetailLoading");
            Loader.insertLoader(context, loader);
          } else if (state is AvailableOrderDetailFailure) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: state.error,
              context: context,
            );
          } else if (state is AvailableOrderDetailSuccess) {
            Loader.hideLoader(loader);
          }
        },
        buildWhen: (previous, current) =>
            current is! AvailableOrderDetailLoading || current is! AvailableOrderDetailFailure,
        builder: (context, state) {
          if (state is AvailableOrderDetailSuccess) {
            return _buildOrderDetail(context, state.orderDetail);
          } else if (state is AvailableOrderDetailFailure) {
            return Center(
              child: CustomText(
                text: state.error,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            );
          } else {
            return Center(
              child: CustomText(
                text: "Cargando detalles de orden...",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderDetail(BuildContext context, AvailableOrderDetailResponse orderDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                horizontalTitleGap: 5.0,
                title: CustomText(
                  text: orderDetail.ordenId.toString(),
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "ID Orden: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Status
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: _translateOrderStatus(orderDetail.estatus).toUpperCase(),
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Estado: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Scheduled Date
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: FittedBox(
                  child: CustomText(
                    text: Utils.formatDateTime(orderDetail.fechaProgramada),
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                ),
                leading: CustomText(
                  text: "Fecha: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Weight
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: "${orderDetail.pesoAproximadoKg} kg",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Peso: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Detergent Type
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: orderDetail.tipoDetergente,
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Detergente: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Drying Method
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: orderDetail.metodoSecado,
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Secado: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Address
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: orderDetail.direccion,
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Dirección: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Client ID
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                minLeadingWidth: 20.0,
                horizontalTitleGap: 0,
                title: CustomText(
                  text: "Cliente #${orderDetail.clienteId}",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "Cliente: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              
              // Price per kg (if available)
              if (orderDetail.precioPorKg != null)
                ListTile(
                  dense: true,
                  minTileHeight: 10.0,
                  minLeadingWidth: 20.0,
                  horizontalTitleGap: 0,
                  title: CustomText(
                    text: "\$${orderDetail.precioPorKg} por kg",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                  leading: CustomText(
                    text: "Precio: ",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ).setText(),
                ),
              
              // Special Instructions
              if (orderDetail.instruccionesEspeciales.isNotEmpty)
                ListTile(
                  dense: true,
                  minTileHeight: 10.0,
                  minLeadingWidth: 20.0,
                  horizontalTitleGap: 0,
                  title: CustomText(
                    text: orderDetail.instruccionesEspeciales,
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                  leading: CustomText(
                    text: "Instrucciones: ",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ).setText(),
                ),
              
              // Tip (if available)
              if (orderDetail.propina != null)
                ListTile(
                  dense: true,
                  minTileHeight: 10.0,
                  minLeadingWidth: 20.0,
                  horizontalTitleGap: 0,
                  title: CustomText(
                    text: "\$${orderDetail.propina}",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                  leading: CustomText(
                    text: "Propina: ",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ).setText(),
                ),
              
              // Final Weight (if available)
              if (orderDetail.pesoFinalKg != null)
                ListTile(
                  dense: true,
                  minTileHeight: 10.0,
                  minLeadingWidth: 20.0,
                  horizontalTitleGap: 0,
                  title: CustomText(
                    text: "${orderDetail.pesoFinalKg} kg",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                  leading: CustomText(
                    text: "Peso Final: ",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ).setText(),
                ),
              
              // Completed Date (if available)
              if (orderDetail.fechaCompletada != null)
                ListTile(
                  dense: true,
                  minTileHeight: 10.0,
                  minLeadingWidth: 20.0,
                  horizontalTitleGap: 0,
                  title: FittedBox(
                    child: CustomText(
                      text: Utils.formatDateTime(orderDetail.fechaCompletada!),
                      fontSize: 22.0,
                      fontColor: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ).setText(),
                  ),
                  leading: CustomText(
                    text: "Completada: ",
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ).setText(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}