import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_color.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofill;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool isVisible, readOnly;
  final Color fillcolour;
  final Color? hintColor;
  final int maxLength, maxLines;
  final List<TextInputFormatter>? textInputFormatter;
  final Function(String)? onChanged;
  final Function()? ontap, onEditingComplete;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final bool isPassword;

  const CustomTextFieldWidget(
      {Key? key,
      required this.controller,
      this.hintText = 'A Text is missing HERE!',
      this.keyboardType,
      this.readOnly = false,
      this.ontap,
      this.validator,
      this.autofill,
      this.prefixWidget,
      this.isVisible = false,
      required this.maxLength,
      this.textInputFormatter,
      this.onEditingComplete,
      this.fillcolour = AppColors.whiteColor,
      this.hintColor,
      this.suffixWidget = const SizedBox(),
      this.onChanged,
      this.maxLines = 1,
      this.focusNode,
      this.textInputAction,
      this.onFieldSubmitted,
      this.isPassword = false})
      : super(key: key);

  final TextEditingController controller;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword && !widget.isVisible;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffixWidget;

    if (widget.isPassword) {
      effectiveSuffixWidget = IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility : Icons.visibility_off,
          color: AppColors.greyNormalColor,
        ),
        onPressed: _toggleVisibility,
      );
    } else {
      effectiveSuffixWidget = widget.suffixWidget;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        readOnly: widget.readOnly,
        inputFormatters: widget.textInputFormatter,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted ?? widget.onChanged,
        obscureText: widget.isPassword ? _isObscure : !widget.isVisible,
        key: widget.key,
        onTap: widget.ontap,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        cursorColor: AppColors.primary,
        keyboardType: widget.keyboardType,
        autofillHints: widget.autofill,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.screenBackgroundColor, // Off white
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          prefixIcon: widget.prefixWidget,
          suffixIcon: effectiveSuffixWidget,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.hintColor ?? AppColors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.borderGrey,
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.accent, // Light blue border when active
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.pinkNormalColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.pinkNormalColor,
              width: 2,
            ),
          ),
          counter: const Offstage(),
        ),
      ),
    );
  }
}
