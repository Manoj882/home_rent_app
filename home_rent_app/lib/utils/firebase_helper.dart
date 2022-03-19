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

  Future<QuerySnapshot<Map<String, dynamic>>> getData({
    required String collectionId,
    required String whereId,
    required String whereValue,
    // required String docId,
  }) async {
    final firestore = FirebaseFirestore.instance;
    // firestore.collection(collectionId).doc(docId).update(data);
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
      final data =
          await FirebaseFirestore.instance.collection(collectionId).add(map);
    } catch (ex) {
      print(ex.toString());
    }
  }

  updateData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
    required String docId,
  }) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(docId)
          .update(map);
    } catch (ex) {
      print(ex.toString());
    }
  }
}
