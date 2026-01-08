import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/request/user/orders_modal.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/app_bar.dart';
import 'package:lavoauto/presentation/common_widgets/custom_drawer.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';
import 'package:intl/intl.dart';

import '../../../data/models/response/user/orders_response_modal.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';

@RoutePage()
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool initialOrdersLoaded = false;

  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken() ?? '';
    debugPrint("🏁 OrderHistoryScreen initState - Token: $token");

    // Clean the state of the OrderBloc before loading orders
    context.read<OrderBloc>().add(const OrderInitialEvent());

    // Small delay to ensure state is cleaned before making the new request
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dispatch event to fetch orders
      context.read<OrderBloc>().add(
            FetchOrderRequestsEvent(GetOrderRequests(token: token)),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: "Historial de Pedidos",
      ),
      drawer: CustomDrawer(
        title: "Historial de Pedidos",
        ontap: () {
          Navigator.pop(context);
        },
        isUser: true,
      ),
      body: SafeArea(
        child: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderLoading) {
              Loader.insertLoader(context, loader);
            } else if (state is OrderSuccess) {
              Loader.hideLoader(loader);
            } else if (state is OrderFailure) {
              Loader.hideLoader(loader);
              Utils.showAlert(
                title: 'Error',
                message: state.errorMessage,
                context: context,
              );
            }
          },
          buildWhen: (previous, current) {
            return (current is OrderSuccess ||
                current is OrderFailure ||
                current is OrderLoading);
          },
          builder: (context, state) {
            if (state is OrderSuccess && state.userOrdersResponse?.orders != null) {
              final orders = state.userOrdersResponse!.orders!;
              final completedOrders = orders
                  .where((order) => order.estatus.toLowerCase() == 'completado' ||
                                   order.estatus.toLowerCase() == 'entregado')
                  .toList();

              if (completedOrders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      const YMargin(20),
                      CustomText(
                        text: 'No hay historial de pedidos',
                        fontColor: AppColors.primary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ).setText(),
                      const YMargin(8),
                      CustomText(
                        text: 'Los pedidos completados aparecerán aquí',
                        fontColor: AppColors.primary.withOpacity(0.6),
                        fontSize: 14.0,
                      ).setText(),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: completedOrders.length,
                itemBuilder: (context, index) {
                  final order = completedOrders[index];
                  return _buildOrderCard(order, context);
                },
              );
            } else if (state is OrderFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const YMargin(20),
                    CustomText(
                      text: 'Error al cargar historial',
                      fontColor: AppColors.primary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ).setText(),
                    const YMargin(8),
                    CustomText(
                      text: state.errorMessage,
                      fontColor: AppColors.primary.withOpacity(0.6),
                      fontSize: 14.0,
                      textAlign: TextAlign.center,
                    ).setText(),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(UserOrder order, BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'es_ES');
    final formattedDate = order.fechaProgramada.isNotEmpty
        ? dateFormat.format(DateTime.parse(order.fechaProgramada))
        : 'Fecha desconocida';

    // Build service description from order details
    String serviceDescription = 'Servicio de lavado';
    if (order.tipoPlanchado != null) {
      serviceDescription = 'Lavado, Secado y Planchado';
    } else if (order.metodoSecado != null) {
      serviceDescription = 'Lavado y Secado';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          CustomText(
            text: 'Pedido #${order.ordenId}',
            fontColor: AppColors.primary,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ).setText(),
          const YMargin(8),
          // Date
          CustomText(
            text: formattedDate,
            fontColor: AppColors.primary.withOpacity(0.6),
            fontSize: 14.0,
          ).setText(),
          const YMargin(12),
          // Service and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: serviceDescription,
                  fontColor: AppColors.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                ).setText(),
              ),
              const XMargin(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: 'Entregado',
                  fontColor: AppColors.primary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ).setText(),
              ),
            ],
          ),
          const YMargin(14),
          // Weight info
          CustomText(
            text: 'Peso aproximado: ${order.pesoAproximadoKg?.toStringAsFixed(2) ?? 'N/A'} kg',
            fontColor: AppColors.primary.withOpacity(0.5),
            fontSize: 13.0,
          ).setText(),
          const YMargin(14),
          // Buttons
          Row(
            children: [
              Expanded(
                child: PrimaryButton.primarybutton(
                  text: 'Ver detalle',
                  onpressed: () {
                    // Navigate to order detail
                    // context.router.push(UserOrderDetail(orderId: order.ordenId));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
