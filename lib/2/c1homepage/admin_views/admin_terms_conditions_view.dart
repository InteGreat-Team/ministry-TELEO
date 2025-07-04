import 'package:flutter/material.dart';
import '../admin_types.dart';

class AdminTermsConditionsView extends StatelessWidget {
  final void Function(AdminView) onNavigate;
  const AdminTermsConditionsView({Key? key, required this.onNavigate})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unified Terms and Acknowledgment Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.95), // Blue hue
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.blue[100]!, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Effective Date: June 23, 2025',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Welcome to Teleo, a mobile application developed and operated by minIStry ("we," "our," or "us"). These Terms and Conditions ("Terms") govern your access to and use of the Teleo mobile application ("App") and all associated services provided through the platform.\n\nBy accessing or using Teleo, you agree to be bound by these Terms. If you do not agree, please do not use the App.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  // Acknowledgment Section (now inside main card)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'By using our services, you acknowledge that you have read, understood, and agreed to these terms and conditions.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Terms List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      _buildSectionItem(
                        number: '1',
                        title: 'Eligibility',
                        content:
                            'You must be at least 13 years old to use this App. If you are under 18, you must have parental or guardian consent to use the App and agree to these Terms on your behalf.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '2',
                        title: 'User Accounts',
                        content:
                            'To access certain features, you may be required to register and create a user account. You agree to:\n\n• Provide accurate, current, and complete information.\n• Keep your account credentials secure and confidential.\n• Notify us immediately at ministry@gmail.com if you believe your account has been compromised.\n• Accept responsibility for all activities that occur under your account.\n\nWe reserve the right to suspend or terminate your account if any information is inaccurate or misleading.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '3',
                        title: 'Use of the App',
                        content:
                            'You agree to use Teleo lawfully and respectfully. You may not:\n\n• Violate any local, national, or international law or regulation.\n• Infringe upon the rights of others, including intellectual property rights.\n• Transmit harmful, offensive, or unlawful content.\n• Attempt to gain unauthorized access to the App\'s systems.\n• Use the App for spam, phishing, or malicious behavior.\n\nWe reserve the right to monitor and review your activity for compliance.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '4',
                        title: 'Content',
                        content:
                            'a. User Content\nUsers may submit content such as profile information, messages, and community contributions. By submitting such content, you grant minIStry a non-exclusive, royalty-free, worldwide license to use, host, store, reproduce, and display it within the context of providing App services. You are solely responsible for any content you provide.\n\nb. App Content\nAll original materials on the App, including logos, texts, graphics, and code, are the property of minIStry or its licensors and protected under intellectual property laws. You may not reuse or reproduce them without written permission.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '5',
                        title: 'Privacy Policy',
                        content:
                            'Use of Teleo is also governed by our Privacy Policy, which explains how we collect, use, and protect your data. Please read the full Privacy Policy at [Insert Link to Privacy Policy].',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '6',
                        title: 'Third-Party Services',
                        content:
                            'The App may integrate or link to third-party websites or services. These are provided for convenience only. minIStry does not control or endorse third-party content and is not responsible for their terms, practices, or data handling. Use of third-party services is at your own risk and subject to their policies.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '7',
                        title: 'Termination',
                        content:
                            'We reserve the right to:\n\n• Suspend or permanently disable access to your account.\n• Remove any content that violates these Terms.\n• Terminate access to the App for any reason without notice, especially if misuse or illegal activity is suspected.\n\nUpon termination, your license to use the App will cease immediately.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '8',
                        title: 'Disclaimers',
                        content:
                            'Teleo is provided "AS IS" and "AS AVAILABLE" without warranties of any kind. We do not guarantee:\n\n• Continuous, uninterrupted access.\n• That the App will be error-free, secure, or virus-free.\n• That any content will be reliable or accurate.\n\nTo the fullest extent permitted by law, we disclaim all express and implied warranties.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '9',
                        title: 'Limitation of Liability',
                        content:
                            'To the extent permitted by law, minIStry shall not be liable for any indirect, incidental, consequential, or punitive damages arising from:\n\n• Use or inability to use the App.\n• Unauthorized access or alterations to your data.\n• Conduct or content of any user or third party.\n\nOur total liability for all claims shall not exceed PHP 1,000.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '10',
                        title: 'Indemnification',
                        content:
                            'You agree to indemnify and hold harmless minIStry, its officers, affiliates, and employees from any claims, damages, obligations, losses, or expenses (including legal fees) arising from:\n\n• Your use or misuse of the App.\n• Your violation of these Terms.\n• Your infringement of any rights of another party.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '11',
                        title: 'Changes to These Terms',
                        content:
                            'We may update these Terms at any time. When we do, we will revise the Effective Date and notify you through the App or via email. Continued use of the App after such changes implies acceptance of the updated Terms.',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '12',
                        title: 'Governing Law',
                        content:
                            'These Terms are governed by the laws of the Republic of the Philippines, without regard to conflict of law principles. Any disputes shall be resolved in the courts of [Insert City, e.g., Quezon City, Metro Manila].',
                      ),
                      _buildDivider(),
                      _buildSectionItem(
                        number: '13',
                        title: 'Contact Information',
                        content:
                            'If you have any questions or concerns regarding these Terms, please contact us at:\n\nminIStry\nEmail: ministry@gmail.com\nPhone: 09123456789\nOffice Address: [Insert full office or church address here]',
                        isLast: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionItem({
    required String number,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, isLast ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Divider(color: Colors.grey[200], thickness: 1, height: 1),
    );
  }
}
