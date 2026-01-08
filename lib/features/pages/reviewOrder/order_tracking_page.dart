import 'package:flutter/material.dart';
import 'package:lavoauto/features/pages/reviewOrder/order_tracking_clean_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/features/widgets/custom_stepper.dart';
import 'package:lavoauto/theme/app_color.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

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
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "En lavado",
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/32.jpg",
                      ),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chris",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              "4.8",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "152 servicios",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                const Text(
                  "Entrega estimada",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Hoy, 4:00–5:00pm",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    isPrimary: true,
                    title: "Chatear con lavador",
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    isPrimary: true,
                    title: "Llamar",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrderTrackingCleanPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
