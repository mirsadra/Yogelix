//  PrivacyPolicyView.swift
import SwiftUI

struct PrivacyPolicyView: View {
    // Placeholder for privacy policy text
    // Replace with your actual privacy policy content
    private let privacyPolicyText: String = """
    Yogelix Privacy Policy

    Introduction:
    At Yogelix, your privacy is of utmost importance. This Privacy Policy outlines our practices related to the collection, use, and protection of personal information for users of the Yogelix app.

    Information Collection and Use:
    - Personal Information: We collect personal information such as name, email address, and age when you register for an account.
    - Health Data: With your consent, we access health data from Apple HealthKit, including height, weight, energy burn, heart rate, and yoga workouts.
    - Usage Data: Information on how you use the app is collected to enhance our services.

    Cookies and Tracking Technologies:
    - Yogelix may use cookies and similar tracking technologies to monitor app usage and store certain information.

    Data Security:
    - We implement various security measures to protect your personal information.

    Data Sharing and Disclosure:
    - Your personal information is not sold, traded, or otherwise transferred to outside parties, except as necessary to provide our service or when required by law.

    Your Rights:
    - You can access, update, or request deletion of your personal information.
    - You have the option to opt out of certain data collection practices.

    Children’s Privacy:
    - Our service is not intended for individuals under 13, and we do not knowingly collect information from children under 13.

    CCPA Compliance:
    - For California residents, the CCPA grants the right to request that we disclose the categories and specific pieces of personal information we collect. You also have the right to request the deletion of this information and to opt-out of the sale of personal information.
    - We do not sell personal information. However, we support your right to access and control your personal data in accordance with the CCPA.

    Changes to This Policy:
    - Our Privacy Policy may be updated periodically. We will notify you of any changes by posting the new policy on this page.

    Contact Us:
    - If you have questions about this Privacy Policy, please contact us at [Your Contact Information].

    Note: This document is a template and should be reviewed by a legal professional to ensure it aligns with your specific practices and complies with all applicable laws.

    """



    var body: some View {
        ScrollView {
            Text(privacyPolicyText)
                .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPolicyView()
        }
    }
}
