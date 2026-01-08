import 'package:flutter/material.dart';
import 'package:lavoauto/features/pages/reviewOrder/order_delivered_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/features/widgets/custom_stepper.dart';

class OrderTrackingCleanPage extends StatelessWidget {
  const OrderTrackingCleanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "LAV-1032",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const Center(
            child: Text(
              "En camino a entrega",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xff123A63),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const CustomOrderStepper(
            currentStep: 0,
            steps: [
              "Orden creada",
              "Ropa recogida",
              "En lavado",
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/46.jpg",
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Javier",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text("4,8", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 6),
                        Text(
                          "Vetavr",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    )
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Horario estimado de entrega",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Hoy antes de las 8:00 pm",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              isPrimary: true,
              title: "Chatear con lavador",
              onTap: () {},
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              isOutlined: true,
              isPrimary: true,
              title: "Llamar",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OrderDeliveredPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
