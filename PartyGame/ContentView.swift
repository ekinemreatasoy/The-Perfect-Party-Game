//
//  ContentView.swift
//  PartyGame
//
//  Created by Ekin Emre Atasoy on 16.01.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingSettings = false
    
    private let games: [Game] = [
        Game(type: .all, icon: "party.popper.fill"),
        Game(type: .girls, icon: "heart.fill")
    ]
    
    private let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
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
                
                VStack(spacing: 20) {
                    // Header with title and settings
                    HStack {
                        Text("Party Games".localized)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                )
                        }
                    }
                    .padding(.top,40)
                    .padding(.horizontal)
                    
                    // Centered game cards
                    VStack(spacing: 30) {
                        ForEach(games) { game in
                            NavigationLink(destination: GameView(game: game)) {
                                GameCard(game: game)
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// Updated GameCard for larger size
struct GameCard: View {
    let game: Game
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Larger icon container
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colorScheme == .dark ? .purple.opacity(0.7) : .purple,
                                colorScheme == .dark ? .pink.opacity(0.7) : .pink
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100) // Increased size
                    .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.2),
                           radius: 5, x: 0, y: 2)
                
                Image(systemName: game.icon)
                    .font(.system(size: 50)) // Increased size
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(game.title)
                    .font(.title2) // Larger font
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .multilineTextAlignment(.center)
                
                Text(game.description)
                    .font(.body) // Larger font
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .lineLimit(2)
            }
        }
        .frame(height: 200) // Fixed height for consistency
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorScheme == .dark ? 
                      Color.black.opacity(0.5) : 
                      Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
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
        .shadow(
            color: colorScheme == .dark ? .clear : .black.opacity(0.1),
            radius: 10, x: 0, y: 5
        )
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
