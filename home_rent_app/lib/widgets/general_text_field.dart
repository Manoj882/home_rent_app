import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField({
    required this.title,
    required this.textInputType,
    required this.textInputAction,
    required this.controller,
    required this.validate,

     Key? key }) : super(key: key);


  final String title;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validate;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: "Enter your ${widget.title}",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
            ),
            validator: widget.validate,
          );
  }
}