import Foundation

struct MissionResponse: Codable {
    let version: String
    let missions: [MissionItem]
}

struct MissionItem: Codable, Identifiable {
    let id: String
    let content: String
    let gameType: GameType
    let illustration: String
    let category: String
    let difficulty: Difficulty
    let punishment: String?
    
    enum GameType: String, Codable {
        case all
        case girls
        case couples
        case friends
        case party
    }
    
    enum Category: String, Codable {
        case drink
        case action
        case social
        case dare
        case question
        case random
    }
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }
    
    static func loadMissions() -> [MissionItem] {
        let locale = Bundle.main.preferredLocalizations.first ?? "en"
        print("Loading missions for locale: \(locale)")
        
        guard let url = Bundle.main.url(forResource: "missions", withExtension: "json", subdirectory: nil, localization: locale) else {
            print("Failed to find missions file for locale: \(locale)")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("Successfully loaded missions data")
            
            let response = try JSONDecoder().decode(MissionResponse.self, from: data)
            print("Successfully decoded \(response.missions.count) missions")
            return response.missions
            
        } catch let decodingError as DecodingError {
            print("Failed to decode missions: \(decodingError)")
            
            if let data = try? Data(contentsOf: url),
               let dataString = String(data: data, encoding: .utf8) {
                print("Raw JSON content:")
                print(dataString)
            }
            
            return []
            
        } catch {
            print("Failed to load data: \(error)")
            return []
        }
    }
} 
