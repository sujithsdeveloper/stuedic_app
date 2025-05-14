import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/app_info.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = AppUtils.isDarkTheme(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('About ${AppInfo.appName}',
            style: StringStyle.appBarText(context: context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Empowering Connections Between Campuses and Students',
              style: StringStyle.normalTextBold(
                  size: 20,
                  color: ColorConstants.secondaryColor,
                  isCallistga: true),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text('Introduction to ${AppInfo.appName}',
                style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              AppInfo.appDescription,
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text('For Colleges & Universities',
                style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              '- Create a digital profile to showcase programs, faculty, and achievements.\n'
              '- Build connections with other institutions for academic and extracurricular collaborations.\n'
              '- Post research papers, internships, and job opportunities.\n'
              '- Manage and promote academic and cultural events.',
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text('For Students', style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              '- Explore various colleges and their programs before applying.\n'
              '- Build an interactive student profile with achievements, skills, and CVs.\n'
              '- Participate in academic events, competitions, and networking opportunities.\n'
              '- Earn Achievement Points for academic and extracurricular contributions.',
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text('For Recruiters & Sponsors',
                style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              '- Connect with top students and colleges.\n'
              '- Post job and internship opportunities for students.\n'
              '- Sponsor academic events and gain visibility in the educational sector.',
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text('Why Choose ${AppInfo.appName}?',
                style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              '- Professional Networking: Connect students, faculty, and recruiters seamlessly.\n'
              '- Increased Visibility: Smaller institutions gain exposure to a wider audience.\n'
              '- Effortless Collaboration: Research, job placements, and academic projects made simple.\n'
              '- User-Friendly Design: Accessible on web & mobile (iOS & Android).\n'
              '- Real-Time Communication: Chat, video call, and share updates instantly.',
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text('Monetization & Revenue Model',
                style: StringStyle.normalTextBold(size: 18)),
            const SizedBox(height: 8),
            Text(
              '• College Registration Fee: ${AppInfo.collegeRegistrationFee} per institution (One-time or annual)\n'
              '• Premium Features: Enhanced analytics, priority listing, and additional exposure\n'
              '• Sponsored Advertisements: Colleges and companies can promote events or services\n'
              '• Event Hosting Fees: Paid listings for seminars, workshops, and webinars',
              style: StringStyle.normalText(),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Us: ${AppInfo.appSupportEmail}',
              style: StringStyle.normalTextBold(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
