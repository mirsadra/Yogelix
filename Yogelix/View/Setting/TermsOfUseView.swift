//  TermsOfUseView.swift
import SwiftUI

struct TermsOfUseView: View {
    // Placeholder for terms of use text
    // Replace with your actual terms of use content
    private let termsOfUseText: String = """
    Yogelix Terms of Use

    Introduction:
    Welcome to Yogelix, a yoga app designed for iOS users. These terms and conditions govern your use of the Yogelix app and its associated services.

    Acceptance of Terms:
    By downloading, accessing, or using Yogelix, you agree to be bound by these terms and conditions. If you do not agree to all terms, do not use Yogelix.

    Modifications to Terms:
    Yogelix reserves the right to revise or replace these terms at any time. Your continued use following such changes signifies your acceptance of the revised terms.

    Use of the App:
    - Yogelix is for personal, non-commercial use only.
    - You must not use this app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of our service.

    Account Registration:
    - Users may be required to register an account to access certain features.
    - You must provide accurate, current, and complete information during registration and maintain the accuracy of this information.

    Privacy and Data Use:
    - Your use of Yogelix is also governed by our Privacy Policy.
    - We use Apple HealthKit to access and store relevant health data, with your consent.

    Intellectual Property Rights:
    - All intellectual property rights in the app, its content, and the underlying technology are owned by or licensed to Yogelix.

    User Content:
    - Users may submit content to the app. You grant Yogelix a non-exclusive, worldwide, royalty-free license to use, reproduce, distribute, and display such content in connection with the service.

    Subscription and Payment:
    - Details about subscription fees, payment methods, and cancellation policies are available within the app.

    Limitation of Liability:
    - Yogelix will not be liable for any indirect, special, incidental, consequential, or exemplary damages arising from your use of the app.

    Indemnification:
    - You agree to indemnify Yogelix against any losses, damages, costs, liabilities, and expenses incurred or suffered by us arising out of any breach by you of these terms.

    Termination:
    - Yogelix may terminate or suspend your access to the app immediately, without prior notice or liability, for any reason.

    Governing Law:
    - These terms are governed by and construed in accordance with the laws of the jurisdiction where Yogelix is headquartered.

    Dispute Resolution:
    - Any disputes related to these terms will be resolved through arbitration, in accordance with the rules of the jurisdiction.

    Contact Information:
    For questions about these Terms of Use, please contact us at [Your Contact Information].

    Disclaimer: This document is a template. It is essential to consult with a legal professional to ensure that your Terms of Use are comprehensive, compliant with applicable laws, and tailored to your app's specific features and risks.
    """

    var body: some View {
        ScrollView {
            Text(termsOfUseText)
                .padding()
        }
        .navigationTitle("Terms of Use")
    }
}

struct TermsOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsOfUseView()
        }
    }
}
