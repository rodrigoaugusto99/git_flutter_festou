import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';

Widget myRow({
  required String label,
  required TextEditingController controller,
  required String? Function(String?)? validator,
  Function(String)? onChanged,
  String? prefix,
  int? maxLines,
  bool enabled = true,
  bool alwaysOnTop = false,
  bool onlyNumber = false,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Container(
    //  padding: const EdgeInsets.symmetric(v: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: TextFormField(
      key: Keys.kTextFormField,
      keyboardType: onlyNumber ? TextInputType.number : null,
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      controller: controller,
      inputFormatters: inputFormatters,
      maxLines: maxLines, //
      style: TextStyle(
        fontSize: 15,
        color: enabled ? Colors.black : Colors.grey,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior:
            alwaysOnTop ? FloatingLabelBehavior.always : null,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 5.0,
        ),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Color(0xff4300B1)),
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
