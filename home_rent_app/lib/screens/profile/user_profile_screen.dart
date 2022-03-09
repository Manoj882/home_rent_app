import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/provider/user_provider.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';
import 'package:image_picker/image_picker.dart';
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
    final profileData = Provider.of<UserProvider>(context).user;
    nameController.text = profileData.name ?? "";
    ageController.text =
        profileData.age != null ? profileData.age.toString() : "";
    addressController.text = profileData.address ?? "";
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
                  
                    backgroundImage: profileData.image == null
                        ? NetworkImage(imageUrl)
                        : null,
                    child: profileData.image != null
                        ? Image.memory(
                            base64Decode(profileData.image!),
                          )
                        : null,
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
                      try {
                        GeneralAlertDialog().customLoadingDialog(context);
                        final map =
                            Provider.of<UserProvider>(context, listen: false)
                                .updateUser(
                          name: nameController.text,
                          address: addressController.text,
                          age: int.parse(ageController.text),
                        );
                        final firestore = FirebaseFirestore.instance;
                        final data = await firestore
                            .collection(UserConstants.userCollection)
                            .where(UserConstants.userId,
                                isEqualTo: profileData.uuid)
                            .get();
                        if (data.docs.isEmpty) {
                          await firestore
                              .collection(UserConstants.userCollection)
                              .add(map);
                        } else {
                          data.docs.first.reference.update(map);
                        }

                        Navigator.pop(context);
                        Navigator.pop(context);
                        // print(map);
                      } catch (ex) {
                        print(ex.toString());
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text("Save"),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                ElevatedButton(
                  onPressed: () async{
                    await showBottomSheet(context);
                  },
                  child: const Text("Choose Image"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future <void> showBottomSheet(BuildContext context) async {
    final imagePicker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: basePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose a source",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: SizeConfig.height * 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildImageChooseOption(
                  context,
                  function: () async {
                    final xFile =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (xFile != null) {
                      final uint8List = await xFile.readAsBytes();
                      Provider.of<UserProvider>(context, listen: false)
                          .updateuserImage(base64UrlEncode(uint8List));
                    }
                  },
                  iconData: Icons.camera_outlined,
                  label: "Camera",
                ),
                buildImageChooseOption(
                  context,
                  function: () async{
                    final xFile =
                        await imagePicker.pickImage(source: ImageSource.gallery);
                    if (xFile != null) {
                      final uint8List = await xFile.readAsBytes();
                      Provider.of<UserProvider>(context, listen: false)
                          .updateuserImage(base64UrlEncode(uint8List));
                    }
                  },
                  iconData: Icons.collections_outlined,
                  label: "Gallery",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildImageChooseOption(
    BuildContext context, {
    required Function function,
    required IconData iconData,
    required String label,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            function();
          } ,
          color: Theme.of(context).primaryColor,
          iconSize: SizeConfig.height * 5,
          icon: Icon(
            iconData,
          ),
        ),
        Text(label),
      ],
    );
  }
}
