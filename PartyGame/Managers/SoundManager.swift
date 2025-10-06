import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        preloadSounds()
    }
    
    private func preloadSounds() {
        loadSound("clap", type: "mp3")
        loadSound("boo", type: "mp3")
    }
    
    private func loadSound(_ name: String, type: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[name] = player
        } catch {
            print("Failed to load sound: \(error)")
        }
    }
    
    func playSound(_ name: String) {
        guard !Settings.shared.isMuted else { return }
        audioPlayers[name]?.play()
    }
} 
