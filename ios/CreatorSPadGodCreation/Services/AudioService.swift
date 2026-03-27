import AVFoundation

@Observable
@MainActor
class AudioService {
    private var audioPlayers: [String: AVAudioPlayer] = [:]

    private var isSoundEnabled: Bool {
        UserDefaults.standard.object(forKey: "soundEffectsEnabled") as? Bool ?? true
    }

    func playPencilSound() {
        guard isSoundEnabled else { return }
        playSystemSound(id: 1104)
    }

    func playSaveChime() {
        guard isSoundEnabled else { return }
        playSystemSound(id: 1057)
    }

    func playShareCelebration() {
        guard isSoundEnabled else { return }
        playSystemSound(id: 1025)
    }

    func playClearSound() {
        guard isSoundEnabled else { return }
        playSystemSound(id: 1155)
    }

    func playTapSound() {
        guard isSoundEnabled else { return }
        playSystemSound(id: 1105)
    }

    private func playSystemSound(id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}
