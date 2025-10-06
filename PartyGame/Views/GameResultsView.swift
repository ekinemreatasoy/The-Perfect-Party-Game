import SwiftUI

struct GameResultsView: View {
    let stats: GameStats
    let onDismiss: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Game Results".localized)
                .font(.title.bold())
                .foregroundColor(.purple)
            
            VStack(spacing: 20) {
                ResultRow(title: "Completed".localized, value: stats.didItCount, icon: "checkmark.circle.fill", color: .green)
                ResultRow(title: "Skipped".localized, value: stats.failedCount, icon: "x.circle.fill", color: .red)
                ResultRow(title: "Total Missions".localized, value: stats.totalMissions, icon: "flag.fill", color: .blue)
                ResultRow(title: "Completion Rate".localized, value: String(format: "%.1f%%", stats.completionRate), icon: "chart.bar.fill", color: .purple)
            }
            .padding()
            
            Button("Close".localized) {
                onDismiss()
            }
            .font(.title3.bold())
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .padding(.top, 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .shadow(radius: 10)
        )
        .padding()
    }
}
struct PlayerResultRow: View {
    let rank: Int
    let player: Player
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title2.bold())
                .foregroundColor(rank == 1 ? .yellow : .secondary)
                .frame(width: 40)
            
            Text(player.name)
                .font(.title3)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(player.totalPoints) pts")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Text("T: \(player.truthCount) D: \(player.dareCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.1))
        )
    }
} 
