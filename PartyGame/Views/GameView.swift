import SwiftUI
import CoreData

struct GameStats {
    var didItCount: Int = 0
    var failedCount: Int = 0
    var totalMissions: Int = 0
    
    var completionRate: Double {
        guard totalMissions > 0 else { return 0 }
        return Double(didItCount) / Double(totalMissions) * 100
    }
}

struct GameView: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var currentMissionIndex = 0
    @State private var showingMission = false
    @State private var showingRules = true
    @State private var showingExitConfirmation = false
    @State private var showingResults = false
    @State private var gameStats = GameStats()
    @State private var showingPunishmentView = false
    @State private var currentPunishment: String = ""
    @State private var isFlipped = false
    
    private var missions: [MissionItem] {
        let loadedMissions = MissionItem.loadMissions().filter { $0.gameType.rawValue == game.type.rawValue }
        print("Loaded \(loadedMissions.count) missions for game type: \(game.type)")
        return loadedMissions
    }
    
    private var currentMission: MissionItem? {
        guard currentMissionIndex < missions.count else {
            print("No more missions available")
            return nil
        }
        return missions[currentMissionIndex]
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(colorScheme == .dark ? 0.3 : 0.6),
                    Color.pink.opacity(colorScheme == .dark ? 0.2 : 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if showingPunishmentView {
                    // Show Punishment View
                    PunishmentView(punishment: currentPunishment) {
                        showingPunishmentView = false
                    }
                    .transition(.scale) // Add transition effect
                } else {
                    // Show Mission View
                    if showingMission {
                        Text("mission.number".localized(with: currentMissionIndex + 1))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    } else {
                        Text(game.title)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    }
                    
                    // Main content
                    ZStack {
                        if showingRules {
                            RulesView {
                                withAnimation {
                                    showingRules = false
                                }
                            }
                            .transition(.opacity)
                        } else if showingMission, let mission = currentMission {
                            GeometryReader { geometry in
                                VStack {
                                    Spacer()
                                    
                                    MissionCard(
                                        mission: mission,
                                        completed: {
                                            gameStats.didItCount += 1
                                            gameStats.totalMissions += 1
                                            nextMission()
                                        },
                                        failed: {
                                            gameStats.failedCount += 1
                                            gameStats.totalMissions += 1
                                            showPunishment(for: mission) // Call the punishment function
                                        }
                                    )
                                    .frame(width: min(geometry.size.width * 0.9, 400))
                                    .frame(maxWidth: .infinity)
                                    
                                    // Stats at bottom
                                    HStack(spacing: 30) {
                                        StatBadge(
                                            icon: "checkmark.circle.fill",
                                            count: gameStats.didItCount,
                                            label: "mission.completed".localized,
                                            color: .green
                                        )
                                        StatBadge(
                                            icon: "x.circle.fill",
                                            count: gameStats.failedCount,
                                            label: "mission.failed".localized,
                                            color: .red
                                        )
                                    }
                                    .padding(.bottom, 30)
                                }
                            }
                        }
                    }
                }
                
                // End game button
                if showingMission {
                    Button {
                        showingExitConfirmation = true
                    } label: {
                        Text("button.end".localized)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog(
            "game.end.confirmation".localized,
            isPresented: $showingExitConfirmation,
            titleVisibility: .visible
        ) {
            Button("game.end.show.results".localized, role: .none) {
                showingResults = true
            }
            Button("game.end.exit".localized, role: .destructive) {
                dismiss()
            }
            Button("button.cancel".localized, role: .cancel) {}
        } message: {
            Text("game.end.message".localized)
        }
        .sheet(isPresented: $showingResults) {
            GameResultsView(stats: gameStats) {
                showingResults = false
                dismiss()
            }
        }
    }
    
    private func nextMission() {
        withAnimation {
            currentMissionIndex += 1
            print("Moving to mission \(currentMissionIndex)")
            
            // Check if we reached the end of missions
            if currentMissionIndex >= missions.count {
                print("Reached end of missions")
                showingResults = true
                showingMission = false
            }
        }
    }
    
    private func showPunishment(for mission: MissionItem) {
        let punishments = PunishmentItem.loadPunishments()
        let randomPunishment = punishments.randomElement()?.content ?? "No punishment assigned."
        
        // Set the current punishment and show the punishment view
        currentPunishment = randomPunishment
        showingPunishmentView = true
    }
    
    private func showingPunishmentAlert(punishmentMessage: String) {
        // Use a state variable to control the display of the punishment view
        let punishmentView = PunishmentView(punishment: punishmentMessage) {
            // Dismiss the punishment view
            // You can use a state variable to control this
        }
        
        // Present the punishment view
        // You may need to use a sheet or fullScreenCover to present this view
        // Example:
        // self.present(punishmentView, animated: true, completion: nil)
    }
}

struct StatBadge: View {
    let icon: String
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text("\(count)")
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}


struct ResultRow: View {
    let title: String
    let value: Any
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(title)
                .font(.title3)
            
            Spacer()
            
            Text("\(String(describing: value))")
                .font(.title3.bold())
                .foregroundColor(color)
        }
    }
}


struct RuleRow: View {
    let number: Int
    let text: String
    let icon: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(colorScheme == .dark ? .white : .purple)
            
            Text("\(number). \(text)")
                .font(.title3)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
        }
    }
} 
