import SwiftUI
import SpriteKit

class RunGameData: ObservableObject {
    @Published var isLose = false
    @Published var isWin = false
    @Published var reward = 0.0
    @Published var isPlaying = false
    @Published var displayedCoins: Double = (UserDefaultsManager.shared.getCoins() / 2)
    @ObservedObject var soundManager = SoundManager.shared
}

class RunGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: RunGameData?
    var cars: [SKSpriteNode] = []
    var coins: [SKSpriteNode] = []
    var count = 0
    var chiken: SKSpriteNode!
    var gameBackground: SKSpriteNode!
    var colorNodes: [SKSpriteNode] = []
    var lastCarSpawnTime: TimeInterval = 0
    let carXPositions: [CGFloat] = [UIScreen.main.bounds.size.height * 0.31, UIScreen.main.bounds.size.height * 0.515, UIScreen.main.bounds.size.height * 0.744]
    var nextCarIndex = 0
    var lastCoinXPosition: CGFloat = 0
    var countCoin = 0
    var seno: [SKSpriteNode] = []
    var coinMultiplier: Double = 1.01
    var isSceneMoving = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        
        createColorNodes()
        addChiken()
        createCars()
        createCoins()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMoveRightNotification), name: NSNotification.Name("moveRightChikenAndColorNode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(win), name: NSNotification.Name("WIN"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleMoveRightNotification() {
        moveSceneLeft()
    }
    
    @objc func win() {
        scene?.isPaused = true
    }
    
    func createColorNodes() {
        let colorSize = CGSize(width: size.width, height: size.height)
        let color = UIColor(red: 112/255, green: 96/255, blue: 85/255, alpha: 1)
        let count = 3
        
        for i in 0..<count {
            let node = SKSpriteNode(color: color, size: colorSize)
            node.position = CGPoint(x: CGFloat(i) * colorSize.width + colorSize.width / 2, y: size.height / 2)
            addChild(node)
            addVerticalDashedLine(to: node, lineHeight: size.height, dashLength: 70, gapLength: 70, xPosition: 160)
            colorNodes.append(node)
        }

        gameBackground = SKSpriteNode(imageNamed: "leftPartScreen")
        gameBackground.size = CGSize(width: size.width > 600 ? size.width * 0.4 : size.width * 0.6, height: size.width > 600 ? size.height * 0.95 : size.height * 0.75)
        gameBackground.position = CGPoint(x: size.width / 5, y: size.height / 1.5)
        addChild(gameBackground)
    }
  
    func addVerticalDashedLine(to parentNode: SKNode, lineHeight: CGFloat, dashLength: CGFloat, gapLength: CGFloat, xPosition: CGFloat) {
        var currentY: CGFloat = -170

        while currentY < lineHeight {
            let segmentLength = min(dashLength, lineHeight - currentY)
            let path = CGMutablePath()
            path.move(to: CGPoint(x: xPosition, y: currentY))
            path.addLine(to: CGPoint(x: xPosition, y: currentY + segmentLength))

            let lineSegment = SKShapeNode(path: path)
            lineSegment.strokeColor = .white
            lineSegment.lineWidth = 8
            parentNode.addChild(lineSegment)

            currentY += dashLength + gapLength
        }
    }

    func randomCar() -> String {
        return ["car1","car2","car3","car4","car5"].randomElement()!
    }
    func createCars() {
        cars.removeAll()
        let numberOfCars = 3
        let totalWidth = CGFloat(numberOfCars - 1) * 200
        let startX = (size.width * 1.95 - totalWidth) * 0.7
        for i in 0..<numberOfCars {
            let car = SKSpriteNode(imageNamed: randomCar())
            car.size = CGSize(width: 240, height: 240)
            car.position = CGPoint(x: startX + CGFloat(i) * 200, y: -car.size.height / 2)
            car.physicsBody?.isDynamic = true
            car.physicsBody?.affectedByGravity = false
            car.physicsBody?.allowsRotation = false
            car.physicsBody?.categoryBitMask = 0x1 << 1
            car.physicsBody?.contactTestBitMask = 0x1 << 0
            car.physicsBody?.collisionBitMask = 0
   
            addChild(car)
            cars.append(car)
        }
    }
    
    func createCoins() {
        let node = SKSpriteNode(imageNamed: "coins")
        node.size = CGSize(width: 70, height: 70)
        node.position = CGPoint(x: size.width / 1.55, y: size.height / 1.5)

        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = 0x1 << 2
        node.physicsBody?.contactTestBitMask = 0x1 << 0
        node.physicsBody?.collisionBitMask = 0

        addChild(node)

        let label = SKLabelNode(text: String(format: "%.2fx", coinMultiplier))
        label.fontSize = 16
        label.fontName = "Archivo-Regular"
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: -7)
        node.addChild(label)

        lastCoinXPosition = node.position.x
        coins.append(node)

        coinMultiplier += 0.01
    }

    func spawnCoin() {
        let node = SKSpriteNode(imageNamed: "coins")
        node.size = CGSize(width: 70, height: 70)

        let spacing: CGFloat = 250
        let newX = lastCoinXPosition + spacing

        let maxX = size.width * 2
        let spawnX = newX > maxX ? size.width / 1.55 : newX

        node.position = CGPoint(x: spawnX, y: size.height / 1.5)

        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = 0x1 << 2
        node.physicsBody?.contactTestBitMask = 0x1 << 0
        node.physicsBody?.collisionBitMask = 0

        addChild(node)

        let label = SKLabelNode(text: String(format: "%.2fx", coinMultiplier))
        label.fontSize = 16
        label.fontName = "Archivo-Regular"
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: -7)
        node.addChild(label)

        coins.append(node)
        lastCoinXPosition = spawnX

        coinMultiplier += 0.01
    }
    
    func moveCarsInRandomOrder() {
        var indices = Array(0..<cars.count)
        indices.shuffle()

        for index in indices {
            let car = cars[index]
            let delaySeconds = Double.random(in: 1...5)
            let waitAction = SKAction.wait(forDuration: delaySeconds)
            let moveUp = SKAction.moveTo(y: size.height + car.size.height / 2, duration: 3)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([waitAction, SKAction.run {
                car.run(SKAction.sequence([moveUp, remove]))
            }])
            car.run(sequence)
        }
    }
  
    func playButtonTapped() {
        createCars()
        moveCarsInRandomOrder()
    }

    func moveSceneLeft() {
        if isSceneMoving {
            return
        }
        isSceneMoving = true
        if isSceneMoving {
            chiken.texture = SKTexture(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")Move")
        } else {
            chiken.texture = SKTexture(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")Stand")
        }

        let moveDistance: CGFloat = -100
        let moveDuration: TimeInterval = 1.0
        let moveAction = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)

        for node in colorNodes {
            node.run(moveAction) {
                if node.position.x < -self.size.width / 2 {
                    if let maxXNode = self.colorNodes.max(by: { $0.position.x < $1.position.x }) {
                        node.position.x = maxXNode.position.x + self.size.width
                    }
                }
            }
        }
        countCoin += 1
        
        if countCoin == 6 {
            spawnCoin()
            countCoin = 0
        }
        gameBackground.run(moveAction)
        for car in cars {
            car.run(moveAction)
        }
        
        for coin in coins {
            coin.run(moveAction)
        }
        
        for sen in seno {
            sen.run(moveAction)
        }
        
        run(SKAction.wait(forDuration: moveDuration)) {
              self.isSceneMoving = false
            if self.isSceneMoving {
                self.chiken.texture = SKTexture(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")Move")
            } else {
                self.chiken.texture = SKTexture(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")Stand")
            }
          }
    }

    func addChiken() {
        chiken = SKSpriteNode(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")Stand")
        chiken.size = CGSize(width: 90, height: 90)
        chiken.position = CGPoint(x: size.width > 600 ? size.width / 4.8 : size.width / 3, y: size.height / 1.5)

        chiken.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
        chiken.physicsBody?.isDynamic = false
        chiken.physicsBody?.categoryBitMask = 0x1 << 0
        chiken.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 2
        chiken.physicsBody?.collisionBitMask = 0

        addChild(chiken)
    }

    override func update(_ currentTime: TimeInterval) {
        guard let game = game, game.isPlaying else { return }

        if count == 0 {
            count = 1
            playButtonTapped()
        }
        
        if currentTime - lastCarSpawnTime > 3 {
            spawnCar()
            lastCarSpawnTime = currentTime
        }
    }

    func spawnCar() {
        let car = SKSpriteNode(imageNamed: "car1")
        car.size = CGSize(width: 240, height: 240)
        game!.soundManager.playCar()
        let xPosition = carXPositions[nextCarIndex % carXPositions.count]
        nextCarIndex += 1
        car.position = CGPoint(x: xPosition, y: -car.size.height / 2)

        car.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: car.size.width - 40, height: car.size.height - 40))
        car.physicsBody?.isDynamic = true
        car.physicsBody?.affectedByGravity = false
        car.physicsBody?.allowsRotation = false
        car.physicsBody?.categoryBitMask = 0x1 << 1
        car.physicsBody?.contactTestBitMask = 0x1 << 0
        car.physicsBody?.collisionBitMask = 0

        addChild(car)
        cars.append(car)

        let moveUp = SKAction.moveTo(y: size.height + car.size.height / 2, duration: 3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveUp, remove])
        car.run(sequence) {
            if let index = self.cars.firstIndex(of: car) {
                self.cars.remove(at: index)
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        func getSpriteNode(from body: SKPhysicsBody) -> SKSpriteNode? {
            if let sprite = body.node as? SKSpriteNode {
                return sprite
            }
            
            if let parent = body.node?.parent as? SKSpriteNode {
                return parent
            }
            return nil
        }

        let nodeA = getSpriteNode(from: contact.bodyA)
        let nodeB = getSpriteNode(from: contact.bodyB)

        guard let nodeAUnwrapped = nodeA, let nodeBUnwrapped = nodeB else { return }

        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask

        if (categoryA == 0x1 << 0 && categoryB == 0x1 << 2) || (categoryB == 0x1 << 0 && categoryA == 0x1 << 2) {
            var coinNodeToReplace: SKSpriteNode?

            if categoryA == 0x1 << 2 {
                coinNodeToReplace = nodeAUnwrapped
            } else {
                coinNodeToReplace = nodeBUnwrapped
            }

            if let coinNode = coinNodeToReplace {
                let position = coinNode.position
                var multiplier: Double = 1.01
                for child in coinNode.children {
                    if let labelNode = child as? SKLabelNode,
                       let text = labelNode.text?.replacingOccurrences(of: "x", with: ""),
                       let value = Double(text) {
                        multiplier = value
                        break
                    }
                }

                coinNode.removeFromParent()
                let currentCoins = game!.displayedCoins
                let newReward = Double(currentCoins) * multiplier
                game!.reward = newReward
                game!.soundManager.playGotCoin()
                let parentNode = SKSpriteNode(imageNamed: "seno")
                parentNode.size = CGSize(width: 150, height: 110)
                parentNode.position = CGPoint(x: position.x, y: position.y - 70)
                parentNode.physicsBody = nil

                let message = SKSpriteNode(imageNamed: "message")
                message.size = CGSize(width: 80, height: 70)
                message.position = CGPoint.zero
                message.yScale = -1
                parentNode.addChild(message)

                let childNode = SKLabelNode(text: String(format: "%.2fx", multiplier))
                childNode.fontName = "Archivo-Regular"
                childNode.fontSize = 24
                childNode.fontColor = .white
                childNode.position = CGPoint(x: 0, y: -16)
                parentNode.addChild(childNode)

                addChild(parentNode)
                seno.append(parentNode)
            }

        }
        
        if (categoryA == 0x1 << 0 && categoryB == 0x1 << 1) || (categoryB == 0x1 << 0 && categoryA == 0x1 << 1) {
               game?.isLose = true
               scene?.isPaused = true
            game!.soundManager.playChikenEnd()
               var chickenNode: SKSpriteNode?

               if categoryA == 0x1 << 0 {
                   chickenNode = contact.bodyA.node as? SKSpriteNode
               } else if categoryB == 0x1 << 0 {
                   chickenNode = contact.bodyB.node as? SKSpriteNode
               }

               if let chicken = chickenNode {
                   let position = chicken.position
                   chicken.removeFromParent()

                   let damagedChicken = SKSpriteNode(imageNamed: "\(UserDefaults.standard.string(forKey: "selectedBirdImageName") ?? "chiken")End")
                   damagedChicken.size = CGSize(width: 120, height: 80)
                   damagedChicken.position = position
                   self.addChild(damagedChicken)
               }
           }
    }
}

struct RunGameView: View {
    @StateObject var runGameModel =  RunGameViewModel()
    @StateObject var gameModel = RunGameData()
    @EnvironmentObject var router: Router
    @State var currentIndex = 0
    @ObservedObject private var soundManager = SoundManager.shared
    
    var minCoins: Double {
        let coins = UserDefaultsManager.shared.getCoins()
        var current: Double = 0
        if coins >= 1 {
            current = 1
        } else {
            current = 0
        }
        return current
    }

    var maxCoins: Double {
        return UserDefaultsManager.shared.getCoins()
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: runGameModel.createGameScene(gameData: gameModel))
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
                }
                .opacity(gameModel.isPlaying ? 0 : 1)
                .disabled(gameModel.isPlaying ? true : false)
                
                Spacer()
                
                ZStack {
                    Image(.backRun)
                        .resizable()
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack {
                        Spacer()
                        ZStack {
                            Image(.bgBtn)
                                .resizable()
                                .overlay {
                                    HStack {
                                        Button(action: {
                                            gameModel.displayedCoins = minCoins
                                            soundManager.playBtnSound()
                                        }) {
                                            Image(.minBtn)
                                                .resizable()
                                                .frame(width: 55, height: 55)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(gameModel.displayedCoins)")
                                            .Abel(size: 34, color: Color(red: 106/255, green: 21/255, blue: 13/255))
                                        Spacer()
                                        
                                        Button(action: {
                                            gameModel.displayedCoins = maxCoins
                                            soundManager.playBtnSound()
                                        }) {
                                            Image(.maxBtn)
                                                .resizable()
                                                .frame(width: 55, height: 55)
                                        }
                                    }
                                    .padding(.horizontal, 3)
                                }
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(12)
                                .frame(height: 70)
                                .padding(.horizontal)
                        }
                        .opacity(gameModel.isPlaying ? 0.5 : 1)
                        .disabled(gameModel.isPlaying ? true : false)
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    currentIndex = 0
                                }
                                soundManager.playBtnSound()
                            }) {
                                Image(currentIndex == 0 ? .selectedRun : .unselectedRun)
                                    .resizable()
                                    .overlay {
                                        Text("EASY")
                                            .Actor(size: 24, color: currentIndex == 0 ? Color(red: 254/255, green: 127/255, blue: 67/255) : Color(red: 106/255, green: 21/255, blue: 13/255))
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5)
                                    .frame(height: 60)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    currentIndex = 1
                                }
                                soundManager.playBtnSound()
                            }) {
                                Image(currentIndex == 1 ? .selectedRun : .unselectedRun)
                                    .resizable()
                                    .overlay {
                                        Text("NORMAL")
                                            .Actor(size: 24, color: currentIndex == 1 ? Color(red: 254/255, green: 127/255, blue: 67/255) : Color(red: 106/255, green: 21/255, blue: 13/255))
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5)
                                    .frame(height: 60)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    currentIndex = 2
                                }
                                soundManager.playBtnSound()
                            }) {
                                Image(currentIndex == 2 ? .selectedRun : .unselectedRun)
                                    .resizable()
                                    .overlay {
                                        Text("HARD")
                                            .Actor(size: 24, color: currentIndex == 2 ? Color(red: 254/255, green: 127/255, blue: 67/255) : Color(red: 106/255, green: 21/255, blue: 13/255))
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5)
                                    .frame(height: 60)
                            }
                        }
                        .padding(.horizontal)
                        .opacity(gameModel.isPlaying ? 0.5 : 1)
                        .disabled(gameModel.isPlaying ? true : false)
                        
                        if !gameModel.isPlaying {
                            Button(action: {
                                withAnimation {
                                    gameModel.isPlaying = true
                                }
                                soundManager.playPlayTap()
                            }) {
                                Image(.playBtn)
                                    .resizable()
                                    .overlay {
                                        Text("PLAY!")
                                            .Actor(size: 50, color: Color(red: 0/255, green: 92/255, blue: 43/255))
                                    }
                                    .frame(height: 100)
                            }
                            .padding(.horizontal)
                        } else {
                            HStack(spacing: 0) {
                                Button(action: {
                                    if gameModel.reward > gameModel.displayedCoins {
                                        gameModel.reward = gameModel.reward - gameModel.displayedCoins
                                    } else {
                                        gameModel.reward = 0
                                    }
                                    
                                    gameModel.isWin = true
                                    NotificationCenter.default.post(name: NSNotification.Name("WIN"), object: nil)
                                }) {
                                    Image(.cashOut)
                                        .resizable()
                                        .overlay {
                                            Text("CASH OUT\n \(gameModel.reward.roundedToTwoPlaces()) USD")
                                                .Actor(size: 23, color: Color(red: 133/255, green: 58/255, blue: 8/255))
                                        }
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 100)
                                }
                                Spacer()
                                Button(action: {
                                    NotificationCenter.default.post(name: NSNotification.Name("moveRightChikenAndColorNode"), object: nil)
                                }) {
                                    Image(.goBtn)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 100)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(width: UIScreen.main.bounds.width, height: 260)
            }
      
            
            if gameModel.isLose {
                LoseChikaRunView(reward: $gameModel.displayedCoins)
            }
            
            if gameModel.isWin {
                WinRunView(reward: $gameModel.reward)
            }
        }
    }
}

#Preview {
    RunGameView()
}

//let carXPositions: [CGFloat] = [size.height * 0.31, size.height * 0.515, size.height * 0.744]
