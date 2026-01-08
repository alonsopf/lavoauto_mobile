import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/features/pages/chat/chat_page.dart';
import 'package:lavoauto/features/pages/history/order_history_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/features/widgets/custom_stepper.dart';
import 'package:lavoauto/theme/app_color.dart';

class OrderDeliveredPage extends StatelessWidget {
  const OrderDeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleWidget: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Pedido #LAV-1032",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Entregado",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const CustomOrderStepper(
            currentStep: 0,
            steps: [
              "Orden creada",
              "Ropa recogida",
              "En lavado",
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/40.jpg",
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manuel",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 18, color: AppColors.primaryNew),
                            SizedBox(width: 4),
                            Text("4,8", style: TextStyle(fontSize: 18)),
                          ],
                        )
                      ],
                    ),
                    Spacer(),
                    Text("Ver perfil", style: TextStyle(fontSize: 18))
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 18),
                const Text(
                  "Entrega estimada",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(Assets.time, height: 22),
                    const SizedBox(width: 8),
                    const Text(
                      "Hoy antes de las 8:00 p.m.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              isPrimary: true,
              title: "Chatear con lavador",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              isPrimary: true,
              isOutlined: true,
              title: "Llamar",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OrderHistoryPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
