import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final double padding;
  final String? errorText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.padding = 0,
    this.errorText,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8DFF8)),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          validator: widget.validator,
          controller: widget.controller,
          obscureText: !isPasswordVisible,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            color: _ink,
            fontSize: 14,
          ),
          cursorColor: _accent,
          decoration: InputDecoration(
            errorText:
                widget.errorText?.isNotEmpty == true ? widget.errorText : null,
            labelText: widget.label,
            labelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _muted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: _accent,
                size: 20,
              ),
              onPressed: () {
                setState(() => isPasswordVisible = !isPasswordVisible);
              },
            ),
          ),
        ),
      ),
    );
  }
}
