import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_rent_app/models/room.dart';
import 'package:home_rent_app/provider/room_provider.dart';
import 'package:home_rent_app/screens/room/room_screen.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_bottom_sheet.dart';
import '/provider/user_provider.dart';
import '/screens/profile/user_profile_screen.dart';
import '/screens/utilities_price_screen.dart';
import '/utils/navigate.dart';
import '/utils/size_config.dart';
import '/widgets/curved_body_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final image =
      "https://i.pinimg.com/200x/c2/c0/d6/c2c0d6eb1c80d8ad3b81ac1650df059d.jpg";

  @override
  Widget build(BuildContext context) {
    final future =
        Provider.of<RoomProvider>(context, listen: false).fetchRoom(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final roomName =
                  await GeneralButtomSheet().customBottomSheet(context);

              if (roomName != null) {
                try {
                  GeneralAlertDialog().customLoadingDialog(context);
                  await Provider.of<RoomProvider>(context, listen: false)
                      .addRoom(
                    context,
                    roomName,
                  );
                  Navigator.pop(context);
                } catch (ex) {
                  Navigator.pop(context);
                  GeneralAlertDialog()
                      .customAlertDialog(context, ex.toString());
                }
              }
            },
            icon: const Icon(
              Icons.add_outlined,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Consumer<UserProvider>(builder: (_, data, __) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  data.user.name ?? "No Name",
                ),
                accountEmail: Text(
                  data.user.email ?? "No Email",
                ),
                currentAccountPicture: Hero(
                    tag: "image-url",
                    child: SizedBox(
                      height: SizeConfig.height * 16,
                      width: SizeConfig.height * 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.height * 8,
                        ),
                        child: data.user.image == null
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                base64Decode(
                                  data.user.image!,
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                    )),
              );
            }),
            buildListTile(
              context,
              label: "Profile",
              widget: UserProfileScreen(imageUrl: image),
            ),
            buildListTile(
              context,
              label: "Utilities Price",
              widget: UtilitiesPriceScreen(),
            ),
          ],
        ),
      ),
      body: CurvedBodyWidget(
        widget: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final listOfRoom = Provider.of<RoomProvider>(context).listOfRoom;

              return listOfRoom.isEmpty
                  ? Center(child: Text("You don't have any rooms."))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Rooms",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: SizeConfig.height,
                          ),
                          GridView.builder(
                            itemCount: listOfRoom.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2,
                              mainAxisSpacing: SizeConfig.height,
                              crossAxisSpacing: SizeConfig.width,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigate(
                                  context,
                                  RoomScreen(
                                    room: listOfRoom[index],
                                  ),
                                ),
                                child: Card(
                                  color: Colors.red.shade200,
                                  child: Center(
                                    child: Text(listOfRoom[index].name),
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  Widget buildListTile(BuildContext context,
      {required String label, required Widget widget}) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(
        Icons.arrow_right_outlined,
      ),
      onTap: () => Navigate(
        context,
        widget,
      ),
    );
  }
}
