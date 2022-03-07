import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField(
      {required this.title,
      required this.textInputType,
      required this.textInputAction,
      required this.controller,
      required this.validate,
      required this.onFieldSubmitted,
      this.maxLength,
      this.isObscure = false,
      Key? key})
      : super(key: key);

  final String title;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool isObscure;
  final int? maxLength;
  final String? Function(String?)? validate;
  final Function(String)? onFieldSubmitted;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  late bool toHide;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toHide = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscureText: toHide,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        hintText: "Enter your ${widget.title}",
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  toHide
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    toHide = !toHide;
                  });
                },
              )
            : null,
      ),
      validator: widget.validate,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
