import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:festou/src/helpers/keys.dart';

class CustomTextformfield extends StatefulWidget {
  final bool enable;
  final String? label;
  final String? svgPath;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  Function(String)? onChanged;
  Function()? onEditingComplete;
  bool hasEye;
  bool isBig;
  double? ddd;
  double? scale;
  double? height;
  double? verticalPadding;
  double? horizontalPadding;
  double? svgWidth;
  Color? fillColor;
  Widget? prefixIcon;
  bool? withCrazyPadding;
  Key? customKey;
  int? maxLength;
  CustomTextformfield({
    super.key,
    this.label,
    this.maxLength,
    this.customKey,
    this.hintText,
    this.prefixIcon,
    this.fillColor,
    this.height,
    this.verticalPadding,
    this.horizontalPadding,
    this.inputFormatters,
    this.ddd,
    this.scale,
    this.svgPath,
    this.svgWidth,
    this.hasEye = false,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.onEditingComplete,
    this.enable = true,
    this.obscureText = false,
    this.isBig = false,
    this.withCrazyPadding = false,
  });

  @override
  State<CustomTextformfield> createState() => _CustomTextformfieldState();
}

bool isVisible = false;

class _CustomTextformfieldState extends State<CustomTextformfield> {
//  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _charCount = widget.controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    //widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        key: Keys.kTextFormField,
        minLines: widget.isBig == true ? 5 : 1,
        maxLines: widget.isBig == true ? 10 : 1,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: TextInputAction.done,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText == false
            ? false
            : isVisible
                ? false
                : true,
        onChanged: widget.onChanged ?? (v) {},
        enabled: widget.enable,
        controller: widget.controller,
        validator: widget.validator,

        keyboardType: widget.keyboardType, maxLength: widget.maxLength,
        // onTapOutside: (event) => {FocusScope.of(context).unfocus()},
        style: TextStyle(
            fontSize: 14,
            color: widget.enable ? Colors.black : Colors.grey,
            overflow: TextOverflow.ellipsis),
        decoration: InputDecoration(
          counterText: widget.maxLength == null
              ? null
              : "$_charCount / ${widget.maxLength}",
          hintText: widget.hintText,
          prefixIcon: widget.svgPath != null
              ? Padding(
                  padding: EdgeInsets.only(left: widget.ddd!, right: 5),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: widget.svgWidth ?? 0,
                    // color: Colors.red,
                    child: Image.asset(
                      scale: widget.scale ?? 2,
                      widget.svgPath!,
                      color: Colors.black,
                    ),
                  ),
                )
              : widget.withCrazyPadding == true
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 14,
                      ),
                      child: widget.prefixIcon,
                    )
                  : widget.prefixIcon,
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
          fillColor: widget.fillColor ?? Colors.white,
          filled: true,
          labelStyle: TextStyle(
            color: !widget.enable ? Colors.grey[500] : Colors.black,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding ?? 10,
            horizontal: widget.horizontalPadding ?? 10,
          ),
          alignLabelWithHint: widget.isBig ? true : null,
          label: widget.label != null ? Text(widget.label!) : null,
          hintStyle: const TextStyle(
            fontSize: 14,
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
      ),
    );
  }
}
