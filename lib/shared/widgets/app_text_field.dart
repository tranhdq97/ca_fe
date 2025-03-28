import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primaryBlue)
            : null,
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: AppColors.primaryBlue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
