import 'package:flutter/material.dart';

Widget myRow({
  required String label,
  required TextEditingController controller,
  required String? Function(String?)? validator,
  Function(String)? onChanged,
  int? maxLines,
  bool enabled = true,
  bool alwaysOnTop = false,
}) {
  return Container(
    //  padding: const EdgeInsets.symmetric(v: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: TextFormField(
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      controller: controller,

      maxLines: maxLines, //
      style: TextStyle(
        fontSize: 15,
        color: enabled ? Colors.black : Colors.grey,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior:
            alwaysOnTop ? FloatingLabelBehavior.always : null,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 5.0,
        ),
        label: Text(label),
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
    ),
  );
}
