import SwiftUI

class RunGameViewModel: ObservableObject {
    func createGameScene(gameData: RunGameData) -> RunGameSpriteKit {
        let scene = RunGameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
