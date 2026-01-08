import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/data/models/request/user/orders_modal.dart';
import 'package:lavoauto/data/models/response/user/orders_response_modal.dart';
import 'package:lavoauto/features/pages/history/rating_page.dart';
import 'package:lavoauto/features/pages/orderDetail/order_detail_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/utils/utils.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken();

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
    return BlocBuilder<OrderBloc, OrderState>(
      buildWhen: (previous, current) {
        return (current is OrderSuccess ||
            current is OrderFailure ||
            current is OrderLoading);
      },
      builder: (context, state) {
        List<Widget> orderCards = [];

        if (state is OrderSuccess && state.userOrdersResponse?.orders != null) {
          final orders = state.userOrdersResponse!.orders!;
          final completedOrders = orders
              .where((order) {
                final status = order.estatus.toLowerCase();
                return status == 'completado' ||
                       status == 'completed' ||
                       status == 'entregado';
              })
              .toList();

          if (completedOrders.isNotEmpty) {
            for (var order in completedOrders) {
              orderCards.add(
                _orderCard(
                  order: order,
                  context: context,
                ),
              );
            }
          }
        } else if (state is OrderLoading) {
          return CustomScaffold(
            title: "Historial de pedidos",
            child: Column(
              children: [
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Atrás",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        } else if (state is OrderFailure) {
          return CustomScaffold(
            title: "Historial de pedidos",
            child: Column(
              children: [
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Atrás",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Text("Error: ${state.errorMessage}"),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScaffold(
          title: "Historial de pedidos",
          child: Column(
            children: [
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Atrás",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Show orders or empty state
              if (orderCards.isNotEmpty)
                ...orderCards
              else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No tienes pedidos completados",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Tus pedidos completados aparecerán aquí",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderCard({
    required UserOrder order,
    required BuildContext context,
  }) {
    // Format date
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pedido #LAV-${order.ordenId}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "N/A",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Text(formattedDate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceDescription,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Text(order.estatus, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: "Ver detalle",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(order: order),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  isPrimary: true,
                  title: "Repetir orden",
                  onTap: () {
                    // Navigate to new order page
                    // TODO: Pre-fill fields with existing order data
                    context.router.push(routeFiles.NewOrder());
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
