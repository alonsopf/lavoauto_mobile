import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';

import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/assets.dart';
import '../../../data/models/request/worker/my_work_request_modal.dart';
import '../../../data/models/request/rating/rate_client_modal.dart';
import '../../../data/models/response/worker/my_work_response_modal.dart';
import '../../router/router.gr.dart';
import '../../../theme/app_color.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/image_.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/rating_widget.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';

@RoutePage()
class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken() ?? '';
    debugPrint("Token of the user: $token");
    context.read<ServicesBloc>().add(
          FetchMyWorkEvent(MyWorkRequest(token: token)),
        );
  }

  void _refreshMyWork() {
    String token = Utils.getAuthenticationToken() ?? '';
    debugPrint("Refreshing my work data...");
    context.read<ServicesBloc>().add(
          FetchMyWorkEvent(MyWorkRequest(token: token)),
        );
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.myServices,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.myServices,
        ontap: () {
          debugPrint("Drawer clicked");
        },
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesLoading) {
            Loader.insertLoader(context, loader);
          } else if (state is ServicesFailure) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: state.errorMessage,
              context: context,
            );
          } else if (state is MyWorkSuccess) {
            Loader.hideLoader(loader);
          }
        },
        buildWhen: (previous, current) => current is! ServicesLoading,
        builder: (context, state) {
          if (state is MyWorkSuccess) {
            return _buildMyWorkList(context, state.myWorkResponse);
          } else if (state is ServicesFailure) {
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
                text: "No data available",
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

  Widget _buildMyWorkList(BuildContext context, MyWorkResponse myWorkResponse) {
    final workOrders = myWorkResponse.workOrders ?? [];
    
    if (workOrders.isEmpty) {
      return Center(
        child: CustomText(
          text: "No tienes órdenes de trabajo",
          fontSize: 18.0,
          fontColor: AppColors.primary,
          fontWeight: FontWeight.bold,
        ).setText(),
      );
    }

    // Group orders by status
    Map<String, List<MyWorkOrder>> groupedOrders = {};
    for (var order in workOrders) {
      if (groupedOrders[order.estatus] == null) {
        groupedOrders[order.estatus] = [];
      }
      groupedOrders[order.estatus]!.add(order);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      children: [
        // Header with total info
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Total de órdenes: ${myWorkResponse.totalOrders}",
                fontSize: 16.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
              CustomText(
                text: "ID: ${myWorkResponse.lavadorId}",
                fontSize: 14.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w500,
              ).setText(),
            ],
          ),
        ),
        // Orders grouped by status
        ...groupedOrders.entries.map((entry) {
          final status = entry.key;
          final orders = entry.value;
          return _buildStatusSection(context, status, orders);
        }).toList(),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context, String status, List<MyWorkOrder> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomText(
            text: "${_getStatusDisplayName(status)} (${orders.length})",
            fontSize: 18.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
        ),
        // Orders for this status
        ...orders.map((order) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildMyWorkOrderCard(context, order),
        )).toList(),
        const SizedBox(height: 16.0),
      ],
    );
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
        return 'PUJA ACEPTADA';
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

  Widget _buildMyWorkOrderCard(BuildContext context, MyWorkOrder order) {
    return ExpansionTile(
      iconColor: AppColors.white,
      visualDensity: VisualDensity.comfortable,
      collapsedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      backgroundColor: AppColors.tertiary,
      collapsedBackgroundColor: AppColors.tertiary,
      title: CustomText(
        text: "Orden #${order.ordenId}",
        fontSize: 20.0,
        fontColor: AppColors.primary,
        fontWeight: FontWeight.bold,
      ).setText(),
      subtitle: CustomText(
        text: "Cliente ID: ${order.clienteId}",
        fontSize: 14.0,
        fontColor: AppColors.primary,
        fontWeight: FontWeight.w400,
      ).setText(),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
          ),
          width: Utils.getScreenSize(context).width,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildDetailRow("Peso", "${order.pesoAproximadoKg ?? 0.0} kg"),
                        _buildDetailRow("Detergente", order.tipoDetergente ?? "No especificado"),
                        _buildDetailRow("Secado", order.metodoSecado ?? "No especificado"),
                        _buildDetailRow("Fecha programada", Utils.formatDateTime(order.fechaProgramada)),
                        _buildDetailRow("Fecha creación", Utils.formatDateTime(order.fechaCreacion)),
                        if (order.direccion?.isNotEmpty == true)
                          _buildDetailRow("Dirección", order.direccion!),
                        if (order.instruccionesEspeciales?.isNotEmpty == true)
                          _buildDetailRow("Instrucciones", order.instruccionesEspeciales!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Action buttons based on order status
              if (order.estatus.toLowerCase() == 'completado') ...[
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton.secondaryIconbutton(
                        color: AppColors.secondary,
                        text: AppStrings.detail.toUpperCase(),
                        onpressed: () async {
                          final result = await context.router.push(OrderDetail(order: order));
                          if (result == true) {
                            // Refresh the page when coming back from successful collection
                            _refreshMyWork();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: PrimaryButton.primarybutton(
                        isPrimary: true,
                        isEnable: true,
                        width: double.infinity,
                        text: "CALIFICAR CLIENTE",
                        onpressed: () {
                          _showRatingDialog(context, order);
                        },
                      ),
                    ),
                  ],
                ),
              ] else if (order.estatus.toLowerCase() == 'aceptada') ...[
                // Chat button for accepted orders
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton.secondaryIconbutton(
                        color: AppColors.secondary,
                        text: "CHAT",
                        onpressed: () {
                          _openChat(context, order);
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: PrimaryButton.secondaryIconbutton(
                        color: AppColors.secondary,
                        text: AppStrings.detail.toUpperCase(),
                        onpressed: () async {
                          final result = await context.router.push(OrderDetail(order: order));
                          if (result == true) {
                            // Refresh the page when coming back from successful collection
                            _refreshMyWork();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                PrimaryButton.secondaryIconbutton(
                  color: AppColors.secondary,
                  text: AppStrings.detail.toUpperCase(),
                  onpressed: () async {
                    final result = await context.router.push(OrderDetail(order: order));
                    if (result == true) {
                      // Refresh the page when coming back from successful collection
                      _refreshMyWork();
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ],
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
            ).setText(),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: value,
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w500,
            ).setText(),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, MyWorkOrder order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RatingWidget(
            title: "Calificar Cliente",
            subtitle: "¿Cómo fue tu experiencia con este cliente?",
            onSubmitRating: (rating, comments) {
              Navigator.of(context).pop(); // Close rating dialog
              _submitClientRating(context, order.ordenId, rating, comments);
            },
            onCancel: () {
              Navigator.of(context).pop(); // Close rating dialog
            },
          ),
        );
      },
    );
  }

  void _submitClientRating(BuildContext context, int orderId, double rating, String comments) {
    final token = Utils.getAuthenticationToken() ?? '';

    final rateRequest = RateClientRequest(
      token: token,
      orderId: orderId,
      rating: rating,
      comentarios: comments,
    );

    // TODO: Add rating event to services bloc and handle response
    // For now, just show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Cliente calificado exitosamente con $rating estrellas"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openChat(BuildContext context, MyWorkOrder order) {
    // Get auth info
    final token = Utils.getAuthenticationToken() ?? '';

    // Navigate to ChatScreen
    // You'll need to import ChatScreen
    // context.router.push(ChatRoute(orderId: order.ordenId));

    // For now, show a snackbar (replace with actual navigation)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo chat para orden #${order.ordenId}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual chat navigation
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => BlocProvider(
    //       create: (context) => ChatBloc(
    //         chatRepository: ChatRepository(token: token),
    //       ),
    //       child: ChatScreen(
    //         orderId: order.ordenId,
    //         otherUserName: 'Cliente',
    //         otherUserPhotoUrl: null,
    //         currentUserType: 'lavador',
    //       ),
    //     ),
    //   ),
    // );
  }
}
