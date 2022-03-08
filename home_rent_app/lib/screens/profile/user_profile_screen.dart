import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/provider/user_provider.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({required this.imageUrl, Key? key}) : super(key: key);

  final String imageUrl;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Hero(
                  tag: "image-url",
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    radius: SizeConfig.height * 10,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                Text(
                  "Edit Your Profile",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Name",
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  validate: (value) =>
                      ValidationMixin().validate(value!, "name"),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Address",
                  textInputType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  controller: addressController,
                  validate: (value) =>
                      ValidationMixin().validate(value!, "address"),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Age",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: ageController,
                  validate: (value) => ValidationMixin().validateAge(value!),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try{
                      GeneralAlertDialog().customLoadingDialog(context);
                      final map = Provider.of<UserProvider>(context, listen: false)
                          .updateUser(
                        name: nameController.text,
                        address: addressController.text,
                        age: int.parse(ageController.text),
                      );
                      final firestore = FirebaseFirestore.instance;
                      await firestore.collection(UserConstants.userCollection).add(map);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // print(map);
                    }
                    catch(ex){
                      print(ex.toString());
                      Navigator.pop(context);

                    }
                    }
                    
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
