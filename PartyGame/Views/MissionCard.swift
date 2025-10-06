import SwiftUI

struct MissionCard: View {
    let mission: MissionItem
    let completed: () -> Void
    let failed: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Mission illustration
            Image(systemName:mission.illustration)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .foregroundColor(colorScheme == .dark ? .white : .purple)
            
            // Mission text
            Text(mission.content)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
                .multilineTextAlignment(.center)
                .padding()
            
            // Buttons
            HStack(spacing: 20) {
                Button {
                    SoundManager.shared.playSound("clap")
                    completed()
                } label: {
                    Text("Did it!".localized)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.green.opacity(colorScheme == .dark ? 0.8 : 1),
                                            Color.green.opacity(colorScheme == .dark ? 0.6 : 0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),
                               radius: 5, x: 0, y: 2)
                }
                
                Button {
                    SoundManager.shared.playSound("boo")
                    failed()
                } label: {
                    Text("Skip".localized)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.red.opacity(colorScheme == .dark ? 0.8 : 1),
                                            Color.red.opacity(colorScheme == .dark ? 0.6 : 0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),
                               radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),
                       radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .purple.opacity(colorScheme == .dark ? 0.3 : 0.5),
                            .pink.opacity(colorScheme == .dark ? 0.3 : 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .padding()
    }
}
