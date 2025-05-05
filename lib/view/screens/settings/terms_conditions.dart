import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms & Conditions",
          style: StringStyle.appBarText(context: context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Effective Date: 18/01/2025",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle("Welcome to STUEDIC!"),
            _buildContentText(
              "By accessing or using our platform, you agree to comply with these Terms & Conditions. If you do not agree, please refrain from using the app.",
            ),
            _buildSectionTitle("1. Eligibility"),
            _buildContentText(
              "STUEDIC is intended for college students aged 17 and above. By registering, you confirm that the information you provide is accurate and that you are eligible to use the platform.",
            ),
            _buildSectionTitle("2. Account Responsibilities"),
            _buildBulletPoint(
                "You are responsible for maintaining the confidentiality of your login credentials."),
            _buildBulletPoint(
                "Any activity conducted through your account is your responsibility. Notify us immediately of unauthorized access or breaches."),
            _buildSectionTitle("3. Acceptable Use"),
            _buildBulletPoint(
                "Use the platform for lawful purposes, including networking, academic collaboration, and personal expression."),
            _buildBulletPoint(
                "Refrain from sharing content that is abusive, hateful, explicit, defamatory, or violates intellectual property rights."),
            _buildBulletPoint(
                "Avoid spamming, phishing, or engaging in any fraudulent activities."),
            _buildSectionTitle("4. Intellectual Property"),
            _buildContentText(
              "All content and features on STUEDIC, including text, graphics, logos, and software, are owned by us or licensed to us. You may not reproduce, distribute, or exploit this content without prior permission.",
            ),
            _buildSectionTitle("5. User-Generated Content"),
            _buildBulletPoint(
                "By posting content on STUEDIC, you grant us a non-exclusive, royalty-free license to use, modify, and distribute your content for platform-related purposes."),
            _buildBulletPoint(
                "You retain ownership of your content but agree not to upload anything that infringes on third-party rights or violates laws."),
            _buildSectionTitle("6. Prohibited Activities"),
            _buildBulletPoint(
                "Use bots, scripts, or automated tools to scrape data or disrupt the platform."),
            _buildBulletPoint(
                "Misuse the app for unauthorized advertising or promotions."),
            _buildBulletPoint(
                "Engage in cyberbullying, harassment, or impersonation of others."),
            _buildSectionTitle("7. Limitation of Liability"),
            _buildContentText(
              "STUEDIC is provided “as is.” We do not guarantee uninterrupted service or the accuracy of content on the platform. To the fullest extent permitted by law, we are not liable for any damages, losses, or misuse resulting from your use of the app.",
            ),
            _buildSectionTitle("8. Termination"),
            _buildContentText(
              "We reserve the right to suspend or terminate your account if you breach these Terms & Conditions or engage in prohibited behavior.",
            ),
            _buildSectionTitle("9. Modifications to the Terms"),
            _buildContentText(
              "We may update these Terms & Conditions at any time. We will notify users of significant changes. Continued use of STUEDIC indicates your acceptance of the updated terms.",
            ),
            _buildSectionTitle("10. Governing Law"),
            _buildContentText(
              "These Terms & Conditions are governed by the laws of Kerala High Court, Eranakulam. Any disputes arising from the use of STUEDIC will be resolved exclusively in the courts of Kerala High Court, Eranakulam.",
            ),
            _buildSectionTitle("11. Contact Us"),
            _buildContentText(
              "For questions or concerns about these Terms & Conditions, contact us at: stuedic.varts@gmail.com",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
