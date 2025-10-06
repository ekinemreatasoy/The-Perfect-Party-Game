import SwiftUI
import UIKit

struct SpinningWheelView: View {
    let players: [Player]
    @Binding var selectedPlayerIndex: Int
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    let onSpinComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Wheel with segments
                ZStack {
                    ForEach(0..<players.count, id: \.self) { index in
                        WheelSegment(
                            center: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2),
                            radius: min(geometry.size.width, geometry.size.height)/2 - 20,
                            startAngle: Angle(degrees: startAngle(for: index)),
                            endAngle: Angle(degrees: startAngle(for: index + 1)),
                            player: players[index]
                        )
                    }
                }
                .rotationEffect(Angle(degrees: rotation))
                
                // Static pointer
                VStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 40, height: 40)
                        )
                        .shadow(radius: 5)
                    Spacer()
                }
                .padding(.top, 5)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture(perform: spinWheel)
    }
    
    private func startAngle(for index: Int) -> Double {
        Double(index) * (360.0 / Double(players.count))
    }
    
    private func spinWheel() {
        guard !isSpinning else { return }
        isSpinning = true
        selectedPlayerIndex = -1 // Hide current player while spinning
        
        // Random number of full rotations plus the segment we want to land on
        let spinDuration = Double.random(in: 4...8)
        let numberOfRotations = Int.random(in: 3...6)
        let newIndex = Int.random(in: 0..<players.count)
        let finalRotation = Double(numberOfRotations * 360) + 
            (360.0 - startAngle(for: newIndex))
        
        withAnimation(.easeInOut(duration: spinDuration)) {
            rotation += finalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration) {
            selectedPlayerIndex = newIndex
            isSpinning = false
            onSpinComplete()
        }
    }
}

struct WheelSegment: View {
    let center: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    let player: Player
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Segment shape
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .purple.opacity(colorScheme == .dark ? 0.8 : 0.7),
                        .pink.opacity(colorScheme == .dark ? 0.7 : 0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Path { path in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
            )
            
            // Player name
            PlayerNameOverlay(
                name: player.name,
                center: center,
                radius: radius,
                angle: Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
            )
        }
    }
}

struct PlayerNameOverlay: View {
    let name: String
    let center: CGPoint
    let radius: CGFloat
    let angle: Angle
    
    var body: some View {
        let adjustedAngle = angle.degrees - 90 // Adjust for proper text alignment
        
        Text(name)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.6))
            )
            .position(
                x: center.x + cos(Angle(degrees: adjustedAngle).radians) * radius * 0.65,
                y: center.y + sin(Angle(degrees: adjustedAngle).radians) * radius * 0.65
            )
            .rotationEffect(Angle(degrees: adjustedAngle + 90))
    }
} 
