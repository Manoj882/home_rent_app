import 'package:flutter/material.dart';

class GeneralButtomSheet {
  customBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 10,
              right: 16,
              left: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter room',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(nameController.text);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        });
  }
}
