import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/available_orders/available_orders_page.dart';
import 'package:lavoauto/features/pages/my_active_orders/my_active_orders_page.dart';
import 'package:lavoauto/features/pages/earnings/earnings_page.dart';
import 'package:lavoauto/features/pages/lavador_profile/lavador_profile_page.dart';
import 'package:lavoauto/features/pages/chat_list/chat_list_page.dart';
import 'package:lavoauto/features/pages/lavador_ordenes/lavador_ordenes_page.dart';
import 'package:lavoauto/presentation/common_widgets/custom_drawer.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

@RoutePage()
class LavadorHomePage extends StatefulWidget {
  const LavadorHomePage({super.key});

  @override
  State<LavadorHomePage> createState() => _LavadorHomePageState();
}

class _LavadorHomePageState extends State<LavadorHomePage> {
  late UserInfoBloc _userInfoBloc;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _userInfoBloc = context.read<UserInfoBloc>();
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _userInfoBloc.add(FetchUserProfileInfoEvent(token: token));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home, do nothing
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChatListPage(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LavadorProfilePage(),
          ),
        );
        break;
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryNew, size: 24),
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
                    child: const Text(
                      "Cerrar sesión",
                      style: TextStyle(color: AppColors.error),
                    ),
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
        elevation: 0,
        title: const Text(
          "LAVOAUTO",
          style: TextStyle(
            color: AppColors.primaryNew,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
      drawer: CustomDrawer(
        title: "Menu",
        ontap: () => Navigator.pop(context),
        isUser: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Status indicator
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Disponible",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryNew.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Órdenes disponibles\ncerca de ti",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Ver trabajos disponibles button (Old system)
              _buildMenuButton(
                icon: Icons.local_offer_outlined,
                title: "Ver trabajos disponibles",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AvailableOrdersPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Órdenes Recibidas button (New system)
              _buildMenuButton(
                icon: Icons.assignment_outlined,
                title: "Órdenes Recibidas",
                subtitle: "Nuevo sistema de órdenes",
                color: AppColors.primaryNew,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LavadorOrdenesPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Mis pedidos activos button
              _buildMenuButton(
                icon: Icons.receipt_long_outlined,
                title: "Mis pedidos activos",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyActiveOrdersPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Ganancias button
              _buildMenuButton(
                icon: Icons.attach_money,
                title: "Ganancias",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EarningsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Mis Servicios button
              _buildMenuButton(
                icon: Icons.build_outlined,
                title: "Mis Servicios",
                onTap: () {
                  context.router.push(routeFiles.MisServiciosListRoute());
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primaryNew,
        unselectedItemColor: AppColors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 28),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, size: 28),
            activeIcon: Icon(Icons.chat_bubble, size: 28),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    Color? color,
  }) {
    final effectiveColor = color ?? AppColors.primaryNew;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.borderGrey.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: effectiveColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: effectiveColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: effectiveColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

