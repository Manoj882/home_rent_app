import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class GeneralTableRow{
  TableRow buildTableSpacer(BuildContext context) {
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
  TableRow buildTableDivider(BuildContext context) {
    return const TableRow(
      children: [
        Divider(
          thickness: 1,
        ),
        Divider(
          thickness: 1,
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