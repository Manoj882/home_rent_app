import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/utils/size_config.dart';

class GeneralAlertDialog {
  customLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(
              width: SizeConfig.width * 2.5,
            ),
            const Text(
              "Loading",
            ),
          ],
        ),
      ),
    );
  }

  customAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
            ),
          ),
        ],
      ),
    );
  }
}
