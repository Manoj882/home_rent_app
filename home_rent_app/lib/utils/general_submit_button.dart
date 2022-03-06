import 'package:flutter/material.dart';

class GeneralSubmitButton extends StatefulWidget {
  const GeneralSubmitButton({
    required this.title,
    required this.onPressed,

    Key? key})
      : super(key: key);

  final String title;
  final Function()? onPressed;

  @override
  State<GeneralSubmitButton> createState() => _GeneralSubmitButtonState();
}

class _GeneralSubmitButtonState extends State<GeneralSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.purpleAccent,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
          Size(
            MediaQuery.of(context).size.width,
            40,
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.title,
      ),
    );
  }
}
