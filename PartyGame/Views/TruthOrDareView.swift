import SwiftUI

struct TruthOrDareView: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var players: [Player] = []
    @State private var selectedPlayerIndex = 0
    @State private var showingSetup = true
    @State private var showingTruthOrDare = false
    @State private var showingResults = false
    @State private var showingExitConfirmation = false
    
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
            
            if showingSetup {
                PlayerSetupView(players: $players) {
                    withAnimation {
                        showingSetup = false
                    }
                }
            } else {
                VStack {
                    // Header with scores
                    HStack {
                        Button("End Game") {
                            showingExitConfirmation = true
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Round \(totalRounds)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    // Spinning wheel
                    SpinningWheelView(
                        players: players,
                        selectedPlayerIndex: $selectedPlayerIndex
                    ) {
                        showingTruthOrDare = true
                    }
                    .padding()
                    
                    // Selected player info
                    if let player = players[safe: selectedPlayerIndex] {
                        PlayerScoreView(player: player)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingTruthOrDare) {
            TruthOrDareChoiceView(
                player: players[selectedPlayerIndex],
                onTruthSelected: { handleTruth() },
                onDareSelected: { handleDare() }
            )
        }
        .sheet(isPresented: $showingResults) {
            TruthOrDareResultsView(players: players, onDismiss: {
                showingResults = false
                dismiss()
            })
        }
        .confirmationDialog(
            "End Game?",
            isPresented: $showingExitConfirmation,
            titleVisibility: .visible
        ) {
            Button("Show Results", role: .none) {
                showingResults = true
            }
            Button("Exit", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var totalRounds: Int {
        players.reduce(0) { $0 + $1.truthCount + $1.dareCount }
    }
    
    private func handleTruth() {
        var updatedPlayers = players
        updatedPlayers[selectedPlayerIndex].truthCount += 1
        players = updatedPlayers
        showingTruthOrDare = false
    }
    
    private func handleDare() {
        var updatedPlayers = players
        updatedPlayers[selectedPlayerIndex].dareCount += 1
        players = updatedPlayers
        showingTruthOrDare = false
    }
}

struct PlayerScoreView: View {
    let player: Player
    
    var body: some View {
        VStack(spacing: 10) {
            Text(player.name)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                ScoreItem(title: "Truth", count: player.truthCount, color: .blue)
                ScoreItem(title: "Dare", count: player.dareCount, color: .red)
                ScoreItem(title: "Points", count: player.totalPoints, color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct ScoreItem: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text("\(count)")
                .font(.title3.bold())
                .foregroundColor(color)
        }
    }
}

struct TruthOrDareChoiceView: View {
    let player: Player
    let onTruthSelected: () -> Void
    let onDareSelected: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingVerification = false
    @State private var selectedChallenge: Challenge?
    
    enum Challenge {
        case truth, dare
    }
    
    var body: some View {
        if showingVerification {
            ChallengeVerificationView(
                player: player,
                challengeType: selectedChallenge ?? .truth,
                onComplete: { completed in
                    if completed {
                        if selectedChallenge == .truth {
                            onTruthSelected()
                        } else {
                            onDareSelected()
                        }
                    }
                    dismiss()
                }
            )
        } else {
            VStack(spacing: 30) {
                Text("\(player.name)'s Turn!")
                    .font(.title.bold())
                    .foregroundColor(.purple)
                
                Text("Choose your challenge")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    ChallengeButton(
                        title: "Truth",
                        color: .blue,
                        icon: "text.bubble.fill"
                    ) {
                        selectedChallenge = .truth
                        showingVerification = true
                    }
                    
                    ChallengeButton(
                        title: "Dare",
                        color: .red,
                        icon: "flame.fill"
                    ) {
                        selectedChallenge = .dare
                        showingVerification = true
                    }
                }
            }
            .padding()
        }
    }
}

struct ChallengeVerificationView: View {
    let player: Player
    let challengeType: TruthOrDareChoiceView.Challenge
    let onComplete: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Did \(player.name) complete the \(challengeType == .truth ? "Truth" : "Dare")?")
                .font(.title2.bold())
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button {
                    onComplete(true)
                } label: {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                        Text("Yes!")
                            .font(.headline)
                    }
                    .foregroundColor(.green)
                    .frame(width: 100, height: 100)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(15)
                }
                
                Button {
                    onComplete(false)
                } label: {
                    VStack {
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: 40))
                        Text("No")
                            .font(.headline)
                    }
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(15)
                }
            }
        }
        .padding()
    }
}

struct ChallengeButton: View {
    let title: String
    let color: Color
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                Text(title)
                    .font(.title3.bold())
            }
            .foregroundColor(.white)
            .frame(width: 120, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(radius: 5)
        }
    }
}

// Helper extension for safe array access
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct TruthOrDareResultsView: View {
    let players: [Player]
    let onDismiss: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var sortedPlayers: [Player] {
        players.sorted { $0.totalPoints > $1.totalPoints }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Truth or Dare Results")
                .font(.title.bold())
                .foregroundColor(.purple)
            
            ForEach(Array(sortedPlayers.enumerated()), id: \.element.id) { index, player in
                TruthDarePlayerRow(rank: index + 1, player: player)
            }
            
            Button("Close") {
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

struct TruthDarePlayerRow: View {
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
                
                HStack(spacing: 12) {
                    Label("\(player.truthCount)", systemImage: "text.bubble.fill")
                        .foregroundColor(.blue)
                    Label("\(player.dareCount)", systemImage: "flame.fill")
                        .foregroundColor(.red)
                }
                .font(.caption)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.1))
        )
    }
} 