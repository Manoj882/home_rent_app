import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/constants/general_divider.dart';
import 'package:home_rent_app/screens/authentication/login_screen.dart';
import 'package:home_rent_app/utils/general_submit_button.dart';
import 'package:home_rent_app/utils/size_config.dart';
import 'package:home_rent_app/utils/validation_mixin.dart';
import 'package:home_rent_app/widgets/general_alert_dialog.dart';
import 'package:home_rent_app/widgets/general_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
                        "Already have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
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
                  "Sign up",
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
                  onFieldSubmitted: (_){},
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Password",
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  isObscure: true,
                  controller: passwordController,
                  validate: (value) =>
                      ValidationMixin().validatePassword(value!),
                  onFieldSubmitted: (_){},
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralTextField(
                  title: "Confirm Password",
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: confirmPasswordController,
                  isObscure: true,
                  validate: (value) => ValidationMixin().validatePassword(
                    passwordController.text,
                    isConfirmed: true,
                    confirmedValue: value!,
                  ),
                  onFieldSubmitted: (_) => submit(context),
                ),
                SizedBox(
                  height: SizeConfig.height * 1.5,
                ),
                GeneralSubmitButton(
                  title: "Sign Up",
                  onPressed: () async {
                    await submit(context);
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

  submit(context) async{
    try {
      if (formKey.currentState!.validate()) {
        GeneralAlertDialog().customLoadingDialog(context);
        final emailAddress = emailController.text;
        final password = passwordController.text;
        final firebaseAuth = FirebaseAuth.instance;
        await firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } 
    on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      var message = "";
      if(ex.code == "invalid-email"){
        message = "The email address is not valid.";
      }
      if(ex.code == "email-already-in-use"){
        message = "The email address is already taken.";
      }
      if(ex.code == "weak-password"){
        message = "Your password is too weak. Try adding alphanumeric characters.";
      }
      await GeneralAlertDialog().customAlertDialog(context, message);
    }
    catch (ex) {
      Navigator.pop(context);
      
      await GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
