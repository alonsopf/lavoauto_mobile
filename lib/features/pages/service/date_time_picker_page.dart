import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';

class DateTimePickerPage extends StatefulWidget {
  const DateTimePickerPage({super.key});

  @override
  State<DateTimePickerPage> createState() => _DateTimePickerPageState();
}

class _DateTimePickerPageState extends State<DateTimePickerPage> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  String? selectedUrgency; // null = Sin urgencia, "Sin urgencia", "Lavado urgente", "Lavado y secado urgente", "Lavado, secado y planchado urgente"

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  String _formatDate(DateTime date) {
    final format = DateFormat('EEEE, d MMMM yyyy', 'es_ES');
    return format.format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _confirm() {
    // Combine date and time
    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Format as friendly string to return
    final dateFormat = DateFormat('dd MMM yyyy - HH:mm', 'es_ES');
    final formattedDateTime = dateFormat.format(dateTime);

    // Return to previous screen with the selected date/time
    Navigator.pop(context, formattedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "¿Cuándo lo necesitas?",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const Text(
            "¿Cuándo recogemos tu ropa?",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNewDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Elige la fecha y hora de recolección",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryNewDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 28),
          // Date Picker Card
          _buildPickerCard(
            icon: Icons.calendar_today_rounded,
            title: "Fecha",
            value: _formatDate(selectedDate),
            onTap: _selectDate,
          ),
          const SizedBox(height: 20),
          // Time Picker Card
          _buildPickerCard(
            icon: Icons.schedule_rounded,
            title: "Hora",
            value: _formatTime(selectedTime),
            onTap: _selectTime,
          ),
          const SizedBox(height: 40),
          // Urgency Options
          const Text(
            "Opciones urgentes (tarifa más elevada):",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNewDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildUrgencyOption(
            title: "Sin urgencia",
            isSelected: selectedUrgency == null || selectedUrgency == "Sin urgencia",
            onTap: () {
              setState(() {
                selectedUrgency = "Sin urgencia";
              });
            },
          ),
          const SizedBox(height: 12),
          _buildUrgencyOption(
            title: "Lavado urgente",
            isSelected: selectedUrgency == "Lavado urgente",
            onTap: () {
              setState(() {
                selectedUrgency = "Lavado urgente";
              });
            },
          ),
          const SizedBox(height: 12),
          _buildUrgencyOption(
            title: "Lavado y secado urgente",
            isSelected: selectedUrgency == "Lavado y secado urgente",
            onTap: () {
              setState(() {
                selectedUrgency = "Lavado y secado urgente";
              });
            },
          ),
          const SizedBox(height: 12),
          _buildUrgencyOption(
            title: "Lavado, secado y planchado urgente",
            isSelected: selectedUrgency == "Lavado, secado y planchado urgente",
            onTap: () {
              setState(() {
                selectedUrgency = "Lavado, secado y planchado urgente";
              });
            },
          ),
          const SizedBox(height: 40),
          // Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryNew.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryNew.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Resumen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryNewDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryNew,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_formatDate(selectedDate)} a las ${_formatTime(selectedTime)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryNewDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _confirm,
              child: const Text(
                "Confirmar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryNew.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryNew.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryNew,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryNewDark.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNewDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_rounded,
              color: AppColors.primaryNew,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNew.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryNew : AppColors.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryNew : AppColors.borderGrey,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryNew : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryNew : AppColors.primaryNewDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
