import 'package:flutter/material.dart';

class GeneralDivider extends StatefulWidget {
  const GeneralDivider(this.dividerName, {Key? key}) : super(key: key);

  final String dividerName;

  @override
  State<GeneralDivider> createState() => _GeneralDividerState();
}

class _GeneralDividerState extends State<GeneralDivider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 2,
            endIndent: 5,

          ),
        ),
        Text(
          widget.dividerName,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Expanded(
          child: Divider(
            thickness: 2,
            indent: 5,
          ),
        ),
      ],
    );
  }
}
