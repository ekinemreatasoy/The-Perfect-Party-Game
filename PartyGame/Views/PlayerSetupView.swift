import SwiftUI

struct PlayerSetupView: View {
    @Binding var players: [Player]
    @State private var newPlayerName = ""
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Players")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: 15) {
                HStack {
                    TextField("Player name", text: $newPlayerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addPlayer) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    .disabled(newPlayerName.isEmpty)
                }
                .padding(.horizontal)
                
                if !players.isEmpty {
                    List {
                        ForEach(players) { player in
                            Text(player.name)
                                .font(.title3)
                        }
                        .onDelete(perform: deletePlayers)
                    }
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 10)
            )
            
            if players.count >= 2 {
                Button(action: onComplete) {
                    Text("Start Game")
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
                        .shadow(radius: 5)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func addPlayer() {
        let player = Player(name: newPlayerName)
        players.append(player)
        newPlayerName = ""
    }
    
    private func deletePlayers(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
} 