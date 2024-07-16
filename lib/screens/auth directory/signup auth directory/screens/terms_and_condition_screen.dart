import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                NavigationHelper.navigateBack(
                  context,
                );
              },
              child: Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.transparent,
                    border:
                        Border.all(color: AppColor.primaryColor, width: 1.5.w)),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Terms and Conditions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: AppStrings.rubik,
                  fontWeight: FontWeight.w400,
                  color: AppColor.secondTextColor),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monity',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
             Text(
              '''Introduction
Welcome to Monity! These terms and conditions outline the rules and regulations for the use of Monity's mobile application. By accessing this app, we assume you accept these terms and conditions. Do not continue to use Monity if you do not agree to all of the terms and conditions stated on this page.

Definitions
"App" refers to Monity's mobile application.
"User" refers to anyone who uses the App.
"We," "Our," and "Us" refer to Monity.

User Accounts
1. Registration: Users must register and create an account to use certain features of the App. Users agree to provide accurate, current, and complete information during the registration process.
2. Account Security: Users are responsible for maintaining the confidentiality of their account credentials and for all activities that occur under their account. Users agree to notify us immediately of any unauthorized use of their account.
3. Termination: We reserve the right to terminate or suspend user accounts at our sole discretion, without prior notice, for conduct that we believe violates these terms and conditions or is harmful to other users of the App.

Services
1. Overview: Monity provides users with various banking services, including but not limited to money transfers, savings goals, and expense tracking.
2. Availability: We strive to ensure that the App is available at all times, but we do not guarantee uninterrupted access and we reserve the right to suspend or restrict access to the App for maintenance or other reasons.
3. Fees: Some services provided by Monity may require payment of fees. Users will be informed of any applicable fees before they incur them.

User Obligations
1. Lawful Use: Users agree to use the App in compliance with all applicable laws and regulations.
2. Prohibited Activities: Users must not use the App for any unlawful or fraudulent activities. Users must not attempt to gain unauthorized access to the App, our servers, or any data contained within.

Limitation of Liability
To the maximum extent permitted by law, Monity shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from (i) your use of or inability to use the App; (ii) any unauthorized access to or use of our servers and/or any personal information stored therein.

Changes to Terms
We may revise these terms and conditions from time to time. The most current version will always be available on the App. By continuing to access or use the App after revisions become effective, you agree to be bound by the revised terms.

Governing Law
These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction in which Monity operates, without regard to its conflict of law principles.

Monity Privacy Policy

Introduction
Monity respects your privacy and is committed to protecting your personal information. This privacy policy explains how we collect, use, and share information about you when you use our mobile application.

Information We Collect
1. Personal Information: When you create an account with Monity, we collect personal information such as your name, email address, phone number, and financial information.
2. Usage Data: We collect information about how you use the App, such as the features you use and the time and duration of your activities.
3. Device Information: We collect information about the device you use to access the App, including the hardware model, operating system, and device identifiers.

How We Use Your Information
1. To Provide Services: We use your personal information to provide and improve our services, process transactions, and communicate with you.
2. To Personalize Your Experience: We use information about your usage of the App to personalize your experience and provide content and features that are relevant to you.
3. To Improve the App: We use the information we collect to understand how users interact with the App and to develop and improve our services.

Sharing Your Information
1. With Service Providers: We may share your information with third-party service providers who perform services on our behalf, such as payment processing and data analysis.
2. For Legal Reasons: We may disclose your information if required to do so by law or in response to a valid request by a law enforcement or governmental authority.
3. With Your Consent: We may share your information with third parties when we have your consent to do so.

Data Security
We take reasonable measures to protect the information we collect from unauthorized access, use, or disclosure. However, no method of transmission over the Internet or method of electronic storage is completely secure, and we cannot guarantee its absolute security.

Your Choices
1. Account Information: You may update or correct your account information at any time by accessing your account settings within the App.
2. Communication Preferences: You may opt-out of receiving promotional communications from us by following the instructions in those communications or by updating your preferences in the App.

Changes to This Privacy Policy
We may update this privacy policy from time to time. If we make any changes, we will notify you by revising the date at the top of the policy and, in some cases, we may provide additional notice (such as adding a statement to our homepage or sending you a notification).

Contact Us
If you have any questions or concerns about this privacy policy or our data practices, please contact us at support@monity.com.

By using Monity, you agree to these terms and conditions and our privacy policy. Thank you for choosing Monity!''',
              style: TextStyle(
                  fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                fontFamily: AppStrings.rubik
              ),
            ),
          ],
        ),
      ),
    );
  }
}
