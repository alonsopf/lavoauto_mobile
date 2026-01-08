import 'package:flutter/material.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/text_field.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';

class RatingWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Function(double rating, String comments) onSubmitRating;
  final VoidCallback onCancel;
  final bool isReadOnly;
  final double? existingRating;
  final String? existingComments;

  const RatingWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.onSubmitRating,
    required this.onCancel,
    this.isReadOnly = false,
    this.existingRating,
    this.existingComments,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _selectedRating;
  final TextEditingController _commentsController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existingRating ?? 0.0;
    _commentsController.text = widget.existingComments ?? '';
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          CustomText(
            text: widget.title,
            fontSize: 22.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ).setText(),
          
          if (widget.subtitle != null) ...[
            const YMargin(8.0),
            CustomText(
              text: widget.subtitle!,
              fontSize: 16.0,
              fontColor: AppColors.primary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ).setText(),
          ],
          
          const YMargin(24.0),
          
          // Rating Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: widget.isReadOnly ? null : () {
                  setState(() {
                    _selectedRating = starIndex.toDouble();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    starIndex <= _selectedRating ? Icons.star : Icons.star_border,
                    color: starIndex <= _selectedRating 
                        ? Colors.amber 
                        : AppColors.primary.withOpacity(0.3),
                    size: 40.0,
                  ),
                ),
              );
            }),
          ),
          
          const YMargin(8.0),
          
          // Rating text
          CustomText(
            text: _selectedRating > 0 
                ? '${_selectedRating.toStringAsFixed(1)}/5.0'
                : 'Selecciona una calificación',
            fontSize: 16.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ).setText(),
          
          const YMargin(24.0),
          
          // Comments field
          if (!widget.isReadOnly) ...[
            CustomText(
              text: 'Comentarios (opcional)',
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            const YMargin(8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _commentsController,
                maxLines: 3,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Escribe tus comentarios aquí...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12.0),
                  counterText: '', // This hides the character counter
                  hintStyle: TextStyle(
                    color: AppColors.primary.withOpacity(0.6),
                    fontSize: 14.0,
                  ),
                ),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.0,
                ),
              ),
            ),
          ] else if (widget.existingComments != null && widget.existingComments!.isNotEmpty) ...[
            CustomText(
              text: 'Comentarios:',
              fontSize: 16.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ).setText(),
            const YMargin(8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: CustomText(
                text: widget.existingComments!,
                fontSize: 14.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
            ),
          ],
          
          const YMargin(24.0),
          
          // Action buttons
          if (!widget.isReadOnly) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: CustomText(
                      text: 'Cancelar',
                      fontSize: 16.0,
                      fontColor: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ).setText(),
                  ),
                ),
                const XMargin(16.0),
                Expanded(
                  child: PrimaryButton.primarybutton(
                    text: 'Calificar',
                    onpressed: _selectedRating > 0 ? () {
                      widget.onSubmitRating(_selectedRating, _commentsController.text);
                    } : null,
                    isPrimary: true,
                    isEnable: _selectedRating > 0,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ] else ...[
            PrimaryButton.primarybutton(
              text: 'Cerrar',
              onpressed: widget.onCancel,
              isPrimary: true,
              isEnable: true,
              width: double.infinity,
            ),
          ],
        ],
      ),
    );
  }
} 