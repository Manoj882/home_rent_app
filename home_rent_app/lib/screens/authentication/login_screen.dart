import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/constants/general_divider.dart';
import 'package:home_rent_app/models/firebase_user.dart';
import 'package:home_rent_app/provider/user_provider.dart';
import 'package:home_rent_app/screens/authentication/singup_screen.dart';
import 'package:home_rent_app/screens/home_screen.dart';
import 'package:home_rent_app/utils/general_submit_button.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';
import 'package:provider/provider.dart';

import '../../widgets/general_alert_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildLogo(context),
                  buildSignUpForm(context),
                  SizedBox(
                    height: SizeConfig.height * 1.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.height * 6,
          ),
          child: Column(
            children: [
              Image.asset(
                ImageConstants.logo,
                height: SizeConfig.height * 12,
                width: SizeConfig.width * 25,
              ),
              SizedBox(
                height: SizeConfig.height * 2.5,
              ),
              Text(
                "Welcome Users",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: SizeConfig.height * 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSignUpForm(context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: basePadding,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Email Address",
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  validate: (value) => ValidationMixin().validateEmail(value!),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Password",
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: passwordController,
                  isObscure: true,
                  validate: (value) =>
                      ValidationMixin().validatePassword(value!),
                  onFieldSubmitted: (_) => _submit(context),
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralSubmitButton(
                  title: "Login",
                  onPressed: () {
                    _submit(context);
                  },
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                const GeneralDivider("Or"),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(context) async {
    try {
      if (formKey.currentState!.validate()) {
        GeneralAlertDialog().customLoadingDialog(context);
        final emailAddress = emailController.text;
        final password = passwordController.text;
        final firebaseAuth = FirebaseAuth.instance;
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        final user = userCredential.user;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final data = await firestore
              .collection(UserConstants.userCollection)
              .where(UserConstants.userId, isEqualTo: user.uid)
              .get();
              var map ={};
          if (data.docs.isEmpty) {
            map =
              FirebaseUser(
                displayName: user.displayName,
                email: user.email,
                photoUrl: user.photoURL,
                uuid: user.uid,
              ).toJson();
            
          } else {
            map = data.docs.first.data();    
          }
          Provider.of<UserProvider>(context, listen: false).setUser(map);
        }

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      var message = "";
      if (ex.code == "invalid-email") {
        message = "The email address is not valid.";
      }
      if (ex.code == "user-not-found") {
        message = "User doesnot exist";
      }
      if (ex.code == "wrong-password") {
        message = "The password is incorrect";
      }
      await GeneralAlertDialog().customAlertDialog(context, message);
    } catch (ex) {
      Navigator.pop(context);

      await GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
