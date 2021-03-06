import 'package:flutter/material.dart';
import 'package:home_rent_app/provider/room_rent_provider.dart';
import 'package:home_rent_app/provider/utilities_price_provider.dart';
import 'package:home_rent_app/screens/room/rent_history_screen.dart';
import 'package:home_rent_app/utils/navigate.dart';
import 'package:home_rent_app/utils/show_toast_message.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_drop_down.dart';
import 'package:home_rent_app/widgets/general_table_row.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

import '../../models/room.dart';
import '../../models/room_rent.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({required this.room, Key? key}) : super(key: key);

  final Room room;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool showForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          IconButton(
            onPressed: () => setState(() => showForm = !showForm),
            icon: Icon(
              showForm ? Icons.receipt_long_outlined : Icons.add_outlined,
            ),
          ),
        ],
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: showForm
              ? FormWidget(
                  roomId: widget.room.id!,
                )
              : Histories(
                  roomId: widget.room.id!,
                ),
        ),
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  FormWidget({required this.roomId, Key? key}) : super(key: key);

  final String roomId;

  final rentAmountController = TextEditingController();
  final electricityUnitsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final monthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Month"),
          GeneralDropDown(monthController),
          // if(electricityUnitsController.text.isEmpty)
          // Text(
          //   "Please select a month",
          //   style: TextStyle(color: Theme.of(context).errorColor),
          // ),
          SizedBox(
            height: SizeConfig.height * 1.5,
          ),
          const Text("Rent Amount"),
          SizedBox(
            height: SizeConfig.height,
          ),
          GeneralTextField(
            title: "Rent Amount",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: rentAmountController,
            validate: (value) => ValidationMixin().validateNumber(
              value!,
              "rent amount",
              100000,
            ),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height * 2,
          ),
          const Text("Units of electricity used"),
          SizedBox(
            height: SizeConfig.height,
          ),
          GeneralTextField(
            title: "Units of electricity used",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: electricityUnitsController,
            validate: (value) => ValidationMixin().validateNumber(
              value!,
              "units of electricity used",
              100,
            ),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // print(monthController.text);
                  // print(electricityUnitsController.text);
                  // print(rentAmountController.text);
                  if (monthController.text.isEmpty) {
                    showToast("Please select a month");
                    return;
                  }
                  try {
                    GeneralAlertDialog().customLoadingDialog(context);
                    Provider.of<RoomRentProvider>(context, listen: false)
                        .addRoomRent(
                      context,
                      roomId: roomId,
                      electricityUnitText: electricityUnitsController.text,
                      rentAmountText: rentAmountController.text,
                      month: monthController.text,
                    );

                    Navigator.pop(context);
                  } catch (ex) {
                    print(ex.toString());
                    Navigator.pop(context);
                    GeneralAlertDialog()
                        .customAlertDialog(context, ex.toString());
                  }
                }
              },
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

class Histories extends StatelessWidget {
  const Histories({required this.roomId, Key? key}) : super(key: key);

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Histories",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: SizeConfig.height,
        ),
        FutureBuilder(
            future: Provider.of<RoomRentProvider>(context, listen: false)
                .fetchRoomRent(roomId: roomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final roomrentList =
                  Provider.of<RoomRentProvider>(context).roomRentList;
              return ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: roomrentList.length,
                itemBuilder: (context, index) {
                  return buildTableCard(context, roomrentList[index]);
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: SizeConfig.height,
                ),
              );
            }),
      ],
    );
  }

  Widget buildTableCard(BuildContext context, RoomRent model) {
    final tableRow = GeneralTableRow();
    return InkWell(
      onTap: () => Navigate(
        context,
        RentHistoryScreen(model: model),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 2,
            vertical: SizeConfig.height * 2,
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
                title: "Total Amount",
                amount: model.totalAmount,
              ),
              tableRow.buildTableSpacer(context),
              tableRow.buildTableRow(
                context,
                title: "Paid Amount",
                amount: model.paidAmount,
              ),
              tableRow.buildTableSpacer(context),
              tableRow.buildTableRow(
                context,
                title: "Remaining Amount",
                amount: model.remainingAmount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
