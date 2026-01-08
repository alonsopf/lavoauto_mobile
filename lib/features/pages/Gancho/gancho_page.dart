import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/order/order_model.dart';
import 'package:lavoauto/features/pages/Gancho/bloc/gancho_bloc.dart';
import 'package:lavoauto/features/pages/Gancho/bloc/gancho_event.dart';
import 'package:lavoauto/features/pages/Gancho/bloc/gancho_state.dart';
import 'package:lavoauto/features/pages/payment/payment_method_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class GanchoPage extends StatelessWidget {
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

  const GanchoPage({
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GanchoBloc(),
      child: BlocBuilder<GanchoBloc, GanchoState>(
        builder: (context, state) {
          return CustomScaffold(
            title: "SOBRE LOS GANCHOS",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const Center(
                  child: Text(
                    "esto debe ser solo para\nropa que va planchada",
                    style: TextStyle(fontSize: 25, color: Colors.black87, height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _optionTile(
                        context,
                        state,
                        title: "Sin gancho",
                        subtitle: "Te entregamos doblado.",
                        image: Assets.hangerWhite,
                      ),
                      _optionTile(
                        context,
                        state,
                        title: "Gancho nuevo",
                        subtitle: "Te proporcionamos ganchos nuevos (puede tener costo extra).",
                      ),
                      _optionTile(
                        context,
                        state,
                        title: "Gancho del cliente",
                        subtitle: "Usar tus propios ganchos.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    "Por favor deja tus ganchos visibles al\nmomento de la recolección.",
                    style: TextStyle(fontSize: 25, color: Colors.black87),
                    textAlign: TextAlign.center,
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
                          // Get the selected gancho option from the BLoC state
                          final selectedGancho = context.read<GanchoBloc>().state.selectedOption;

                          // Create order model with all collected data
                          final orderModel = OrderModel(
                            selectedService: selectedService ?? "Lavado y Secado",
                            selectedDate: selectedDate ?? "Por especificar",
                            clothesQuantity: clothesQuantity ?? "Normal",
                            ropaDiaria: ropaDiaria ?? true,
                            ropaDelicada: ropaDelicada ?? true,
                            blancos: blancos ?? true,
                            ropaTrabajo: ropaTrabajo ?? false,
                            clothesNote: clothesNote ?? "",
                            selectedDetergent: selectedDetergent ?? "Detergente normal",
                            softener: softener ?? false,
                            temperature: temperature ?? "Tibia",
                            fragranceNote: fragranceNote ?? "",
                            ganchoOption: selectedGancho,
                            numeroPrendasPlanchado: 0,
                            selectedAddressId: selectedAddressId,
                            selectedAddressTitle: selectedAddressTitle ?? "Casa",
                            selectedPickupTime: selectedPickupTime ?? "",
                            selectedPickupTimeRange: selectedPickupTimeRange ?? "",
                            selectedDeliveryTime: selectedDeliveryTime ?? "Lo antes posible",
                            pesoAproximadoKg: 7.0,
                            lat: 0.0,
                            lon: 0.0,
                            direccion: selectedAddressTitle ?? "",
                            token: "",
                            paymentMethodId: null,
                            lavadoUrgente: false,
                            lavadoSecadoUrgente: false,
                            lavadoSecadoPlanchadoUrgente: false,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentMethodPage(
                                orderData: orderModel,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _optionTile(
    BuildContext context,
    GanchoState state, {
    required String title,
    required String subtitle,
    String? image,
  }) {
    final bool selected = (state.selectedOption == title);

    return GestureDetector(
      onTap: () => context.read<GanchoBloc>().add(SelectGanchoOption(title)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.bgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryNew,
                  width: selected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            ),
            if (image != null) SvgPicture.asset(image, height: 50),
          ],
        ),
      ),
    );
  }
}
