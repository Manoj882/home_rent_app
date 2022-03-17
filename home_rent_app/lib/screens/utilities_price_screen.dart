import 'package:flutter/material.dart';
import 'package:home_rent_app/models/utilities_price.dart';
import 'package:home_rent_app/provider/utilities_price_provider.dart';
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
          child: FutureBuilder(
              future:
                  Provider.of<UtilitiesPriceProvider>(context, listen: false)
                      .fetchPrice(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final utilityPriceProvider =
                    Provider.of<UtilitiesPriceProvider>(context, listen: false)
                        .utilitiesPrice;
                if (utilityPriceProvider != null) {
                  electricityUnitController.text =
                      utilityPriceProvider.electriciyUnitPrice.toString();
                  waterFeeController.text =
                      utilityPriceProvider.waterFee.toString();
                  internetFeeController.text =
                      utilityPriceProvider.internetFee.toString();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set your utilities price",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: SizeConfig.height * 1.5,
                      ),
                      Text(
                        "Electricity Unit",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
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
                        height: SizeConfig.height * 1.5,
                      ),
                        Text(
                        "Water Fee",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
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
                        height: SizeConfig.height * 1.5,
                      ),
                        Text(
                        "Internet Fee",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: SizeConfig.height,
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
                );
              }),
        ),
      ),
    );
  }

  submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final uid = Provider.of<UserProvider>(context, listen: false).user.uuid;
        final map = UtilitiesPrice(
          waterFee: double.parse(waterFeeController.text),
          electriciyUnitPrice: double.parse(electricityUnitController.text),
          internetFee: double.parse(internetFeeController.text),
          uuid: uid,
        ).toJson();
        

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
