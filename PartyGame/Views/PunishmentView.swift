import SwiftUI

struct PunishmentView: View {
    let punishment: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Punishment")
                .font(.title.bold())
                .foregroundColor(.red)
            
            Text(punishment)
                .font(.title2)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                
            
            Button("Got it!") {
                onDismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
} 
