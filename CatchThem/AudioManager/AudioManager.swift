import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()

    var bgPlayer: AVAudioPlayer?
    var brokeEggPlayer: AVAudioPlayer?
    var btnSoundPlayer: AVAudioPlayer?
    var carPlayer: AVAudioPlayer?
    var catchEggPlayer: AVAudioPlayer?
    var chikenEndPlayer: AVAudioPlayer?
    var gotCoinPlayer: AVAudioPlayer?
    var losePlayer: AVAudioPlayer?
    var menuYapPlayer: AVAudioPlayer?
    var playTapPlayer: AVAudioPlayer?
    var winPlayer: AVAudioPlayer?

    @Published var backgroundVolume: Float = 1 {
        didSet {
            bgPlayer?.volume = backgroundVolume
            winPlayer?.volume = backgroundVolume
        }
    }

    @Published var soundEffectVolume: Float = 1 {
        didSet {
            brokeEggPlayer?.volume = soundEffectVolume
            btnSoundPlayer?.volume = soundEffectVolume
            carPlayer?.volume = soundEffectVolume
            catchEggPlayer?.volume = soundEffectVolume
            chikenEndPlayer?.volume = soundEffectVolume
            gotCoinPlayer?.volume = soundEffectVolume
            losePlayer?.volume = soundEffectVolume
            menuYapPlayer?.volume = soundEffectVolume
            playTapPlayer?.volume = soundEffectVolume
        }
    }

    @Published var isSoundEnabled: Bool = true
    @Published var isMusicEnabled: Bool = true

    init() {
        loadBackgroundMusic()
        loadAllSoundEffects()

        if isMusicEnabled {
//            playBackgroundMusic()
        }
    }

    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            do {
                bgPlayer = try AVAudioPlayer(contentsOf: url)
                bgPlayer?.numberOfLoops = -1
                bgPlayer?.volume = backgroundVolume
                bgPlayer?.prepareToPlay()
            } catch {
                print("Ошибка загрузки bg: \(error)")
            }
        }
    }
    
    private func loadWinMusic() {
        if let url = Bundle.main.url(forResource: "win", withExtension: "mp3") {
            do {
                winPlayer = try AVAudioPlayer(contentsOf: url)
                winPlayer?.numberOfLoops = -1
                winPlayer?.volume = backgroundVolume
                winPlayer?.prepareToPlay()
            } catch {
                print("Ошибка загрузки win: \(error)")
            }
        }
    }

    private func loadAllSoundEffects() {
        loadSoundEffect(&brokeEggPlayer, resource: "brokeEgg")
        loadSoundEffect(&btnSoundPlayer, resource: "btnSound")
        loadSoundEffect(&carPlayer, resource: "car")
        loadSoundEffect(&catchEggPlayer, resource: "catchEgg")
        loadSoundEffect(&chikenEndPlayer, resource: "chikenDie")
        loadSoundEffect(&gotCoinPlayer, resource: "gotCoin")
        loadSoundEffect(&losePlayer, resource: "lose")
        loadSoundEffect(&menuYapPlayer, resource: "menuTap")
        loadSoundEffect(&playTapPlayer, resource: "playTap")
        loadWinMusic()
    }

    private func loadSoundEffect(_ player: inout AVAudioPlayer?, resource: String) {
        if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = soundEffectVolume
                player?.numberOfLoops = 1
                player?.prepareToPlay()
            } catch {
                print("Ошибка загрузки \(resource): \(error)")
            }
        }
    }

    // MARK: - Play background music / stop
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }
        bgPlayer?.play()
    }

    func stopBackgroundMusic() {
        bgPlayer?.stop()
    }

    // MARK: - Play win music / stop
    func playWinMusic() {
        guard isMusicEnabled else { return }
        winPlayer?.play()
    }

    func stopWinMusic() {
        winPlayer?.stop()
    }

    // MARK: - Play sound effects (пример для каждого плеера)
    func playBrokeEgg() {
        guard isSoundEnabled else { return }
        brokeEggPlayer?.play()
    }

    func playBtnSound() {
        guard isSoundEnabled else { return }
        btnSoundPlayer?.play()
    }

    func playCar() {
        guard isSoundEnabled else { return }
        carPlayer?.play()
    }

    func playCatchEgg() {
        guard isSoundEnabled else { return }
        catchEggPlayer?.play()
    }

    func playChikenEnd() {
        guard isSoundEnabled else { return }
        chikenEndPlayer?.play()
    }

    func playGotCoin() {
        guard isSoundEnabled else { return }
        gotCoinPlayer?.play()
    }

    func playLose() {
        guard isSoundEnabled else { return }
        losePlayer?.play()
    }

    func playMenuYap() {
        guard isSoundEnabled else { return }
        menuYapPlayer?.play()
    }

    func playPlayTap() {
        guard isSoundEnabled else { return }
        playTapPlayer?.play()
    }
}
