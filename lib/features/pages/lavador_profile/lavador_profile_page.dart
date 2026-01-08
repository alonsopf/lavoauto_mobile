import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/features/pages/edit_services/edit_services_page.dart';
import 'package:lavoauto/features/pages/edit_profile/edit_profile_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class LavadorProfilePage extends StatefulWidget {
  const LavadorProfilePage({super.key});

  @override
  State<LavadorProfilePage> createState() => _LavadorProfilePageState();
}

class _LavadorProfilePageState extends State<LavadorProfilePage> {
  @override
  void initState() {
    super.initState();
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNew,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.primaryNew,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Perfil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header section with profile photo and name
          Container(
            color: AppColors.primaryNew,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                String userName = "Gaby";
                String? photoUrl;
                
                if (state is UserInfoSuccess && state.userWorkerInfo?.data != null) {
                  userName = state.userWorkerInfo!.data!.nombre ?? "Usuario";
                  photoUrl = state.userWorkerInfo!.data!.fotoUrl;
                }

                return Column(
                  children: [
                    // Profile photo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: photoUrl != null && photoUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 16),
                    // User name
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Menu options
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _menuItem(
                    title: "Mi perfil",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  _menuItem(
                    title: "Editar servicios",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditServicesPage(),
                        ),
                      );
                    },
                  ),
                  _menuItem(
                    title: "Editar precios",
                    onTap: () {
                      // TODO: Navigate to edit prices page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad próximamente')),
                      );
                    },
                  ),
                  _menuItem(
                    title: "Horarios",
                    onTap: () {
                      // TODO: Navigate to schedules page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad próximamente')),
                      );
                    },
                  ),
                  _menuItem(
                    title: "Cuenta bancaria",
                    onTap: () {
                      // TODO: Navigate to bank account page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad próximamente')),
                      );
                    },
                  ),
                  _menuItem(
                    title: "Ayuda",
                    onTap: () {
                      // TODO: Navigate to help page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad próximamente')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _menuItem(
                    title: "Cerrar sesión",
                    isDestructive: true,
                    onTap: () async {
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

                      if (shouldLogout == true && mounted) {
                        await Utils.sharedpref?.clear();
                        if (mounted) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? AppColors.error : AppColors.black,
                    ),
                  ),
                ),
                if (!isDestructive)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.grey.withOpacity(0.5),
                  ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.borderGrey.withOpacity(0.5),
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}

