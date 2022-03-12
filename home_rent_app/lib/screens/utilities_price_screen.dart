import 'package:flutter/material.dart';
import '/provider/user_provider.dart';
import '/utils/firebase_helper.dart';
import '/utils/size_config.dart';
import '/utils/validation_mixin.dart';
import '/widgets/curved_body_widget.dart';
import '/widgets/general_text_field.dart';
import 'package:provider/provider.dart';
import '/constants/constants.dart';
import '/widgets/general_alert_dialog.dart';

class UtilitiesPriceScreen extends StatelessWidget {
  UtilitiesPriceScreen({Key? key}) : super(key: key);

  final electricityUnitController = TextEditingController();
  final waterFeeController = TextEditingController();
  final internetFeeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilities Price"),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set your utilities price",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Electricity Unit",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: electricityUnitController,
                  validate: (value) => ValidationMixin().validateNumber(
                    value!,
                    "Electricity unit price",
                    100,
                  ),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Water Fee",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: waterFeeController,
                  validate: (value) => ValidationMixin().validateNumber(
                    value!,
                    "water fee",
                    10000,
                  ),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Internet Fee",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: internetFeeController,
                  validate: (value) => ValidationMixin().validateNumber(
                    value!,
                    "internet fee",
                    10000,
                  ),
                  onFieldSubmitted: (_) {
                    submit(context);
                  },
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      submit(context);
                    },
                    child: const Text(
                      "Submit",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final uid = Provider.of<UserProvider>(context, listen: false).user.uuid;
        final map = {
          "electricity": electricityUnitController.text,
          "water": waterFeeController.text,
          "internet": internetFeeController.text,
          "uuid": Provider.of<UserProvider>(context, listen: false).user.uuid,
        };
        await FirebaseHelper().addOrUpdateContent(
          context,
          collectionId: UtilitiesPriceConstant.utilityPriceCollection,
          whereId: UserConstants.userId,
          whereValue: uid,
          map: map,
        );
      } catch (ex) {
        GeneralAlertDialog().customAlertDialog(context, ex.toString());
      }
    }
  }
}
