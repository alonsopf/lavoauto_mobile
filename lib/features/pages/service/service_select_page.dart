import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/features/pages/service/bloc/service_bloc.dart';
import 'package:lavoauto/features/pages/service/bloc/service_event.dart';
import 'package:lavoauto/features/pages/service/bloc/service_state.dart';
import 'package:lavoauto/features/pages/service/date_time_picker_page.dart';
import 'package:lavoauto/features/pages/clothes/clothes_screen.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class ServiceSelectPage extends StatelessWidget {
  const ServiceSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceBloc(),
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          final bloc = context.read<ServiceBloc>();
          return CustomScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryNewDark,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Tu ropa lista sin\nsalir de casa.",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNewDark,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "¿Qué necesitas?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryNewDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _serviceOption(
                              context,
                              icon: Icons.local_laundry_service,
                              label: "Lavado",
                              selected: state.selectedService == "Lavado",
                              onTap: () => bloc.add(SelectService("Lavado")),
                            ),
                            const SizedBox(width: 10),
                            _serviceOption(
                              context,
                              icon: Icons.water_drop,
                              label: "Lavado y\nSecado",
                              selected: state.selectedService == "Lavado y Secado",
                              onTap: () => bloc.add(SelectService("Lavado y Secado")),
                            ),
                            const SizedBox(width: 10),
                            _serviceOption(
                              context,
                              icon: Icons.iron_rounded,
                              label: "Lavado,\nSecado y\nPlanchado",
                              selected: state.selectedService == "Lavado, Secado y Planchado",
                              onTap: () => bloc.add(SelectService("Lavado, Secado y Planchado")),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _card(
                  child: InkWell(
                    onTap: () async {
                      final selectedDateTime = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (context) => const DateTimePickerPage(),
                        ),
                      );
                      if (selectedDateTime != null) {
                        bloc.add(SelectDate(selectedDateTime));
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "¿Cuándo lo necesitas?",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryNewDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.calendar_today_rounded,
                                        size: 18,
                                        color: AppColors.primaryNewDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    state.selectedDate,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: AppColors.primaryNewDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.primaryNewDark,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // COMENTADO: Sección de ofertas hardcodeadas - Se movió a order_detail_page.dart
                // _card(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           const Text(
                //             "Elige una oferta",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.w500,
                //               color: AppColors.primaryNewDark,
                //             ),
                //           ),
                //           Text(
                //             "deslizarse para ver más ofertas",
                //             style: TextStyle(
                //               fontSize: 13,
                //               fontWeight: FontWeight.w400,
                //               color: AppColors.primaryNewDark.withOpacity(0.6),
                //               fontStyle: FontStyle.italic,
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 7),
                //       Container(
                //         padding: const EdgeInsets.all(8),
                //         decoration: BoxDecoration(
                //           color: AppColors.primaryNew.withValues(alpha: 0.2),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Column(
                //           children: [
                //             const SizedBox(height: 7),
                //             const Row(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 CircleAvatar(
                //                   backgroundColor: AppColors.primaryNew,
                //                   radius: 22,
                //                   backgroundImage: NetworkImage(
                //                     "https://randomuser.me/api/portraits/women/2.jpg",
                //                   ),
                //                 ),
                //                 SizedBox(width: 12),
                //                 Expanded(
                //                   child: Column(
                //                     crossAxisAlignment: CrossAxisAlignment.start,
                //                     children: [
                //                       Text(
                //                         "Ana",
                //                         style: TextStyle(
                //                           height: 1.3,
                //                           fontWeight: FontWeight.w600,
                //                           fontSize: 20,
                //                         ),
                //                       ),
                //                       Text(
                //                         "Entrega garantizada",
                //                         style: TextStyle(
                //                           height: 1.3,
                //                           fontWeight: FontWeight.w400,
                //                           fontSize: 18,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Text(
                //                   "\$180",
                //                   style: TextStyle(
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryNewHeader,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(height: 18),
                //             SizedBox(
                //               width: double.infinity,
                //               child: ElevatedButton(
                //                 onPressed: () {
                //                   Navigator.of(context).push(
                //                     MaterialPageRoute(
                //                       builder: (context) => ClothesScreen(
                //                         selectedService: state.selectedService,
                //                         selectedDate: state.selectedDate,
                //                       ),
                //                     ),
                //                   );
                //                 },
                //                 style: ElevatedButton.styleFrom(
                //                   elevation: 0,
                //                   shadowColor: Colors.transparent,
                //                   surfaceTintColor: Colors.transparent,
                //                   padding: const EdgeInsets.symmetric(vertical: 14),
                //                   backgroundColor: AppColors.primaryNew,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(14),
                //                   ),
                //                 ),
                //                 child: const Text(
                //                   "Ver ofertas",
                //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClothesScreen(
                            selectedService: state.selectedService,
                            selectedDate: state.selectedDate,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primaryNew,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _serviceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryNew : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                tween: Tween<double>(begin: 0.9, end: selected ? 1.2 : 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      icon,
                      size: 30,
                      color: selected ? AppColors.white : AppColors.primaryNewDark,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.primaryNewDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
