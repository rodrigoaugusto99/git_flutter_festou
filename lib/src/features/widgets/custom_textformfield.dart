import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextformfield extends StatefulWidget {
  final bool enable;
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  Function(String)? onChanged;
  Function()? onEditingComplete;
  bool hasEye;
  CustomTextformfield({
    super.key,
    required this.label,
    this.inputFormatters,
    this.hasEye = false,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.onEditingComplete,
    this.enable = true,
    this.obscureText = false,
  });

  @override
  State<CustomTextformfield> createState() => _CustomTextformfieldState();
}

bool isVisible = false;

class _CustomTextformfieldState extends State<CustomTextformfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: widget.onEditingComplete,
      textInputAction: TextInputAction.done,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText == false
          ? false
          : isVisible
              ? false
              : true,
      onChanged: widget.onChanged,
      enabled: widget.enable,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onTapOutside: (event) => {FocusScope.of(context).unfocus()},
      style: TextStyle(
          color: widget.enable ? Colors.black : Colors.grey,
          overflow: TextOverflow.ellipsis),
      decoration: InputDecoration(
        suffixIcon: widget.hasEye
            ? GestureDetector(
                onTap: () => setState(
                  () {
                    isVisible = !isVisible;
                  },
                ),
                child: isVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : null,
        fillColor: Colors.white,
        filled: true,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        label: Text(widget.label),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xff48464C),
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
