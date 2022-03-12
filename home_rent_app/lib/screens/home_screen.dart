import 'dart:convert';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home"),
        centerTitle: true,
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
              widget:  UtilitiesPriceScreen(),
            ),
          ],
        ),
      ),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                "Welcome to Rent App",
              ),
            ],
          ),
        ),
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
