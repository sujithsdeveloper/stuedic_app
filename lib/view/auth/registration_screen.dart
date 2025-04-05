import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/OTP_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/elements/social_media_container.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/auth/OtpVerification_screen.dart';
import 'package:stuedic_app/view/auth/login_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: StringStyle.appBarText(context: context),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.info))
        ],
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Your Account",
                  style: StringStyle.topHeading(size: 32),
                ),
                SizedBox(height: 24),

                // Animated Container Toggle
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TabBar(
                      isScrollable: false,
                      labelStyle: StringStyle.normalText(),
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      splashFactory: NoSplash.splashFactory,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(
                          color: ColorConstants.secondaryColor,
                          borderRadius: BorderRadius.circular(100)),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: "Email",
                        ),
                        Tab(
                          text: "PhoneNumebr",
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Animated Email / Phone Number Input
                SizedBox(
                  height: 240,
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        spacing: 5,
                        children: [
                          TextfieldWidget(
                            helperText: '',
                            onChanged: (p0) {
                              proRead.email = p0!;
                              proRead.changeButtonColor();
                            },
                            validator: (p0) => emailValidator(p0),
                            hint: 'Email',
                            controller: emailController,
                          ),
                          TextfieldWidget(
                            helperText: '',
                            onChanged: (p0) {
                              proRead.password = p0!;
                              proRead.changeButtonColor();
                            },
                            validator: (p0) => passwordValidator(p0),
                            controller: passwordController,
                            hint: "Password",
                            isPassword: true,
                          ),
                          TextfieldWidget(
                            helperText: '',
                            onChanged: (p0) {
                              proRead.confrimPassword = p0!;
                              proRead.changeButtonColor();
                            },
                            validator: (p0) => confirmPasswordValidator(
                                p0, passwordController.text),
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            isPassword: true,
                          ),
                        ],
                      ),
                      TextfieldWidget(
                        onChanged: (p0) {
                          proRead.phoneNumber = p0!;
                          proRead.changeButtonColor();
                        },
                        validator: (p0) => phoneNumberValidator(p0),
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        hint: "Phone Number",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                GradientButton(
                    onTap: () async {
                      if (key.currentState!.validate()) {
                        context.read<OtpController>().getOTP(
                            email: emailController.text, context: context);
                        await AppUtils.saveCredentials(
                            email: emailController.text,
                            password: confirmPasswordController.text);
                        AppRoutes.push(
                            context,
                            OtpVerificationScreen(
                              number: phoneNumberController.text,
                              email: emailController.text,
                              isMail: phoneNumberController.text.isEmpty,
                            ));
                      }
                      // AppRoutes.push(
                      //     context,
                      //     OtpVerificationScreen(
                      //       number: phoneNumberController.text,
                      //       email: emailController.text,
                      //       isMail: phoneNumberController.text.isEmpty,
                      //     ));
                    },
                    width: double.infinity,
                    label: 'Create Account'),

                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: "By continuing, you agree to Stuedic's",
                        style: StringStyle.normalText(),
                        children: [
                          TextSpan(
                              text: 'Terms of Service and Privacy Policy',
                              style: StringStyle.normalTextBold())
                        ]),
                  ),
                ),
                SizedBox(height: 13),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                spacing: 5,
                children: [
                  Text(
                    "Already have an account?",
                    style: StringStyle.normalText(),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppRoutes.pushReplacement(context, LoginScreen());
                      proRead.clearState();
                    },
                    child: Text(
                      "Login",
                      style: StringStyle.normalTextBold(),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
