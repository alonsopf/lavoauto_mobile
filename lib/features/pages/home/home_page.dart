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
import 'package:lavoauto/features/pages/vehiculos/mis_vehiculos_page.dart';
import 'package:lavoauto/features/pages/order_flow/seleccionar_vehiculo_page.dart';
import 'package:lavoauto/features/pages/ordenes/mis_ordenes_page.dart';
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
              // Nueva Orden Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SeleccionarVehiculoPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_car_wash,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nueva Orden",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Solicita un lavado a domicilio ahora",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Quick Actions Grid
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: Icons.list_alt,
                      title: 'Mis Órdenes',
                      subtitle: 'Ver historial',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MisOrdenesPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: Icons.directions_car,
                      title: 'Mis Vehículos',
                      subtitle: 'Gestionar',
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MisVehiculosPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                          builder: (context) => const MisVehiculosPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car, color: AppColors.primaryNewDark, size: 24),
                        const SizedBox(width: 6),
                        const Text(
                          "Mis vehículos",
                          style: TextStyle(fontSize: 22, color: AppColors.primaryNewDark),
                        )
                      ],
                    ),
                  ),
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

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
