import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/features/pages/clothes/bloc/clothes_bloc.dart';
import 'package:lavoauto/features/pages/clothes/bloc/clothes_event.dart';
import 'package:lavoauto/features/pages/clothes/bloc/clothes_state.dart';
import 'package:lavoauto/features/pages/washPreferences/wash_preferences_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/theme/app_color.dart';

class ClothesScreen extends StatefulWidget {
  final String? selectedService;
  final String? selectedDate;

  const ClothesScreen({
    super.key,
    this.selectedService,
    this.selectedDate,
  });

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClothesBloc(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: BlocBuilder<ClothesBloc, ClothesState>(
            builder: (context, state) {
              final bloc = context.read<ClothesBloc>();
              final model = state.model;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(Assets.hangerLocation, height: 40, color: AppColors.primaryNew),
                        const SizedBox(width: 6),
                        const Text(
                          "LAVOAUTO",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNew,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Cuéntanos sobre tu ropa",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cantidad aproximada",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _quantityOption(context, model, "Poca", "hasta 5 kg"),
                              _quantityOption(context, model, "Normal", "5–10 kg"),
                              _quantityOption(context, model, "Mucha", "más de 10 kg"),
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
                          const Text("Tipo de ropa", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          _check(context, "Ropa diaria", model.ropaDiaria, "ropaDiaria"),
                          _check(context, "Ropa delicada", model.ropaDelicada, "ropaDelicada"),
                          _check(context, "Blancos (sábanas, toallas)", model.blancos, "blancos"),
                          _check(context, "Ropa de trabajo / uniformes", model.ropaTrabajo, "ropaTrabajo"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nota opcional para el lavador",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            maxLines: 3,
                            onChanged: (txt) => bloc.add(ChangeNote(txt)),
                            decoration: InputDecoration(
                              hintText: "Ej. separar playeras blancas, cuidado con la blusa azul...",
                              hintStyle: TextStyle(color: AppColors.primaryNew.withValues(alpha: 0.5), fontSize: 18),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
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
                                    bloc.add(SubmitClothes());
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WashPreferencesPage(
                                          selectedService: widget.selectedService,
                                          selectedDate: widget.selectedDate,
                                          clothesQuantity: model.quantity,
                                          ropaDiaria: model.ropaDiaria,
                                          ropaDelicada: model.ropaDelicada,
                                          blancos: model.blancos,
                                          ropaTrabajo: model.ropaTrabajo,
                                          clothesNote: model.note,
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _quantityOption(BuildContext context, model, String t, String sub) {
    final bool selected = model.quantity == t;
    final bloc = context.read<ClothesBloc>();

    return Expanded(
      child: GestureDetector(
        onTap: () => bloc.add(ChangeQuantity(t)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryNew : AppColors.greyF8,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(t),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black54,
                  fontSize: 15,
                ),
                child: Text(sub),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _check(BuildContext context, String label, bool value, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<ClothesBloc>().add(ToggleClothesType(key, !value));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primaryNew,
                  width: value ? 1 : 1.5,
                ),
                color: value ? AppColors.primaryNew : Colors.transparent,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: value
                    ? const Icon(Icons.check, key: ValueKey("icon"), color: AppColors.white, size: 16)
                    : const SizedBox(key: ValueKey("empty")),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
