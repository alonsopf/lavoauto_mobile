import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/chat_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/request/user/orders_modal.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';
import 'package:lavoauto/features/pages/chat/chat_page.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

import '../../../data/models/request/rating/rate_service_modal.dart';
import '../../../data/models/request/user/order_bids_modal.dart';
import '../../../data/models/response/user/orders_response_modal.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/rating_widget.dart';

@RoutePage()
class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  // Map to store bids count for each order
  Map<int, int> orderBidsCount = {};
  // Map to store accepted lavador name for each order
  Map<int, String> orderAcceptedLavador = {};
  // Keep track of orders being fetched for bids (multiple simultaneous requests)
  Map<int, bool> ordersBeingFetched = {};
  // Track orders for which bids have been fetched to avoid duplicate calls
  Set<int> fetchedOrderIds = {};
  // Flag to track if initial orders have been loaded
  bool initialOrdersLoaded = false;
  // Store the loaded orders to prevent showing loader for bids requests
  List<UserOrder> loadedOrders = [];

  @override
  void dispose() {
    // Clean up resources to prevent memory leaks
    orderBidsCount.clear();
    orderAcceptedLavador.clear();
    ordersBeingFetched.clear();
    fetchedOrderIds.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken() ?? '';
    debugPrint("🏁 MyOrders initState - Token of the user: $token");

    // Limpiar el estado del OrderBloc antes de cargar pedidos
    context.read<OrderBloc>().add(const OrderInitialEvent());

    // Pequeño delay para asegurar que el estado se limpie antes de hacer la nueva petición
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dispatch event to fetch orders
      context.read<OrderBloc>().add(
            FetchOrderRequestsEvent(GetOrderRequests(token: token)),
          );
    });
  }

  // Function to fetch bids for a specific order
  void _fetchBidsForOrder(int orderId) {
    if (!fetchedOrderIds.contains(orderId)) {
      String token = Utils.getAuthenticationToken() ?? '';
      ordersBeingFetched[orderId] = true;
      fetchedOrderIds.add(orderId);
      debugPrint("🔄 Fetching bids for order $orderId");
      context.read<OrderBloc>().add(
            FetchOrderBidsEvent(ListOrderBidsRequest(token: token, ordenId: orderId)),
          );
    }
  }

  // Function to fetch bids for all orders sequentially
  void _fetchBidsForAllOrders(List<UserOrder> orders) {
    if (!initialOrdersLoaded) {
      _fetchBidsSequentially(orders, 0);
      initialOrdersLoaded = true;
    }
  }

  // Fetch bids sequentially to avoid confusion with multiple simultaneous requests
  void _fetchBidsSequentially(List<UserOrder> orders, int index) {
    if (index >= orders.length) return;

    final order = orders[index];
    // Add null safety check for order.ordenId
    final ordenId = order.ordenId;
    if (ordenId == null) {
      // Skip this order and continue with next
      _fetchBidsSequentially(orders, index + 1);
      return;
    }

    if (!fetchedOrderIds.contains(ordenId)) {
      String token = Utils.getAuthenticationToken() ?? '';
      if (token.isEmpty) {
        debugPrint("⚠️ No authentication token available");
        return;
      }

      // Use a Set to prevent duplicate requests
      if (ordersBeingFetched.containsKey(ordenId) && ordersBeingFetched[ordenId] == true) {
        debugPrint("⚠️ Order $ordenId is already being fetched, skipping");
        return;
      }

      ordersBeingFetched[ordenId] = true;
      fetchedOrderIds.add(ordenId);
      debugPrint("🔄 Fetching bids for order $ordenId (${index + 1}/${orders.length})");

      context.read<OrderBloc>().add(
            FetchOrderBidsEvent(ListOrderBidsRequest(token: token, ordenId: ordenId)),
          );

      // Continue with next order after a small delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _fetchBidsSequentially(orders, index + 1);
      });
    } else {
      // Skip this order and continue with the next
      _fetchBidsSequentially(orders, index + 1);
    }
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
      drawer: CustomDrawer(
        title: AppStrings.menuMyOrders,
        ontap: () {
          debugPrint("Drawer clicked");
        },
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          debugPrint("🔔 MyOrders BlocConsumer listener - State: ${state.runtimeType}");

          if (state is OrderLoading) {
            debugPrint("🔄 OrderLoading - No loader shown as requested");
            // Loading removed as requested
          } else if (state is OrderFailure) {
            debugPrint("❌ OrderFailure: ${state.errorMessage}");
            Utils.showSnackbar(
              duration: 3000,
              msg: state.errorMessage,
              context: context,
            );
          } else if (state is OrderSuccess) {
            debugPrint("✅ OrderSuccess received");
            debugPrint("📋 userOrdersResponse != null: ${state.userOrdersResponse != null}");
            debugPrint("📋 orderBidsResponse != null: ${state.orderBidsResponse != null}");

            // Store loaded orders (no loader to hide)
            if (state.userOrdersResponse != null) {
              loadedOrders = state.userOrdersResponse!.orders ?? [];
              debugPrint("📦 Loaded ${loadedOrders.length} orders");
            }

            // Handle bids response (these come separately and shouldn't show/hide main loader)
            if (state.orderBidsResponse != null) {
              final pujas = state.orderBidsResponse!.pujas ?? [];

              // Find which order this response belongs to (should be only one being fetched at a time now)
              final orderBeingFetched =
                  ordersBeingFetched.keys.where((id) => ordersBeingFetched[id] == true).firstOrNull;

              if (orderBeingFetched != null) {
                debugPrint("📥 Received ${pujas.length} pujas for order $orderBeingFetched");

                // Count total bids
                orderBidsCount[orderBeingFetched] = pujas.length;

                  // Find accepted lavador if any
                  if (pujas.isNotEmpty) {
                    final acceptedBid = pujas.where((puja) => puja.status == 'accepted').firstOrNull;
                    if (acceptedBid?.lavadorId != null) {
                      orderAcceptedLavador[orderBeingFetched] = 'Lavador #${acceptedBid!.lavadorId}';
                    }
                  } else {
                    debugPrint("⭕ Order $orderBeingFetched has 0 pujas");
                  }

                // Mark this order as processed
                ordersBeingFetched[orderBeingFetched] = false;

                // Log current state for debugging
                debugPrint("📊 Current bids count: $orderBidsCount");

                setState(() {});
              } else {
                debugPrint("⚠️ Received pujas response but no order is being fetched");
                debugPrint("📋 Current orders being fetched: $ordersBeingFetched");
              }
            }
          } else if (state is OrderInitial) {
            debugPrint("🔄 OrderInitial - Resetting state");
            // Reset all local state when BLoC is reset
            loadedOrders.clear();
            orderBidsCount.clear();
            orderAcceptedLavador.clear();
            ordersBeingFetched.clear();
            fetchedOrderIds.clear();
            initialOrdersLoaded = false;
            setState(() {});
          }
        },
        buildWhen: (previous, current) {
          // Only rebuild when we have orders data or when there's a failure
          // Don't rebuild just for bids responses
          if (current is OrderSuccess) {
            // Rebuild if we have new orders data or if this is the first success
            return current.userOrdersResponse != null || (previous is! OrderSuccess);
          }
          return current is OrderFailure || current is OrderInitial;
        },
        builder: (context, state) {
          // Always try to show loaded orders first
          if (loadedOrders.isNotEmpty) {
            _fetchBidsForAllOrders(loadedOrders);
            return _buildOrdersList(context, loadedOrders);
          } else if (state is OrderSuccess && state.userOrdersResponse != null) {
            final orders = state.userOrdersResponse!.orders ?? [];
            _fetchBidsForAllOrders(orders);
            return _buildOrdersList(context, orders);
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
                text: "No hay pedidos disponibles",
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

  Widget _buildOrdersList(BuildContext context, List<UserOrder> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildOrderCard(context, order),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, UserOrder order) {
    final bidsCount = orderBidsCount[order.ordenId] ?? 0;
    final hasBids = bidsCount > 0;
    final isCompleted = order.estatus.toLowerCase() == 'completed' || order.estatus.toLowerCase() == 'completado';
    final isAccepted = order.estatus.toLowerCase() == 'puja_accepted';

    return GestureDetector(
      onTap: isCompleted
          ? () {
              _showRatingDialog(context, order);
            }
          : (isAccepted
              ? () {
                  _openChat(context, order);
                }
              : (hasBids
                  ? () {
                      String token = Utils.getAuthenticationToken() ?? '';
                      context.read<OrderBloc>().add(
                            FetchOrderBidsEvent(ListOrderBidsRequest(token: token, ordenId: order.ordenId)),
                          );
                      context.router.push(routeFiles.MyOrdersBids(orderId: order.ordenId));
                    }
                  : () {
                      // Navigate to order details when no bids yet
                      context.router.push(routeFiles.UserOrderDetail(order: order));
                    })),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pedido #${order.ordenId}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.estatus).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _getStatusColor(order.estatus),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStatusDisplayName(order.estatus),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _getStatusColor(order.estatus),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.event, size: 18, color: AppColors.primary.withOpacity(0.7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Fecha: ${Utils.formatDateTime(order.fechaProgramada)}",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primary.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.scale, size: 18, color: AppColors.primary.withOpacity(0.7)),
                const SizedBox(width: 8),
                Text(
                  "Peso: ${order.pesoAproximadoKg ?? 0} kg",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primary.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isCompleted
                            ? Colors.amber
                            : isAccepted
                                ? AppColors.secondary
                                : hasBids
                                    ? AppColors.secondary
                                    : AppColors.primary)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.star_rounded
                        : isAccepted
                            ? Icons.chat_bubble_rounded
                            : hasBids
                                ? Icons.local_offer_rounded
                                : Icons.info,
                    size: 22,
                    color: isCompleted
                        ? Colors.amber[700]
                        : isAccepted
                            ? AppColors.secondary
                            : hasBids
                                ? AppColors.secondary
                                : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCompleted
                        ? "Calificar prestador"
                        : isAccepted
                            ? "Ver chat con lavador"
                            : hasBids
                                ? "$bidsCount ofertas disponibles"
                                : "Ver detalles del pedido",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? Colors.amber[800]
                          : isAccepted
                              ? AppColors.secondary
                              : hasBids
                                  ? AppColors.secondary
                                  : AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppColors.primary.withOpacity(0.6),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return Colors.deepOrange.shade900; // Darker orange for better contrast
      case 'puja_accepted':
        return Colors.green.shade700;
      case 'en_proceso':
        return Colors.blue.shade700;
      case 'laundry_in_progress':
        return Colors.orange.shade900; // Darker orange
      case 'completed':
      case 'completado':
        return Colors.purple.shade700;
      case 'cancelled':
      case 'cancelado':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return 'PENDIENTE';
      case 'puja_accepted':
        return 'OFERTA ACEPTADA';
      case 'en_proceso':
        return 'EN PROCESO';
      case 'laundry_in_progress':
        return 'LAVADO EN PROGRESO';
      case 'completed':
      case 'completado':
        return 'COMPLETADO';
      case 'cancelled':
      case 'cancelado':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }

  void _showRatingDialog(BuildContext context, UserOrder order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RatingWidget(
            title: "Calificar Prestador",
            subtitle: "¿Cómo fue el servicio de lavandería?",
            onSubmitRating: (rating, comments) {
              Navigator.of(context).pop(); // Close rating dialog
              _submitServiceRating(context, order.ordenId, rating, comments);
            },
            onCancel: () {
              Navigator.of(context).pop(); // Close rating dialog
            },
          ),
        );
      },
    );
  }

  void _submitServiceRating(BuildContext context, int orderId, double rating, String comments) {
    final token = Utils.getAuthenticationToken() ?? '';

    final rateRequest = RateServiceRequest(
      token: token,
      orderId: orderId,
      rating: rating,
      comentarios: comments,
    );

    // TODO: Add rating event to order bloc and handle response
    // For now, just show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Prestador calificado exitosamente con $rating estrellas"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context, UserOrder order) {
    final bidsCount = orderBidsCount[order.ordenId] ?? 0;
    final acceptedLavador = orderAcceptedLavador[order.ordenId];

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
        text: "${AppStrings.labelServices} ${_getStatusDisplayName(order.estatus)}",
        fontSize: 22.0,
        fontColor: AppColors.primary,
        fontWeight: FontWeight.bold,
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
              ListTile(
                dense: true,
                minTileHeight: 10.0,
                horizontalTitleGap: 5.0,
                trailing: PrimaryButton.secondaryIconbutton(
                  color: AppColors.secondary,
                  text: AppStrings.detail.toUpperCase(),
                  onpressed: () {
                    String token = Utils.getAuthenticationToken() ?? '';
                    context.read<OrderBloc>().add(
                          FetchOrderBidsEvent(ListOrderBidsRequest(token: token, ordenId: order.ordenId)),
                        );
                    context.router.push(routeFiles.MyOrdersBids(orderId: order.ordenId));

                    // Navigate to order details
                  },
                ),
                title: CustomText(
                  text: order.ordenId.toString(),
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
                  text: _getStatusDisplayName(order.estatus),
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
                  text: acceptedLavador ?? "Sin lavador asignado",
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
                    text: Utils.formatDateTime(order.fechaProgramada),
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                ),
                leading: CustomText(
                  text: "${AppStrings.requestDate}: ",
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
                    text: Utils.formatDateTime(order.fechaProgramada),
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
                title: CustomText(
                  text: "${order.pesoAproximadoKg ?? 0.0} kg",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ).setText(),
                leading: CustomText(
                  text: "${AppStrings.approxWeight}: ",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ).setText(),
              ),
              // Add "Ver n ofertas" button if there are bids
              if (bidsCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton.primarybutton(
                      isPrimary: true,
                      isEnable: true,
                      width: double.infinity,
                      text: "Ver $bidsCount ofertas".toUpperCase(),
                      onpressed: () {
                        String token = Utils.getAuthenticationToken() ?? '';
                        context.read<OrderBloc>().add(
                              FetchOrderBidsEvent(ListOrderBidsRequest(token: token, ordenId: order.ordenId)),
                            );
                        context.router.push(routeFiles.MyOrdersBids(orderId: order.ordenId));
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _openChat(BuildContext context, UserOrder order) {
    final token = Utils.getAuthenticationToken();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatBloc(
            chatRepository: ChatRepository(token: token),
          ),
          child: ChatPage(
            orderId: order.ordenId,
            otherUserName: "Lavador #${order.lavadorId ?? 'Desconocido'}",
            otherUserPhotoUrl: order.lavadorFotoUrl,
            currentUserType: 'client',
          ),
        ),
      ),
    );
  }
}
