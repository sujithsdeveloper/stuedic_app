import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/screens/setup_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

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
    // final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP',
          style: StringStyle.appBarText(),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.info))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  "Enter the 4-digit OTP code. We’ve just sent to",
                  style: StringStyle.normalText(),
                ),
                Text(
                  "+62 857 1700 5561", // Replace dynamically if needed
                  style: StringStyle.normalTextBold(),
                ),
                const SizedBox(height: 24),

                // OTP Input Field
                PinCodeTextField(
                  controller: _controller, // Assigned controller
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  autoFocus: false, // Prevents keyboard flickering
                  autoDismissKeyboard: true,
                  enableActiveFill: true,
                  validator: (value) => otpValidator(value),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(100),
                    fieldHeight: 48,
                    fieldWidth: 76,
                    activeFillColor: Colors.white,
                    inactiveFillColor: const Color(0xffF6F8F9),
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.grey.shade400,
                    selectedColor: ColorConstants.primaryColor2,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  appContext: context,
                  onChanged: (value) {
                    proRead.changeButtonColor(); // Updates button color
                  },
                  onCompleted: (value) {
                    proRead.changeButtonColor();
                  },
                ),
                const SizedBox(height: 16),

                // Resend OTP
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Add OTP resend logic
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive OTP?",
                          style: StringStyle.normalText(),
                        ),
                        Text(
                          " Resend",
                          style: StringStyle.normalTextBold(),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Continue Button
                GradientButton(
                    width: double.infinity,
                    label: 'Continue',
                    isColored: true,
                    onTap: () {
                      AppRoutes.push(context, const SetupScreen());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
