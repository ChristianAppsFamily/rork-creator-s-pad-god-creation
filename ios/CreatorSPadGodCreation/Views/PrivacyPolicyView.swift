import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Introduction
                    Group {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last Updated: May 4, 2025")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Creator's Pad (\"we,\" \"our,\" or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our iOS application.")
                            .font(.body)
                    }
                    
                    // Data Collection
                    Group {
                        Text("Data Collection")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("We collect the following types of information:")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• **Device Information**: We collect device-specific information such as your device model, iOS version, and unique device identifiers.")
                            Text("• **Usage Data**: We collect information about how you interact with the app, including features used and time spent in the app.")
                            Text("• **Advertising Data**: Our advertising partner (Google AdMob) may collect data to serve personalized ads, including device advertising identifiers.")
                            Text("• **Purchase History**: We collect information about in-app purchases to validate and restore your purchases.")
                        }
                        .font(.body)
                        .padding(.leading, 8)
                    }
                    
                    // Use of Data
                    Group {
                        Text("Use of Data")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("We use the collected data for the following purposes:")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• To provide and maintain our app services")
                            Text("• To process and validate in-app purchases")
                            Text("• To display advertisements (unless you purchase the ad-free version)")
                            Text("• To analyze app usage and improve user experience")
                            Text("• To detect and prevent fraud or abuse")
                            Text("• To comply with legal obligations")
                        }
                        .font(.body)
                        .padding(.leading, 8)
                    }
                    
                    // Third-Party Services
                    Group {
                        Text("Third-Party Services")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("Google AdMob")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Text("We use Google AdMob to display advertisements in our app. AdMob may collect and use data about your device and app usage to serve personalized ads. You can learn more about Google's privacy practices at:")
                            .font(.body)
                        
                        Link("https://policies.google.com/privacy", destination: URL(string: "https://policies.google.com/privacy")!)
                            .font(.body)
                        
                        Text("You can opt out of personalized advertising through your device settings or by purchasing the ad-free version of our app.")
                            .font(.body)
                            .padding(.top, 4)
                    }
                    
                    // User Rights
                    Group {
                        Text("Your Rights")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("Depending on your location, you may have the following rights:")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• **Access**: Request a copy of the personal data we hold about you")
                            Text("• **Correction**: Request that we correct inaccurate or incomplete data")
                            Text("• **Deletion**: Request that we delete your personal data")
                            Text("• **Restriction**: Request that we restrict processing of your data")
                            Text("• **Data Portability**: Request a copy of your data in a machine-readable format")
                            Text("• **Objection**: Object to the processing of your data for certain purposes")
                        }
                        .font(.body)
                        .padding(.leading, 8)
                        
                        Text("To exercise these rights, please contact us using the information below.")
                            .font(.body)
                            .padding(.top, 4)
                    }
                    
                    // Data Security
                    Group {
                        Text("Data Security")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.")
                            .font(.body)
                    }
                    
                    // Children's Privacy
                    Group {
                        Text("Children's Privacy")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.")
                            .font(.body)
                    }
                    
                    // Changes to Policy
                    Group {
                        Text("Changes to This Policy")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last Updated\" date. You are advised to review this Privacy Policy periodically for any changes.")
                            .font(.body)
                    }
                    
                    // Contact Information
                    Group {
                        Text("Contact Us")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text("If you have any questions about this Privacy Policy or our data practices, please contact us:")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email: support@creatorspad.app")
                            Text("Website: https://creatorspad.app")
                        }
                        .font(.body)
                        .padding(.top, 4)
                        .padding(.leading, 8)
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
