import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/request/user/orders_modal.dart';
import 'package:lavoauto/features/pages/history/order_history_page.dart';
import 'package:lavoauto/features/pages/orderDetail/order_detail_page.dart';
import 'package:lavoauto/features/pages/service/service_select_page.dart';
import 'package:lavoauto/features/pages/support/support_page.dart';
import 'package:lavoauto/presentation/common_widgets/custom_drawer.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserInfoBloc _userInfoBloc;
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _userInfoBloc = context.read<UserInfoBloc>();
    _orderBloc = context.read<OrderBloc>();
    // Fetch user info and orders when page loads
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _userInfoBloc.add(FetchUserProfileInfoEvent(token: token));
      // Fetch orders on home page initialization
      _orderBloc.add(FetchOrderRequestsEvent(GetOrderRequests(token: token)));
    }
  }

  // Translate order status to user-friendly Spanish text
  String _translateOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'puja_accepted':
      case 'oferta_aceptada':
        return 'Pedido confirmado';
      case 'pendiente':
      case 'pending':
        return 'Pendiente';
      case 'en_progreso':
      case 'in_progress':
        return 'En progreso';
      case 'completado':
      case 'completed':
        return 'Completado';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      case 'en_camino':
        return 'En camino';
      case 'recogido':
        return 'Recogido';
      case 'lavando':
        return 'Lavando';
      case 'listo_para_entregar':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        backgroundColor: AppColors.primaryNewDark,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 24),
          onPressed: () async {
            // Show logout confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Cerrar sesión"),
                content: const Text("¿Estás seguro que deseas cerrar sesión?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Cerrar sesión"),
                  ),
                ],
              ),
            );
            
            if (shouldLogout == true && context.mounted) {
              await Utils.sharedpref?.clear();
              if (context.mounted) {
                context.router.replaceAll([routeFiles.LoginRoute()]);
              }
            }
          },
        ),
        title: const Text("LAVOAUTO", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: Center(child: SvgPicture.asset(Assets.hanger, height: 48, color: AppColors.white)),
          ),
        ],
      ),
      drawer: CustomDrawer(
        title: "Menu",
        ontap: () => Navigator.pop(context),
        isUser: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              BlocBuilder<UserInfoBloc, UserInfoState>(
                buildWhen: (previous, current) => current is UserInfoSuccess,
                builder: (context, state) {
                  String firstName = "Usuario";
                  if (state is UserInfoSuccess) {
                    firstName = state.userWorkerInfo?.data?.nombre ?? "Usuario";
                  }
                  return Text(
                    "Hola, $firstName 👋",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNewDark,
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              const Text(
                "Qué quieres hacer hoy?",
                style: TextStyle(fontSize: 26, color: AppColors.primaryNewDark),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ServiceSelectPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNew,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(Assets.basket, height: 40),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nueva orden",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Lavado a domicilio fácil, rápido y a buen precio",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Pedidos en curso",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primaryNewDark),
              ),
              const SizedBox(height: 14),
              BlocBuilder<OrderBloc, OrderState>(
                bloc: _orderBloc,
                buildWhen: (previous, current) => current is OrderSuccess,
                builder: (context, state) {
                  if (state is OrderSuccess && state.userOrdersResponse != null) {
                    final orders = state.userOrdersResponse?.orders ?? [];
                    if (orders.isNotEmpty) {
                      // Show the first (latest) order
                      final lastOrder = orders.first;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _translateOrderStatus(lastOrder.estatus ?? "Sin estado"),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: AppColors.primaryNewDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      lastOrder.fechaProgramada ?? "Sin fecha",
                                      style: const TextStyle(color: AppColors.primaryNewDark, fontSize: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primaryNewDark),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryNew,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailPage(order: lastOrder),
                                  ),
                                );
                              },
                              child: const Text(
                                "Ver detalle",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  }
                  // Show empty state message
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Todavía no tienes pedidos",
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.primaryNewDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Aquí aparecerá tu último pedido",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.time),
                        const SizedBox(width: 6),
                        const Text(
                          "Ver historial",
                          style: TextStyle(fontSize: 22, color: AppColors.primaryNewDark),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement favorites screen
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.like),
                        const SizedBox(width: 6),
                        const Text(
                          "Ver favoritos",
                          style: TextStyle(fontSize: 22, color: AppColors.primaryNewDark),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SupportPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.question),
                      const SizedBox(width: 6),
                      const Text(
                        "Ayuda y soporte",
                        style: TextStyle(fontSize: 22, color: AppColors.primaryNewDark),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
