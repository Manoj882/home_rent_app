import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/models/utilities_price.dart';
import 'package:home_rent_app/provider/user_provider.dart';
import 'package:home_rent_app/utils/firebase_helper.dart';
import 'package:provider/provider.dart';

class UtilitiesPriceProvider extends ChangeNotifier {
  UtilitiesPrice? _utilitiesPrice;

  UtilitiesPrice? get utilitiesPrice => _utilitiesPrice;

  Future fetchPrice(BuildContext context) async {
    try{
    final uuid =Provider.of<UserProvider>(context, listen: false).user.uuid;
    final data = await FirebaseHelper().getData(
    
      collectionId: UtilitiesPriceConstant.utilityPriceCollection,
      whereId: UserConstants.userId,
      whereValue: uuid,
    );


    if(data.docs.isNotEmpty){
      _utilitiesPrice = UtilitiesPrice.fromJson(data.docs.first.data());
    }
    } catch(ex){
      print(ex.toString());
    }
  }
}
