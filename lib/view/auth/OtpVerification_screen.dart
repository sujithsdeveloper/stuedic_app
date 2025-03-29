import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/OTP_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/auth/setup_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen(
      {super.key,
      required this.number,
      this.isMail = false,
      required this.email});
  final String number;
  final bool isMail;
  final String email;
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose(); // Properly disposing the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    return WillPopScope(
      onWillPop: () async {
        if (proWatch.singleFieldColored) {
          proWatch.singleFieldColored = false;
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'OTP',
            style: StringStyle.appBarText(context: context),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.info))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        "Enter Confirmation Code",
                        style: StringStyle.topHeading(size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Enter the 6-digit OTP code. We’ve just sent to",
                        style: StringStyle.normalText(),
                      ),
                      Text(
                        widget.isMail ? widget.email : widget.number,
                        style: StringStyle.normalTextBold(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // OTP Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: PinCodeTextField(
                    controller: _controller, // Assigned controller
                    length: 6,
                    obscureText: false,

                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    autoFocus: true, // Prevents keyboard flickering
                    autoDismissKeyboard: true,
                    enableActiveFill: true,
                    validator: (value) => otpValidator(value),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(100),
                      fieldHeight: 38,
                      fieldWidth: 50,
                      activeFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      selectedFillColor: Colors.transparent,
                      inactiveColor: Colors.white,
                      selectedColor: ColorConstants.primaryColor2,
                    ),
                    animationDuration: const Duration(milliseconds: 200),
                    appContext: context,
                    onChanged: (value) {
                      proRead.changeSingleFeildButtonColor(value: value);
                      if (_controller.text.length > 5) {
                        context.read<OtpController>().checkOtp(
                            context: context,
                            email: widget.email,
                            otp: _controller.text);
                      }
                    },
                    // onCompleted: (value) {
                    //   proRead.changeSingleFeildButtonColor(value: value);
                    // },
                  ),
                ),
                const SizedBox(height: 16),

                // Resend OTP
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn’t receive OTP?",
                        style: StringStyle.normalText(),
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          context
                              .read<OtpController>()
                              .getOTP(email: widget.email, context: context);
                        },
                        child: Text(
                          " Resend",
                          style: StringStyle.normalTextBold(),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Continue Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GradientButton(
                      width: double.infinity,
                      label: 'Continue',
                      isColored: proWatch.singleFieldColored,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (_controller.text.length > 5) {
                            context.read<OtpController>().checkOtp(
                                context: context,
                                email: widget.email,
                                otp: _controller.text);
                          }
                        }
                        AppRoutes.push(context, const SetupScreen());
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
