import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    final proReadAuth = context.read<AuthController>();
    final proWatchAuth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: StringStyle.appBarText(context: context),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.info))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: StringStyle.topHeading(),
                ),
                SizedBox(height: 24),

                // TabBar for switching
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
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
                      onTap: (value) {
                        if (value == 1) {

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  _tabController.animateTo(0);
                                  return true;
                                },
                                child: CupertinoAlertDialog(
                                  title: Text('Warning'),
                                  content: Text(
                                      'Phone number login is not available for beta users.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () {
                                        _tabController.animateTo(
                                            _tabController.previousIndex);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
>>>>>>> stuedic_dev
                        }
                      },
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

                // TabBarView for Email & Phone Number Login
                SizedBox(
                  height: 180,
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        spacing: 24,
                        children: [
                          TextfieldWidget(
                            onChanged: (p0) {
                              prowatch.email = p0!;
                              proRead.changeButtonColor();
                            },
                            validator: (p0) => emailValidator(p0),
                            hint: 'Email',
                            controller: emailController,
                          ),
                          TextfieldWidget(
                            onChanged: (p0) {
                              prowatch.password = p0!;
                              proRead.changeButtonColor();
                            },
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Password is required";
                              }
                            },
                            controller: passwordController,
                            hint: "Password",
                            isPassword: true,
                          ),
                        ],
                      ),
                      TextfieldWidget(
                        onChanged: (p0) {
                          prowatch.phoneNumber = p0!;
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

                SizedBox(height: 10),
                Row(
                  children: [
                    CupertinoCheckbox(
                      value: prowatch.checkBoxCheked,
                      onChanged: (value) {
                        proRead.toggleCheckBox(value: value!);
                      },
                    ),
                    Text(
                      "Remember me",
                      style: StringStyle.normalText(),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.push(context, ForgotPassword());
                      },
                      child: Text("Forgot Password?",
                          style: StringStyle.normalTextBold()),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                proWatchAuth.isLoginLoading
                    ? loadingIndicator()
                    : GradientButton(
                        onTap: () {
                          if (key.currentState!.validate()) {
                            // log('Logined');
                            proReadAuth.login(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context);
                          }
                        },
                        width: double.infinity,
                        label: 'Login',
                      ),
                SizedBox(height: 24),

                AgreementText(),
                SizedBox(height: 13),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?", style: StringStyle.normalText()),
            GestureDetector(
              onTap: () {
                AppRoutes.pushReplacement(context, RegistrationScreen());
                proRead.clearState();
              },
              child:
                  Text(" Create account", style: StringStyle.normalTextBold()),
            ),
          ],
        ),
      ),
    );
  }
}
