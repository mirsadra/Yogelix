//  TermsOfUseView.swift
import SwiftUI

struct TermsOfUseView: View {
    // Placeholder for terms of use text
    // Replace with your actual terms of use content
    private let termsOfUseText: String = """
    [Your App Name] Terms of Use

    Introduction:
    These terms and conditions outline the rules and regulations for the use of [Your App Name]'s app.

    Acceptance of Terms:
    By using this app, you agree to these terms and conditions. Do not continue to use the app if you do not agree to all of the terms and conditions stated on this page.

    Modifications to Terms:
    We reserve the right to modify these terms at any time. Your continued use of the app following any such modification constitutes your acceptance of these modified terms.

    Use of the App:
    - The app is intended for personal, non-commercial use.
    - You agree not to use the app in a way that is illegal, harmful, or infringes on others' rights.

    Limitation of Liability:
    [Your Company Name] will not be liable for any damages arising from the use of this app.

    Contact Information:
    If you have any questions about these Terms of Use, please contact us.

    (This is a placeholder for terms of use. Please replace it with your actual terms of use content.)
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
