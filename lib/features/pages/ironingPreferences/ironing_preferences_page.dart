import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/features/pages/Gancho/gancho_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class IroningPreferencesPage extends StatefulWidget {
  final String? selectedService;
  final String? selectedDate;
  final String? clothesQuantity;
  final bool? ropaDiaria;
  final bool? ropaDelicada;
  final bool? blancos;
  final bool? ropaTrabajo;
  final String? clothesNote;
  final String? selectedDetergent;
  final bool? softener;
  final String? temperature;
  final String? fragranceNote;
  final String? selectedAddressTitle;
  final int? selectedAddressId;
  final String? selectedPickupTime;
  final String? selectedPickupTimeRange;
  final String? selectedDeliveryTime;

  const IroningPreferencesPage({
    super.key,
    this.selectedService,
    this.selectedDate,
    this.clothesQuantity,
    this.ropaDiaria,
    this.ropaDelicada,
    this.blancos,
    this.ropaTrabajo,
    this.clothesNote,
    this.selectedDetergent,
    this.softener,
    this.temperature,
    this.fragranceNote,
    this.selectedAddressTitle,
    this.selectedAddressId,
    this.selectedPickupTime,
    this.selectedPickupTimeRange,
    this.selectedDeliveryTime,
  });

  @override
  State<IroningPreferencesPage> createState() => _IroningPreferencesPageState();
}

class _IroningPreferencesPageState extends State<IroningPreferencesPage> {
  String selectedIroningType = "Planchado básico (uso diario)";
  String? selectedSpecialCare;

  final List<String> ironingTypes = [
    "Planchado básico (uso diario)",
    "Planchado detallado (camisas, vestidos, prendas formales)",
  ];

  final List<String> specialCares = [
    "Planchado a baja temperatura",
    "No usar vapor",
    "Solo vapor, sin presión",
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleWidget: SvgPicture.asset(Assets.hanger, height: 45, color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const Center(
            child: Text(
              "Preferencias de planchado",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tipo de planchado",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ...ironingTypes.map((type) => _radioItem(type, selectedIroningType == type, () {
                  setState(() {
                    selectedIroningType = type;
                  });
                })),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cuidados especiales",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ...specialCares.map((care) => _checkboxItem(care, selectedSpecialCare == care, () {
                  setState(() {
                    selectedSpecialCare = selectedSpecialCare == care ? null : care;
                  });
                })),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: "Atrás",
                  isPrimary: false,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: CustomButton(
                  title: "Continuar",
                  isPrimary: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GanchoPage(
                          selectedService: widget.selectedService,
                          selectedDate: widget.selectedDate,
                          clothesQuantity: widget.clothesQuantity,
                          ropaDiaria: widget.ropaDiaria,
                          ropaDelicada: widget.ropaDelicada,
                          blancos: widget.blancos,
                          ropaTrabajo: widget.ropaTrabajo,
                          clothesNote: widget.clothesNote,
                          selectedDetergent: widget.selectedDetergent,
                          softener: widget.softener,
                          temperature: widget.temperature,
                          fragranceNote: widget.fragranceNote,
                          selectedAddressTitle: widget.selectedAddressTitle,
                          selectedAddressId: widget.selectedAddressId,
                          selectedPickupTime: widget.selectedPickupTime,
                          selectedPickupTimeRange: widget.selectedPickupTimeRange,
                          selectedDeliveryTime: widget.selectedDeliveryTime,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _radioItem(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: selected ? 4 : 2,
                  color: selected ? AppColors.primaryNew : AppColors.primaryNew.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkboxItem(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primaryNew,
                  width: selected ? 1 : 1.5,
                ),
                color: selected ? AppColors.primaryNew : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, color: AppColors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

