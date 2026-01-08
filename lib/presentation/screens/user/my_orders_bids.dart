import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/image_.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;

import '../../../core/constants/assets.dart';
import '../../../data/models/request/user/accept_bid_order_modal.dart';
import '../../../data/models/request/user/order_bids_modal.dart';
import '../../../data/models/response/user/order_bids_response_modal.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../common_widgets/app_bar.dart';

@RoutePage()
class MyOrdersBids extends StatefulWidget {
  final dynamic orderId;
  const MyOrdersBids({super.key, this.orderId});

  @override
  State<MyOrdersBids> createState() => _MyOrdersBidsState();
}

class _MyOrdersBidsState extends State<MyOrdersBids> {

  // Translate bid status to user-friendly Spanish text
  String _translateBidStatus(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'aceptada':
        return 'Aceptada';
      case 'pending':
      case 'pendiente':
        return 'Pendiente';
      case 'rejected':
      case 'rechazada':
        return 'Rechazada';
      case 'cancelled':
      case 'cancelada':
        return 'Cancelada';
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
    
    // Trigger the event to fetch order bids when the screen loads
    context.read<OrderBloc>().add(
      FetchOrderBidsEvent(ListOrderBidsRequest(
        token: token,
        ordenId: widget.orderId,
      )),
    );
  }
  
  void _showAcceptBidSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64.0,
          ),
          title: CustomText(
            text: "¡Listo!",
            fontSize: 24.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
          content: Flexible(
            child: SingleChildScrollView(
              child: CustomText(
                text: "Tu pedido se encuentra en proceso de ser recogido.\nEl lavador se pondrá en contacto contigo pronto.",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w500,
              ).setText(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate back to orders page
                context.router.replaceAll([const routeFiles.MyOrders()]);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: CustomText(
                text: "Entendido",
                fontSize: 16.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.menuMyOrders,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            debugPrint("🔄 OrderLoading - No loader shown as requested");
            // Loading removed as requested
          } else if (state is OrderFailure) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: state.errorMessage,
              context: context,
            );
          } else if (state is OrderSuccess) {
            Loader.hideLoader(loader);
            if (state.orderBidAcceptResponse != null) {
              // Show success confirmation dialog
              _showAcceptBidSuccessDialog(context);
            }
          }
        },
        buildWhen: (previous, current) =>
            current is! OrderLoading || current is! OrderFailure,
        builder: (context, state) {
          if (state is OrderSuccess) {
            return _buildOrdersBidsList(
                context, state.orderBidsResponse?.pujas ?? []);
          } else if (state is OrderFailure) {
            return Center(
              child: CustomText(
                text: state.errorMessage,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            );
          } else {
            return Center(
              child: CustomText(
                text: "No hay ofertas disponibles",
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

  Widget _buildOrdersBidsList(BuildContext context, List<OrderBid> orderBid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ListView.builder(
        itemCount: orderBid.length,
        itemBuilder: (context, index) {
          final order = orderBid[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildOrderDetails(context, order),
          );
        },
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderBid order) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGrey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.borderGrey,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            horizontalTitleGap: 5.0,
            trailing: PrimaryButton.secondaryIconbutton(
              color: AppColors.secondary,
              text: AppStrings.accept.toUpperCase(),
              onpressed: () {
                String token = Utils.getAuthenticationToken() ?? '';
                context.read<OrderBloc>().add(
                      AcceptBidEvent(AcceptBidOrderRequest(
                          pujaId: order.pujaId,
                          token: token,
                          ordenId: widget.orderId)),
                    );
              },
            ),
            title: CustomText(
              text: order.pujaId.toString(),
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            leading: CustomText(
              text: "${AppStrings.exampleOrderId}: ",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w900,
            ).setText(),
          ),
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            minLeadingWidth: 20.0,
            horizontalTitleGap: 0,
            title: CustomText(
              text: _translateBidStatus(order.status).toUpperCase(),
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            leading: CustomText(
              text: "${AppStrings.inProcessStatustitle}: ",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w900,
            ).setText(),
          ),
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            minLeadingWidth: 20.0,
            horizontalTitleGap: 0,
            title: CustomText(
              text: "Lavador #${order.lavadorId}",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            leading: CustomText(
              text: "${AppStrings.washerNametitle}: ",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w900,
            ).setText(),
          ),
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            minLeadingWidth: 20.0,
            horizontalTitleGap: 0,
            title: FittedBox(
              child: CustomText(
                text: Utils.formatDateTime(order.fechaRecogida ?? ''),
                fontSize: 22.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
            leading: CustomText(
              text: "${AppStrings.scheduledPickup}: ",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w900,
            ).setText(),
          ),
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            minLeadingWidth: 20.0,
            horizontalTitleGap: 0,
            title: FittedBox(
              child: CustomText(
                text: Utils.formatDateTime(order.fechaEstimada ?? ''),
                fontSize: 22.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
            leading: CustomText(
              text: "${AppStrings.estimationDate}: ",
              fontSize: 22.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w900,
            ).setText(),
          ),
          ListTile(
            dense: true,
            minTileHeight: 10.0,
            minLeadingWidth: 20.0,
            horizontalTitleGap: 0,
            title: CustomText(
              text: "\$${order.precioPorKg} por kg",
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
          if (order.nota.isNotEmpty)
            ListTile(
              dense: true,
              minTileHeight: 10.0,
              minLeadingWidth: 20.0,
              horizontalTitleGap: 0,
              title: CustomText(
                text: order.nota,
                fontSize: 22.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w600,
              ).setText(),
              leading: CustomText(
                text: "Nota: ",
                fontSize: 22.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w900,
              ).setText(),
            ),
        ],
      ),
    );
  }
}
