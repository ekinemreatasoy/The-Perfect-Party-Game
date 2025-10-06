import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var settings = Settings.shared
    @State private var showingLanguageAlert = false
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $settings.isMuted) {
                        Label {
                            Text("settings.sound.effects".localized)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                        } icon: {
                            Image(systemName: settings.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        }
                    }
                } header: {
                    Text("settings.sound".localized)
                }
                
                Section {
                    Button {
                        showingLanguageAlert = true
                    } label: {
                        Label {
                            Text("settings.language".localized)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                        } icon: {
                            Text(settings.selectedLanguage.flag)
                        }
                    }
                } header: {
                    Text("settings.language".localized)
                }
                
                Section {
                    /*
                    Button {
                        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label {
                            Text("settings.review".localized)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    */
                    Button {
                        showingPrivacyPolicy = true
                    } label: {
                        Label {
                            Text("settings.privacy".localized)
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                        } icon: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.blue)
                        }
                    }
                } header: {
                    Text("settings.support".localized)
                }
                
                Section {
                    HStack {
                        Text("settings.version".localized)
                        Spacer()
                        Text("\(settings.appVersion)")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("settings.last.update".localized)
                        Spacer()
                        Text(settings.lastUpdateDate)
                            .foregroundColor(.gray)
                    }
                    
                } header: {
                    Text("settings.info".localized)
                }
                
                Section {
                    HStack {
                        Text("Sounds Effects By".localized)
                        Spacer()
                        Text("freesound_community from Pixabay")
                            .foregroundColor(.gray)
                    }
                    
                }header: {
                    Text("Credıts".localized)
                }
            }
            .navigationTitle("settings.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.done".localized) {
                        dismiss()
                    }
                }
            }
        }
        .alert("settings.language.change".localized, isPresented: $showingLanguageAlert) {
            Button("settings.language.system".localized) {
                openSettings()
            }
            Button("button.cancel".localized, role: .cancel) {}
        } message: {
            Text("settings.language.system.message".localized)
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    private func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
} 
