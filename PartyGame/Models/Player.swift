import Foundation

struct Player: Identifiable {
    let id = UUID()
    let name: String
    var truthCount: Int = 0
    var dareCount: Int = 0
    
    var totalPoints: Int {
        // Dares are worth more points
        (truthCount * 5) + (dareCount * 10)
    }
} 