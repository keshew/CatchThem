import SwiftUI
import SpriteKit

class CatchGameData: ObservableObject {
    @Published var isLose = false
    @Published var score = 0
    @Published var isPlaying = false
    @ObservedObject var soundManager = SoundManager.shared
}

class CatchGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: CatchGameData?
    var setup: Setup?
    
    @State var isDragging = false
    var selectedNode: SKNode!
    var messageNode: SKSpriteNode!
    var eggPositions: [CGPoint] = [
        CGPoint(x: UIScreen.main.bounds.width / 4.1, y: UIScreen.main.bounds.height / 1.3),
        CGPoint(x: UIScreen.main.bounds.width / 1.3, y: UIScreen.main.bounds.height / 1.3),
        CGPoint(x: UIScreen.main.bounds.width / 7.5, y: UIScreen.main.bounds.height / 1.6),
        CGPoint(x: UIScreen.main.bounds.width / 1.15, y: UIScreen.main.bounds.height / 1.6),
        CGPoint(x: UIScreen.main.bounds.width / 9, y: UIScreen.main.bounds.height / 2.15),
        CGPoint(x: UIScreen.main.bounds.width / 1.12, y: UIScreen.main.bounds.height / 2.15)
    ]
    
    var spawnInterval: TimeInterval = 3.0
    private var hasStartedSpawning = false
    
    func startSpawningEggs() {
        removeAction(forKey: "eggSpawning")

        guard game?.isPlaying == true else { return }

        let spawnAction = SKAction.run { [weak self] in
            self?.spawnEgg()
            self?.spawnInterval = max(0.5, (self?.setup?.countOfEnergy == 3 ? 2 : (self?.spawnInterval ?? 3.0)) * 0.95)
        }
        let waitAction = SKAction.wait(forDuration: spawnInterval)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        let repeatSpawn = SKAction.repeatForever(sequence)
        run(repeatSpawn, withKey: "eggSpawning")
    }

    
    func updateSpawnRate() {
        removeAction(forKey: "eggSpawning")
        startSpawningEggs()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        guard let game = game else { return }

        if game.isPlaying && !hasStartedSpawning {
            startSpawningEggs()
            hasStartedSpawning = true
        }

        if !game.isPlaying, !game.isLose {
            removeAction(forKey: "eggSpawning")
            hasStartedSpawning = false
        }
    }
    
    func getEggRandom() -> String {
        return ["goldenEgg", UserDefaults.standard.string(forKey: "selectedEggImageName") ?? "egg", UserDefaults.standard.string(forKey: "selectedEggImageName") ?? "egg"].randomElement()!
    }
    
    func spawnEgg() {
        if setup?.countOfEnergy == 6 {
            eggPositions = [
                CGPoint(x: UIScreen.main.bounds.width / 9, y: UIScreen.main.bounds.height / 2.15),
                CGPoint(x: UIScreen.main.bounds.width / 1.12, y: UIScreen.main.bounds.height / 2.15)
            ]
        } else if setup?.countOfEnergy == 7 {
            eggPositions = [
                CGPoint(x: UIScreen.main.bounds.width / 7.5, y: UIScreen.main.bounds.height / 1.6),
                CGPoint(x: UIScreen.main.bounds.width / 1.15, y: UIScreen.main.bounds.height / 1.6)
            ]
        } else if setup?.countOfEnergy == 8 {
            eggPositions = [
                CGPoint(x: UIScreen.main.bounds.width / 4.1, y: UIScreen.main.bounds.height / 1.3),
                CGPoint(x: UIScreen.main.bounds.width / 1.3, y: UIScreen.main.bounds.height / 1.3)
            ]
        }
        
        let randomIndex = Int.random(in: 0..<eggPositions.count)
        let startPos = eggPositions[randomIndex]
        
        if setup?.countOfEnergy == 1 {
            let random = getEggRandom()
            let egg = SKSpriteNode(imageNamed: random)
            egg.name = random
            egg.size = CGSize(width: 50, height: 60)
            egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
            egg.physicsBody?.isDynamic = true
            egg.physicsBody?.categoryBitMask = 1 << 2
            egg.physicsBody?.contactTestBitMask = (1 << 1) | (1 << 3)
            egg.physicsBody?.collisionBitMask = (1 << 1) | (1 << 3)
            egg.position = startPos
            
            addChild(egg)
            
            let moveX: CGFloat = (startPos.x < size.width / 2) ? 0 : 0
            let moveDown = CGPoint(x: egg.position.x + moveX, y: egg.position.y - 800)
            
            let moveAction = SKAction.move(to: moveDown, duration: setup?.countOfEnergy == 3 ? 2.0 : setup?.countOfEnergy == 2 ? 2 : 3.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            
            egg.run(sequence)
        } else {
            let egg = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selectedEggImageName") ?? "egg")
            egg.name = "egg"
            egg.size = CGSize(width: 50, height: 60)
            egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
            egg.physicsBody?.isDynamic = true
            egg.physicsBody?.categoryBitMask = 1 << 2
            egg.physicsBody?.contactTestBitMask = (1 << 1) | (1 << 3)
            egg.physicsBody?.collisionBitMask = (1 << 1) | (1 << 3)
            egg.position = startPos
            
            addChild(egg)
            
            let moveX: CGFloat = (startPos.x < size.width / 2) ? 0 : 0
            let moveDown = CGPoint(x: egg.position.x + moveX, y: egg.position.y - 800)
            
            let moveAction = SKAction.move(to: moveDown, duration: setup?.countOfEnergy == 3 ? 2.0 : setup?.countOfEnergy == 2 ? 2 : 3.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            
            egg.run(sequence)
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        createMainNode()
        startSpawningEggs()
        createObstacle()
        createBuscket()
    }
    
    func createMainNode() {
        let gameBackground = SKSpriteNode(imageNamed: "catchBG")
        gameBackground.size = CGSize(width: size.width, height: size.height)
        gameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameBackground)
    }
    
    func createObstacle() {
        let obstacle1 = SKSpriteNode(imageNamed: "obstacle1")
        obstacle1.size = CGSize(width: UIScreen.main.bounds.size.width * 0.375, height: UIScreen.main.bounds.size.height * 0.138)
        obstacle1.position = CGPoint(x: size.width / 5.5, y: size.height / 1.3)
        addChild(obstacle1)
        
        let obstacle1Reverse = SKSpriteNode(imageNamed: "obstacle1")
        obstacle1Reverse.size = CGSize(width: UIScreen.main.bounds.size.width * 0.375, height: UIScreen.main.bounds.size.height * 0.138)
        obstacle1Reverse.position = CGPoint(x: size.width / 1.2, y: size.height / 1.3)
        obstacle1Reverse.xScale = -1
        addChild(obstacle1Reverse)
        
        let obstacle2 = SKSpriteNode(imageNamed: "obstacle2")
        obstacle2.size = CGSize(width: UIScreen.main.bounds.size.width * 0.237, height: UIScreen.main.bounds.size.height * 0.115)
        obstacle2.position = CGPoint(x: size.width / 9, y: size.height / 1.6)
        addChild(obstacle2)
        
        let obstacle2Reverse = SKSpriteNode(imageNamed: "obstacle2")
        obstacle2Reverse.size = CGSize(width: UIScreen.main.bounds.size.width * 0.237, height: UIScreen.main.bounds.size.height * 0.115)
        obstacle2Reverse.position = CGPoint(x: size.width / 1.13, y: size.height / 1.6)
        obstacle2Reverse.xScale = -1
        addChild(obstacle2Reverse)
        
        let obstacle3 = SKSpriteNode(imageNamed: "obstacle3")
        obstacle3.size = CGSize(width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.height * 0.103)
        obstacle3.position = CGPoint(x: size.width / 10, y: size.height / 2.15)
        addChild(obstacle3)
        
        let obstacle3Reverse = SKSpriteNode(imageNamed: "obstacle3")
        obstacle3Reverse.size = CGSize(width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.height * 0.103)
        obstacle3Reverse.position = CGPoint(x: size.width / 1.11, y: size.height / 2.15)
        obstacle3Reverse.xScale = -1
        addChild(obstacle3Reverse)
        
        let floor = SKSpriteNode(imageNamed: "floor")
        floor.name = "floor"
        floor.size = CGSize(width: size.width, height: UIScreen.main.bounds.size.height * 0.149)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = 1 << 1
        floor.physicsBody?.contactTestBitMask = 1 << 2
        floor.position = CGPoint(x: size.width / 2, y: size.height / 15)
        addChild(floor)
    }
    
    
    func createBuscket() {
        let buscketContainer = SKNode()
        buscketContainer.position = CGPoint(x: size.width / 2, y: size.height / 6)
        buscketContainer.name = "buscketContainer"
        
        let buscket = SKSpriteNode(imageNamed: "buscet")
        buscket.name = "buscket"
        buscket.size = CGSize(width: UIScreen.main.bounds.size.width * 0.25, height: UIScreen.main.bounds.size.height * 0.115)
        buscket.position = .zero
        
        buscket.physicsBody = SKPhysicsBody(rectangleOf: buscket.size)
        buscket.physicsBody?.isDynamic = false
        buscket.physicsBody?.categoryBitMask = 1 << 3
        buscket.physicsBody?.contactTestBitMask = 1 << 2
        
        buscketContainer.addChild(buscket)
        
        let message = SKSpriteNode(imageNamed: "message")
        message.name = "message"
        message.size = CGSize(width: UIScreen.main.bounds.size.width * 0.25, height: UIScreen.main.bounds.size.height * 0.115)
        message.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height * 0.115)
        buscketContainer.addChild(message)
        
        let label = SKLabelNode(fontNamed: "Abel-Regular")
        label.name = "scoreLabel"
        label.fontSize = 30
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height * 0.115)
        label.text = "0"
        buscketContainer.addChild(label)
        
        addChild(buscketContainer)
    }
    
    func createCrackedEgg(at position: CGPoint) -> SKNode {
        let crackedEggContainer = SKNode()
        crackedEggContainer.position = CGPoint(x: position.x, y: position.y - 40)
        crackedEggContainer.name = "crackedEggContainer"
        
        let crackedEggSprite = SKSpriteNode(imageNamed: "eggCracked")
        crackedEggSprite.name = "eggCracked"
        crackedEggSprite.size = CGSize(width: 120, height: 60)
        crackedEggSprite.position = .zero
        crackedEggContainer.addChild(crackedEggSprite)
        
        let message = SKSpriteNode(imageNamed: "message")
        message.name = "message"
        message.size = CGSize(width: 100, height: 100)
        message.position = CGPoint(x: 0, y: 100)
        crackedEggContainer.addChild(message)
        
        let label = SKLabelNode(fontNamed: "Abel-Regular")
        label.name = "scoreLabel"
        label.fontSize = 30
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: 95)
        label.text = "Oops\n..."
        crackedEggContainer.addChild(label)
        
        return crackedEggContainer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = atPoint(location) as? SKSpriteNode, node.name == "buscket" {
            selectedNode = node.parent
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = selectedNode else { return }
        let location = touch.location(in: self)
        
        node.position.x = location.x
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        let eggCategory = 1 << 2
        let floorCategory = 1 << 1
        let buscketCategory = 1 << 3

        func isGoldenEgg(_ node: SKNode?) -> Bool {
            guard let node = node else { return false }
            return node.name == "goldenEgg"
        }
        
        func isRegularEgg(_ node: SKNode?) -> Bool {
            guard let node = node else { return false }
            return node.name == "egg"
        }

        if (bodyA.categoryBitMask == eggCategory && bodyB.categoryBitMask == floorCategory) ||
           (bodyB.categoryBitMask == eggCategory && bodyA.categoryBitMask == floorCategory) {

            let eggNode = bodyA.categoryBitMask == eggCategory ? bodyA.node : bodyB.node

            if setup?.countOfEnergy == 1 {
                if let eggNode = eggNode, eggNode.name == "egg" {
                    eggNode.removeFromParent()
                } else {
                    game?.isLose = true
                    isPaused = true
                    if let eggNode = eggNode {
                        eggNode.removeFromParent()
                        let crackedEggNode = createCrackedEgg(at: eggNode.position)
                        addChild(crackedEggNode)
                        game!.soundManager.playBrokeEgg()
                    }
                }
            } else {
                game?.isLose = true
                isPaused = true

                if let eggNode = eggNode {
                    eggNode.removeFromParent()
                    let crackedEggNode = createCrackedEgg(at: eggNode.position)
                    addChild(crackedEggNode)
                    game!.soundManager.playBrokeEgg()
                }
            }
        }


        if (bodyA.categoryBitMask == eggCategory && bodyB.categoryBitMask == buscketCategory) ||
           (bodyB.categoryBitMask == eggCategory && bodyA.categoryBitMask == buscketCategory) {

            let eggNode = bodyA.categoryBitMask == eggCategory ? bodyA.node : bodyB.node

            guard let buscketContainer = childNode(withName: "buscketContainer"),
                  let scoreLabel = buscketContainer.childNode(withName: "scoreLabel") as? SKLabelNode else { return }

            if setup?.countOfEnergy == 1 {
                if let eggNode = eggNode {
                    if !isGoldenEgg(eggNode) {
                        game?.isLose = true
                        isPaused = true
                        eggNode.removeFromParent()
                        let crackedEggNode = createCrackedEgg(at: eggNode.position)
                        addChild(crackedEggNode)
                        game!.soundManager.playBrokeEgg()
                        return
                    }
                }
            }

            eggNode?.removeFromParent()

            game?.score += 1
            if game?.score == 10, setup?.countOfEnergy == 4 {
                game?.score += 5
            } else if game?.score == 1000, setup?.countOfEnergy == 5 {
                loadAndUnlockRandomBird()
            }

            game!.soundManager.playCatchEgg()
            scoreLabel.text = "+\(game!.score)"
        }
    }
    
    func loadAndUnlockRandomBird() {
        var arrayOfBrids: [BitdType] = []
        if let data = UserDefaults.standard.data(forKey: "arrayOfBrids") {
            do {
                let decoded = try JSONDecoder().decode([BitdType].self, from: data)
                arrayOfBrids = decoded
            } catch {
                print("Failed to load saved birds, using default. Error: \(error)")
                arrayOfBrids = [
                    BitdType(name: "Classic", imageName: "chikenMove", isSelected: true, isLocked: false),
                    BitdType(name: "Chicken", imageName: "chickenMove"),
                    BitdType(name: "Turkey", imageName: "turkeyMove"),
                    BitdType(name: "Parrot", imageName: "parrotMove"),
                    BitdType(name: "Canary", imageName: "canaryMove"),
                    BitdType(name: "Penguin", imageName: "penguinMove"),
                    BitdType(name: "Flamingo", imageName: "flamingoMove"),
                    BitdType(name: "Peacock", imageName: "peacockMove"),
                    BitdType(name: "Toucan", imageName: "toucanMove"),
                    BitdType(name: "Owl", imageName: "owlMove"),
                    BitdType(name: "Pigeon", imageName: "pigeonMove"),
                    BitdType(name: "Seagull", imageName: "seagullMove")
                ]
            }
        } else {
            arrayOfBrids = [
                BitdType(name: "Classic", imageName: "chikenMove", isSelected: true, isLocked: false),
                BitdType(name: "Chicken", imageName: "chickenMove"),
                BitdType(name: "Turkey", imageName: "turkeyMove"),
                BitdType(name: "Parrot", imageName: "parrotMove"),
                BitdType(name: "Canary", imageName: "canaryMove"),
                BitdType(name: "Penguin", imageName: "penguinMove"),
                BitdType(name: "Flamingo", imageName: "flamingoMove"),
                BitdType(name: "Peacock", imageName: "peacockMove"),
                BitdType(name: "Toucan", imageName: "toucanMove"),
                BitdType(name: "Owl", imageName: "owlMove"),
                BitdType(name: "Pigeon", imageName: "pigeonMove"),
                BitdType(name: "Seagull", imageName: "seagullMove")
            ]
        }

        let lockedBirds = arrayOfBrids.filter { $0.isLocked }
        guard let randomBird = lockedBirds.randomElement() else {
            return
        }

        if let index = arrayOfBrids.firstIndex(where: { $0.id == randomBird.id }) {
            arrayOfBrids[index].isLocked = false
            saveBirds(arrayOfBrids: arrayOfBrids)
        }
    }

    func saveBirds(arrayOfBrids: [BitdType]) {
         do {
             let data = try JSONEncoder().encode(arrayOfBrids)
             UserDefaults.standard.set(data, forKey: "arrayOfBrids")
         } catch {
             print("Failed save birds: \(error)")
         }
     }
}

struct CatchGameView: View {
    @StateObject var catchGameModel =  CatchGameViewModel()
    @StateObject var gameModel = CatchGameData()
    @EnvironmentObject var router: Router
    @ObservedObject private var soundManager = SoundManager.shared
    @Binding var setup: Setup
    
    var body: some View {
        ZStack {
            SpriteView(scene: createGameScene(gameData: gameModel, setup: setup))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            VStack {
                HStack {
                    Button(action: {
                        router.pop()
                        soundManager.playBtnSound()
                    }) {
                        Image(.backBtn)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("Score:")
                            .Abel(size: 20)
                        
                        Rectangle()
                            .frame(width: 140, height: 30)
                            .opacity(0.6)
                            .cornerRadius(30)
                            .overlay {
                                Text("\(gameModel.score * 100)")
                                    .Abel(size: 22)
                            }
                    }
                    .padding(.trailing, 55)
                    
                    Spacer()
                }
                
                Spacer()
                
                if !gameModel.isPlaying {
                    Text("TAP TO PLAY!")
                        .Abel(size: 40)
                }
            }
            
            if gameModel.isLose {
                LoseCatchView(count: $gameModel.score)
            }
        }
        .onTapGesture {
            withAnimation {
                if !gameModel.isPlaying {
                    gameModel.isPlaying = true
                }
                soundManager.playBtnSound()
            }
        }
        .onAppear {
            print(setup.countOfEnergy)
        }
    }
    
    func createGameScene(gameData: CatchGameData, setup: Setup) -> CatchGameSpriteKit {
        let scene = CatchGameSpriteKit()
        scene.game  = gameData
        scene.setup = setup
        return scene
    }
}

#Preview {
    CatchGameView(setup: .constant(Setup(name: "", countOfEnergy: 2)))
}

