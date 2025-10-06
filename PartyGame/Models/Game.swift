import Foundation

struct Game: Identifiable {
    let id = UUID()
    let type: GameType
    let icon: String
    
    var title: String {
        "game.\(type.rawValue)".localized
    }
    
    var description: String {
        "game.\(type.rawValue).description".localized
    }
}

enum GameType: String, Codable {
    case all
    case girls
    case couples // Kept for future use
    case friends // Kept for future use
    case party   // Kept for future use
    
    var isActive: Bool {
        switch self {
        case .all, .girls:
            return true
        default:
            return false
        }
    }
} 