import SwiftUI

struct RulesView: View {
    let onDismiss: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(colorScheme == .dark ? .white : .purple)
                }
                
                Spacer()
                
                Text("title.rules".localized)
                    .font(.title.bold())
                    .foregroundColor(colorScheme == .dark ? .white : .purple)
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {
                RuleRow(number: 1, text: "rules.1".localized, icon: "exclamationmark.circle.fill")
                RuleRow(number: 2, text: "rules.2".localized, icon: "hand.raised.fill")
                RuleRow(number: 3, text: "rules.3".localized, icon: "face.smiling.fill")
            }
            .padding(.horizontal)
            
            Button {
                onDismiss()
            } label: {
                Text("button.lets.play".localized)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
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
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
                .shadow(radius: 10)
        )
        .padding()
    }
} 
