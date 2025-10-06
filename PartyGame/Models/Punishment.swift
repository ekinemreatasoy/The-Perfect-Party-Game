import Foundation

struct PunishmentResponse: Codable {
    let version: String
    let punishments: [PunishmentItem]
}

struct PunishmentItem: Codable, Identifiable {
    let id: String
    let content: String
    
    static func loadPunishments() -> [PunishmentItem] {
        let locale = Bundle.main.preferredLocalizations.first ?? "en"
        print("Loading punishments for locale: \(locale)")
        
        guard let url = Bundle.main.url(forResource: "punishments", withExtension: "json", subdirectory: nil, localization: locale) else {
            print("Failed to find punishments file for locale: \(locale)")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("Successfully loaded punishments data")
            
            let response = try JSONDecoder().decode(PunishmentResponse.self, from: data)
            print("Successfully decoded \(response.punishments.count) punishments")
            return response.punishments
            
        } catch {
            print("Failed to load data: \(error)")
            return []
        }
    }
} 