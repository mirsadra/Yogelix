//  PrivacyPolicyView.swift
import SwiftUI

struct PrivacyPolicyView: View {
    // Placeholder for privacy policy text
    // Replace with your actual privacy policy content
    private let privacyPolicyText: String = """
    [Your App Name] Privacy Policy

    Introduction:
    Your privacy is important to us. This privacy policy explains how we handle and protect your personal information in connection with [Your App Name]'s services.

    Information Collection and Use:
    - We collect information that you provide when using the app.
    - We use this information to improve our services.

    Data Security:
    We employ various security measures to protect your information.

    Changes to This Policy:
    We may update our Privacy Policy from time to time. We will notify you of any changes by updating the policy on this page.

    Contact Us:
    If you have any questions about this Privacy Policy, please contact us.

    (This is a placeholder privacy policy. Please replace it with your actual privacy policy content.)
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
