import 'package:flutter/material.dart';
import 'package:home_rent_app/provider/room_rent_provider.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_table_row.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

import '../../models/room_rent.dart';
import '../../utils/size_config.dart';

class RentHistoryScreen extends StatelessWidget {
  const RentHistoryScreen({required this.model, Key? key}) : super(key: key);

  final RoomRent model;

  @override
  Widget build(BuildContext context) {
    final tableRow = GeneralTableRow();
    return Scaffold(
      appBar: AppBar(
        title: Text(model.month),
      ),
      body: CurvedBodyWidget(
        widget: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 2,
            vertical: SizeConfig.height * 2,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 2,
                      vertical: SizeConfig.height,
                    ),
                    child: Table(
                      children: [
                        tableRow.buildTableRow(
                          context,
                          title: "Month",
                          isAmount: false,
                          month: model.month,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Unit used",
                          amount: model.electricityUnits,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Per Unit Price",
                          amount: model.electricityUnitPrice,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Electricity Total Price",
                          amount: model.electricityTotalPrice,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Water Fee",
                          amount: model.waterFee,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Internet Fee",
                          amount: model.internetFee,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Rent Amount",
                          amount: model.rentAmount,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Total Amount",
                          amount: model.totalAmount,
                        ),
                        tableRow.buildTableSpacer(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Paid Amount",
                          amount: model.paidAmount,
                        ),
                        tableRow.buildTableDivider(context),
                        tableRow.buildTableRow(
                          context,
                          title: "Remaining Amount",
                          amount: model.remainingAmount,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                PayRemainingAmountForm(
                  model: model,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayRemainingAmountForm extends StatelessWidget {
  PayRemainingAmountForm({required this.model, Key? key}) : super(key: key);

  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RoomRent model;

  @override
  Widget build(BuildContext context) {
    amountController.text = model.remainingAmount.toString();
    return Form(
      key: formKey,
      child: Column(
        children: [
          GeneralTextField(
            title: "Pay Remaining Amount",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: amountController,
            validate: (value) => ValidationMixin().validateNumber(
                value!, "remaining amount", model.remainingAmount),
            onFieldSubmitted: (_) {
              submit(context);
            },
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          ElevatedButton(
            onPressed: () {
              submit(context);
            },
            child: Text(
              "Pay",
            ),
          ),
        ],
      ),
    );
  }

  submit(BuildContext context) async {
    if(!formKey.currentState!.validate()){
      return;

    }
    try {
      GeneralAlertDialog().customLoadingDialog(context);
      final paidAmount = double.parse(amountController.text);
      await Provider.of<RoomRentProvider>(context, listen: false).updateRoomRent(
        context,
        docId: model.roomRentId!,
        paidAmount: paidAmount,
        remainingAmount: model.remainingAmount - paidAmount,
      );
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
