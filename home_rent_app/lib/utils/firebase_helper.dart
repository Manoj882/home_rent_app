
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/general_alert_dialog.dart';

class FirebaseHelper{
addOrUpdateContent(BuildContext context,{
  required String collectionId, 
  required String whereId,
  required String whereValue,
  required Map<String, dynamic> map,
}) async{
  try {
      GeneralAlertDialog().customLoadingDialog(context);
      
      final firestore = FirebaseFirestore.instance;
      final data = await firestore
          .collection(collectionId)
          .where(whereId,
              isEqualTo: whereValue)
          .get();
      if (data.docs.isEmpty) {
        await firestore
            .collection(collectionId)
            .add(map);
      } else {
        data.docs.first.reference.update(map);
      }

      Navigator.pop(context);
      Navigator.pop(context);
      // print(map);
    } catch (ex) {
      
      Navigator.pop(context);
      throw ex.toString();
    }

}
}