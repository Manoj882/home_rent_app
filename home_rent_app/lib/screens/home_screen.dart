import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/screens/profile/user_profile_screen.dart';
import 'package:home_rent_app/utils/navigate.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/widgets/curved_body_widget.dart';

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
            UserAccountsDrawerHeader(
              accountName: const Text("Manoj BK"),
              accountEmail: const Text("manojbk488@gmail.com"),
              currentAccountPicture: Hero(
                tag: "image-url",
                child: CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
              ),
            ),
            ListTile(
              title: const Text("Profile"),
              trailing: const Icon(
                Icons.arrow_right_outlined,
              ),
              onTap: () => Navigate(
                context,
                UserProfileScreen(
                  imageUrl: image,
                ),
              ),
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
}
