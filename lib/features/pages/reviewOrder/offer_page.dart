import 'package:flutter/material.dart';
import 'package:lavoauto/features/pages/payment/payment_method_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          const Text(
            "Ofertas para tu orden",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Recibiendo ofertas",
            style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryNewDark,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Elige la opción que mejor se adapte\n"
            "a tu presupuesto y horario.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryNewDark,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 25),
          _offerCard(
            name: "Luis",
            price: "220",
            services: "4.8   152 servicios",
            tags: const [
              "Experto en ropa delicada",
              "Servicio nocturno",
            ],
            avatar: "https://randomuser.me/api/portraits/men/30.jpg",
            context: context,
          ),
          const SizedBox(height: 15),
          _offerCard(
            name: "Ana",
            price: "230",
            services: "4.8   210 servicios",
            tags: const ["Listo mañana antes de las 7:00 p.m.", "Experto en ropa delicada"],
            avatar: "https://randomuser.me/api/portraits/women/44.jpg",
            context: context,
          ),
          const SizedBox(height: 15),
          _offerCard(
            name: "Javier",
            price: "250",
            services: "48 servicios",
            tags: const ["Listo mañana antes de las 6:00 p.m."],
            avatar: "https://randomuser.me/api/portraits/men/50.jpg",
            context: context,
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget _offerCard({
    required String name,
    required String price,
    required String services,
    required List<String> tags,
    required String avatar,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatar)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          services,
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "\$$price MXN",
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              isPrimary: true,
              title: "Ver detalle",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodPage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
