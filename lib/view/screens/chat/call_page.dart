import 'package:stuedic_app/utils/constants/app_info.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage(
      {Key? key,
      required this.callID,
      required this.userId,
      required this.username,
      this.isvoice = false})
      : super(key: key);
  final String callID;
  final String userId;
  final String username;
  final bool isvoice;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoSDKInfo.zegoAppID,
      appSign: ZegoSDKInfo.zegoAppSign,
      userID: userId,
      userName: username,
      callID: callID,
      config: isvoice
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
