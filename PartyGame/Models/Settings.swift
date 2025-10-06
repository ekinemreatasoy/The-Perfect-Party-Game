import Foundation

class Settings: ObservableObject {
    static let shared = Settings()
    
    @Published var isMuted: Bool {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: "isMuted")
        }
    }
    
    var selectedLanguage: Language {
        let locale = Bundle.main.preferredLocalizations.first ?? "en"
        return Language(rawValue: locale) ?? .en
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var lastUpdateDate: String {
        "16.01.2025"
    }
    
    enum Language: String {
        case en, tr, de
        
        var displayName: String {
            switch self {
            case .en: return "English"
            case .tr: return "Türkçe"
            case .de: return "Deutsch"
            }
        }
        
        var flag: String {
            switch self {
            case .en: return "🇬🇧"
            case .tr: return "🇹🇷"
            case .de: return "🇩🇪"
            }
        }
    }
    
    private init() {
        self.isMuted = UserDefaults.standard.bool(forKey: "isMuted")
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
} 
