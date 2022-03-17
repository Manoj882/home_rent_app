import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/general_alert_dialog.dart';

class FirebaseHelper {
  addOrUpdateContent(
    BuildContext context, {
    required String collectionId,
    required String whereId,
    required String whereValue,
    required Map<String, dynamic> map,
  }) async {
    try {
      GeneralAlertDialog().customLoadingDialog(context);

      final data = await getData(
        context,
        collectionId: collectionId,
        whereId: whereId,
        whereValue: whereValue,
      );
      if (data.docs.isEmpty) {
        await FirebaseFirestore.instance.collection(collectionId).add(map);
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

  Future<QuerySnapshot<Map<String, dynamic>>> getData(
    BuildContext context, {
    required String collectionId,
    required String whereId,
    required String whereValue,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final data = await firestore
        .collection(collectionId)
        .where(whereId, isEqualTo: whereValue)
        .get();

    return data;
  }

  addData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
  }) async {
    try {
     
      final data = await FirebaseFirestore.instance.collection(collectionId).add(map);
    } catch (ex) {
      print(ex.toString());
    }
  }
}
