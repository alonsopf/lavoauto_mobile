import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          const Text(
            "¿Cómo estuvo tu servicio?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: AppColors.primaryNewDark),
          ),
          const SizedBox(height: 25),
          const CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/32.jpg"),
          ),
          const SizedBox(height: 14),
          const Text(
            "Miguel",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: AppColors.primaryNewDark),
          ),
          const SizedBox(height: 18),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            unratedColor: Colors.grey.shade300,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
            onRatingUpdate: (rating) {},
          ),
          const SizedBox(height: 25),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Cuéntanos qué te gustó o qué podemos mejorar.",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: AppColors.primaryNew, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                "Guardar como lavador favorito",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryNewDark),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(isPrimary: true, title: "Enviar calificación", onTap: () {}),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
