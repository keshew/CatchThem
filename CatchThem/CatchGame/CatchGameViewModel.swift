import SwiftUI

class CatchGameViewModel: ObservableObject {
    func createGameScene(gameData: CatchGameData) -> CatchGameSpriteKit {
        let scene = CatchGameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
