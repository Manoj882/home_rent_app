import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';

class GeneralDropDown extends StatefulWidget {
  const GeneralDropDown(this.monthController, {Key? key}) : super(key: key);

  // final Function(String) method;
  final TextEditingController monthController;

  @override
  State<GeneralDropDown> createState() => _GeneralDropDownState();
}

class _GeneralDropDownState extends State<GeneralDropDown> {
  final List<DropdownMenuItem<String>> list = [];

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    for (var e in MonthConstant.monthList) {
      list.add(
        DropdownMenuItem(
          child: Text(e),
          value: e,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          items: list,
          onChanged: (value) {
            widget.monthController.text = value!;
            setState(() {
              selectedValue = value;
            });
          },
          hint: const Text("Month"),
          value: selectedValue,
        ),
      ],
    );
  }
}