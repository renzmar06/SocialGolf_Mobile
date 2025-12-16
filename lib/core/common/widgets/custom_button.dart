import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? textColor; // Optional parameter to override text color
  final String? btnText;
  final double? borderRadius;// Optional parameter to override text color
  final double maxWidth;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    this.disabledBackgroundColor,
    required this.btnText,
    this.textColor,
    this.borderRadius,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    // Apply default text style if the child is a Text widget
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 50,
          maxWidth: maxWidth,
          minHeight: 50,
        ),
        decoration: ShapeDecoration(
          color: isDisabled ? disabledBackgroundColor : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
        child: Center(
          child: Text(
            btnText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
