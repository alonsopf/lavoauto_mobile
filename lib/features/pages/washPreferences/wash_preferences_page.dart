import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/features/pages/pickUp/pickup_schedule_page.dart';
import 'package:lavoauto/bloc/user/addresses_bloc.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/washPreferences/bloc/wash_bloc.dart';
import 'package:lavoauto/features/pages/washPreferences/bloc/wash_event.dart';
import 'package:lavoauto/features/pages/washPreferences/bloc/wash_state.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class WashPreferencesPage extends StatelessWidget {
  final String? selectedService;
  final String? selectedDate;
  final String? clothesQuantity;
  final bool? ropaDiaria;
  final bool? ropaDelicada;
  final bool? blancos;
  final bool? ropaTrabajo;
  final String? clothesNote;

  const WashPreferencesPage({
    super.key,
    this.selectedService,
    this.selectedDate,
    this.clothesQuantity,
    this.ropaDiaria,
    this.ropaDelicada,
    this.blancos,
    this.ropaTrabajo,
    this.clothesNote,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WashBloc(),
      child: BlocBuilder<WashBloc, WashState>(
        builder: (context, state) {
          final bloc = context.read<WashBloc>();
          return CustomScaffold(
            titleWidget: SvgPicture.asset(Assets.hanger, height: 45, color: AppColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const Center(
                  child: Text(
                    "¿Cómo quieres que\nlavemos tu ropa?",
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
                      const Text("Detergente", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      _radioItem(context, state, "Detergente normal"),
                      _radioItem(context, state, "Detergente para piel sensible"),
                      _radioItem(context, state, "Ecológico (si disponible)"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Suavizante", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => bloc.add(ToggleSoftener(false)),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: !state.softener ? AppColors.primaryNew : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: !state.softener ? AppColors.primaryNew : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sin suavizante",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: !state.softener ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => bloc.add(ToggleSoftener(true)),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: state.softener ? AppColors.primaryNew : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: state.softener ? AppColors.primaryNew : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Con suavizante",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: state.softener ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Temperatura del agua", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _tempOption(context, state, "Fría"),
                          _tempOption(context, state, "Tibia"),
                          _tempOption(context, state, "Caliente"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Alergias", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 14),
                      TextField(
                        onChanged: (txt) => bloc.add(UpdateFragranceNote(txt)),
                        decoration: InputDecoration(
                          hintText: "¿Alguna alergia o preferencia especial?",
                          filled: false,
                          isDense: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                final bloc = context.read<WashBloc>();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider<AddressesBloc>(
                                      create: (context) => AppContainer.getIt.get<AddressesBloc>(),
                                      child: PickupSchedulePage(
                                        selectedService: selectedService,
                                        selectedDate: selectedDate,
                                        clothesQuantity: clothesQuantity,
                                        ropaDiaria: ropaDiaria,
                                        ropaDelicada: ropaDelicada,
                                        blancos: blancos,
                                        ropaTrabajo: ropaTrabajo,
                                        clothesNote: clothesNote,
                                        selectedDetergent: bloc.state.selectedDetergent,
                                        softener: bloc.state.softener,
                                        temperature: bloc.state.temperature,
                                        fragranceNote: bloc.state.fragranceNote,
                                      ),
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
                ),
                const SizedBox(height: 32),
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
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _radioItem(BuildContext context, WashState state, String title) {
    final bool selected = state.selectedDetergent == title;

    return InkWell(
      onTap: () => context.read<WashBloc>().add(SelectDetergent(title)),
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
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tempOption(BuildContext context, WashState state, String label) {
    final bool selected = state.temperature == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<WashBloc>().add(SelectTemperature(label)),
        child: AnimatedScale(
          scale: selected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: selected ? AppColors.primaryNewDark : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
