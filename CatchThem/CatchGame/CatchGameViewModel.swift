import SwiftUI

class CatchGameViewModel: ObservableObject {
    let contact = CatchGameModel()

    func createGameScene(gameData: CatchGameData) -> CatchGameSpriteKit {
        let scene = CatchGameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
