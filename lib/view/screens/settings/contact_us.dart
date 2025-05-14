import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/app_info.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: StringStyle.appBarText(context: context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Get in Touch',
              style: StringStyle.normalTextBold(
                size: 20,
                color: ColorConstants.secondaryColor,
                isCallistga: true,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            contactTile(
              context,
              icon: Icons.email,
              title: 'Email',
              subtitle: AppInfo.appSupportEmail,
              onTap: () {
                EasyLauncher.email(email: AppInfo.appSupportEmail);
              },
            ),
            const SizedBox(height: 16),
            contactTile(
              context,
              icon: Icons.phone,
              title: 'Phone',
              subtitle: AppInfo.appSupportPhoneNumber,
              onTap: () {
                EasyLauncher.call(number: AppInfo.appSupportPhoneNumber);
              },
            ),
            const SizedBox(height: 16),
            contactTile(
              context,
              icon: Icons.location_on,
              title: 'Address',
              subtitle: AppInfo.appSupportAddress,
              onTap: () {
                // EasyLauncher.openMap(

                //   address: AppInfo.appSupportAddress,
                //   title: 'Stuedic HQ',
                // );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Feel free to reach out to us with any questions, feedback, or partnership opportunities!',
              style: StringStyle.normalText(size: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget contactTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ColorConstants.secondaryColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: StringStyle.normalTextBold(size: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: StringStyle.normalText()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
