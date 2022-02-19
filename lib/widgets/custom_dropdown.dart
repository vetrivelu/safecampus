import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    required this.labelText,
    this.hintText,
    required this.items,
    this.onChanged,
    this.onTap,
    this.leftPad = 20,
    required this.selectedValue,
  }) : super(key: key);

  final String labelText;
  final String? hintText;
  final T? selectedValue;

  final void Function(T?)? onChanged;
  final void Function()? onTap;
  final double? leftPad;

  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: false,
      value: selectedValue,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        constraints: const BoxConstraints.expand(height: 65),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFFEF4C43),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFF95A1AC),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
      ),
      style: const TextStyle(
        fontFamily: 'Lexend Deca',
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      items: items,
    );
  }
}
