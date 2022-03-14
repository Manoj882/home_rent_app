import 'package:flutter/material.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';

import '../../models/room.dart';

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
              showForm ? Icons.remove_outlined : Icons.add_outlined,
            ),
          ),
        ],
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: showForm ? FormWidget() : const Histories(),
        ),
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  FormWidget({Key? key}) : super(key: key);

  final totalAmountController = TextEditingController();
  final paidAmountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Amount"),
          SizedBox(
            height: SizeConfig.height,
          ),
          GeneralTextField(
            title: "Total Amount",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: totalAmountController,
            validate: (value) => ValidationMixin().validateNumber(
              value!,
              "total amount",
              100000,
            ),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height * 2,
          ),
          const Text("Amount Paid"),
          SizedBox(
            height: SizeConfig.height,
          ),
          GeneralTextField(
            title: "Amount Paid",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: paidAmountController,
            validate: (value) => ValidationMixin().validateNumber(
              value!,
              "paid amount",
              double.parse(totalAmountController.text.trim().isNotEmpty
                  ? totalAmountController.text.trim()
                  : "0"),
            ),
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print("obj");
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
  const Histories({Key? key}) : super(key: key);

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
        buildTableCard(context),
      ],
    );
  }

  Widget buildTableCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 2,
          vertical: SizeConfig.height * 2,
        ),
        child: Table(
          children: [
            buildTableRow(
              context,
              title: "Month",
              isAmount: false,
              month: "Magh",
            ),
            buildTableSpacer(context),
            buildTableRow(
              context,
              title: "Total Amount",
              amount: 350,
            ),
            buildTableSpacer(context),
            buildTableRow(
              context,
              title: "Paid Amount",
              amount: 250,
            ),
            buildTableSpacer(context),
            buildTableRow(
              context,
              title: "Remaining Amount",
              amount: 50,
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildTableSpacer(BuildContext context){
    return TableRow(
      children: [
        SizedBox(
          height: SizeConfig.height,
        ),
        SizedBox(
          height: SizeConfig.height,
        ),
      ],
    );
  }

  TableRow buildTableRow(
    BuildContext context, {
    required String title,
    double? amount,
    String? month,
    bool isAmount = true,
  }) {
    return TableRow(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: SizeConfig.width * 3.5,
              ),
        ),
        Text(
          isAmount ? "Rs. $amount!" : month!,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: SizeConfig.width * 3.5,
              ),
        ),
      ],
    );
  }
}
