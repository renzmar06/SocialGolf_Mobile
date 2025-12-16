import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? hintText;
  final String? label;
  final bool isObscure;
  final ValueNotifier<bool>? obscureTextNotifier;
  final bool readOnly;
  final bool isNumeric;
  final bool isDecimalAllowed;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final Color borderColor;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double borderRadius;
  final BoxConstraints? preBoxConstraints;
  final BoxConstraints? surBoxConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters; // Made optional

  const CommonTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.hintText,
    this.contentPadding,
    this.label,
    this.borderRadius = 8.0,
    this.isObscure = false,
    this.obscureTextNotifier,
    this.readOnly = false,
    this.isNumeric = false,
    this.isDecimalAllowed = false,
    this.maxLength,
    this.maxLines,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.borderColor = Colors.grey,
    this.fillColor = Colors.white,
    this.textStyle,
    this.hintStyle,
    this.preBoxConstraints,
    this.surBoxConstraints,
    this.errorText,
    this.inputFormatters = const [], // Default to empty list
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: textStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ValueListenableBuilder<bool>(
          valueListenable: obscureTextNotifier ?? ValueNotifier(isObscure),
          builder: (context, isObscured, child) {
            return TextFormField(
              controller: controller,
              initialValue: controller == null ? initialValue : null,
              focusNode: focusNode,
              obscureText: isObscured,
              cursorColor: Colors.black,
              readOnly: readOnly,
              maxLength: maxLength,
              maxLines: maxLines,
              keyboardType: isNumeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : keyboardType ?? TextInputType.text,
              textInputAction: textInputAction,
              onChanged: onChanged,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              validator: validator,
              inputFormatters: isNumeric
                  ? [
                FilteringTextInputFormatter.allow(
                    RegExp(isDecimalAllowed ? r'[0-9.]' : r'[0-9]')),
                ...?inputFormatters, // Spread optional inputFormatters
              ]
                  : inputFormatters ?? [], // Use provided inputFormatters or empty list
              style: textStyle,
              decoration: InputDecoration(
                contentPadding: contentPadding,
                suffixIcon: obscureTextNotifier != null && isObscure
                    ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    obscureTextNotifier!.value = !isObscured;
                  },
                )
                    : suffixIcon,
                prefixIcon: prefixIcon,
                suffixIconConstraints: surBoxConstraints,
                prefixIconConstraints: preBoxConstraints,
                filled: true,
                fillColor: fillColor,
                hintText: hintText,
                hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: borderColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                errorText: errorText,
              ),
            );
          },
        ),
      ],
    );
  }
}