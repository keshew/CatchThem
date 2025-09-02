import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State var openRw = false
    @EnvironmentObject var router: Router
    @State private var showEnergyAlert = false
    @State private var showCoinAlert = false
    @EnvironmentObject var dailyRewardModel: DailyRewardViewModel
    @ObservedObject private var soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 99/255, green: 159/255, blue: 191/255),
                                    Color(red: 32/255, green: 76/255, blue: 133/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                HStack {
                    ZStack(alignment: .leading) {
                        ZStack {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(red: 2/255, green: 93/255, blue: 12/255))
                                    .frame(width: 140, height: 30)
                                    .opacity(0.3)
                                    .cornerRadius(20)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 2/255, green: 93/255, blue: 12/255), lineWidth: 2)
                                    }
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 197/255, green: 224/255, blue: 44/255),
                                                                  Color(red: 68/255, green: 178/255, blue: 20/255)], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: CGFloat(mainModel.energy) / 15 * 140, height: 30)
                                    .cornerRadius(20)
                                
                            }
                            
                            Text("\(mainModel.energy)/15")
                                .Abel(size: 18)
                                .padding(.leading, 10)
                        }
                        
                        Image(.energy)
                            .resizable()
                            .frame(width: 30, height: 40)
                            .offset(x: -10)
                    }
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: 140, height: 30)
                            .opacity(0.3)
                            .cornerRadius(20)
                            .overlay {
                                Text("\(mainModel.coins.roundedToTwoPlaces())")
                                    .Abel(size: 18)
                                    .padding(.leading, 30)
                            }
                        
                        Image(.coins)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            openRw = true
                            soundManager.playBtnSound()
                        }
                    }) {
                        Image(dailyRewardModel.rewards.indices.contains(where: { dailyRewardModel.canClaimReward(at: $0) }) ? .dailyRewardActive : .dailyReward)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 85)
                    }
                    .padding(.horizontal)
                }
                
                Image(mainModel.currentIndex == 0 ? .game2 : .game1)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.height * 0.5)
                
                VStack(spacing: 10) {
                    HStack {
                        Image(.energy)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 30)
                        
                        Text("-5")
                            .Abel(size: 24)
                    }
                    .opacity(mainModel.currentIndex == 0 ? 0 : 1)
                    
                    Button(action: {
                        switch mainModel.currentIndex {
                        case 0:
                            if mainModel.ud.getCoins() > 0 {
                                router.goToRunGame()
                            } else {
                                showCoinAlert = true
                            }
                        case 1:
                            if mainModel.ud.getEnergy() >= 5 {
                                router.goToCatchGame()
                                mainModel.ud.minusEnergy(5)
                            } else {
                                showEnergyAlert = true
                            }
                        default:
                            router.pop()
                        }
                        soundManager.playPlayTap()
                    }) {
                        Image(.play)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 90)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    Rectangle()
                        .fill(mainModel.currentIndex == 1 ? Color(red: 17/255, green: 39/255, blue: 118/255) : Color(red: 170/255, green: 235/255, blue: 255/255))
                        .frame(width: UIScreen.main.bounds.width * 0.28, height: 10)
                        .cornerRadius(20)
                    
                    Rectangle()
                        .fill(mainModel.currentIndex == 0 ? Color(red: 17/255, green: 39/255, blue: 118/255) : Color(red: 170/255, green: 235/255, blue: 255/255))
                        .frame(width: UIScreen.main.bounds.width * 0.28, height: 10)
                        .cornerRadius(20)
                }
            }
            .padding(.vertical)
            
            if openRw {
                DailyRewardView(isOpen: $openRw)
            }
        }
        .onAppear() {
            mainModel.coins = mainModel.ud.getCoins()
            mainModel.energy = mainModel.ud.getEnergy()
        }
        .alert("Not enough energy", isPresented: $showEnergyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You don't have enough energy to play this game! Come back later.")
        }
        .alert("Not enough coins", isPresented: $showCoinAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You don't have enough coins to play this game! Come back later.")
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 50 {
                        withAnimation {
                            mainModel.currentIndex = 0
                        }
                    } else if gesture.translation.width < -50 {
                        withAnimation {
                            mainModel.currentIndex = 1
                        }
                    }
                }
        )
//        .onTapGesture {
//            <#code#>
//        }
    }
}

#Preview {
    MainView()
        .environmentObject(DailyRewardViewModel())
}

extension Double {
    func roundedToTwoPlaces() -> Double {
        let multiplier = pow(10.0, 2.0)
        return (self * multiplier).rounded() / multiplier
    }
}
