import SwiftUI

struct Reward: Codable {
    var item: Item
    var count: Count
    var isInfinityTime: Bool?
    var isGot: Bool = false
}

enum Item: Codable {
    case coins
    case energy
}

enum Count: Int, Codable {
    case one = 1
    case five = 5
    case ten = 10
    case fifteen = 15
    case twenty = 20
    case twentyFive = 25
    case thirty = 30
    case thirtyFive = 35
    case forty = 40
    case eighty = 80
    case eightyFive = 85
    case ninety = 90
    case oneHundredEighty = 180
    case oneHundredEightyFive = 185
    case hour = 60
}

struct DailyRewardView: View {
    @StateObject var dailyRewardModel =  DailyRewardViewModel()
    @Binding var isOpen: Bool
    @ObservedObject private var soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(.dailyRewardLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 90)
                
                ZStack(alignment: .topTrailing) {
                    Image(.dwBg)
                        .resizable()
                        .overlay {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: -50), GridItem(.flexible(), spacing: -50), GridItem(.flexible(), spacing: -50), GridItem(.flexible(), spacing: -50)]) {
                                ForEach(0..<dailyRewardModel.rewards.count, id: \.self) { index in
                                    if dailyRewardModel.rewards[index].isGot {
                                        Button(action: {
                                            dailyRewardModel.getReward(at: index)
                                            soundManager.playBtnSound()
                                        }) {
                                            ZStack(alignment: .top) {
                                                ZStack(alignment: .bottom) {
                                                    Rectangle()
                                                        .fill(Color(red: 13/255, green: 68/255, blue: 141/255))
                                                        .frame(width: 64, height: 70)
                                                        .cornerRadius(10)
                                                    
                                                    HStack(spacing: dailyRewardModel.rewards[index].isInfinityTime == true ? 1 : 3) {
                                                        Text("+\(dailyRewardModel.rewards[index].count.rawValue)")
                                                            .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        
                                                        if dailyRewardModel.rewards[index].isInfinityTime == true {
                                                            Text("min")
                                                                .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        }
                                                        
                                                        Text("\(dailyRewardModel.rewards[index].item)")
                                                            .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        
                                                    }
                                                    .padding(.bottom, 3)
                                                }
                                                
                                                ZStack {
                                                    Image(.itemBack)
                                                        .resizable()
                                                        .frame(width: 64, height: 50)
                                                    
                                                    ZStack(alignment: .bottomTrailing) {
                                                        Image("\(dailyRewardModel.rewards[index].item)")
                                                            .resizable()
                                                            .frame(width: dailyRewardModel.rewards[index].item == .energy ? 25 : 30, height: 30)
                                                        
                                                        
                                                            Image(.got)
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                                .offset(x: 5, y: 5)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        .disabled(true)
                                    } else if dailyRewardModel.canClaimReward(at: index) {
                                        Button(action: {
                                            dailyRewardModel.getReward(at: index)
                                        }) {
                                            ZStack(alignment: .top) {
                                                ZStack(alignment: .bottom) {
                                                    Rectangle()
                                                        .fill(Color(red: 13/255, green: 68/255, blue: 141/255))
                                                        .frame(width: 64, height: 70)
                                                        .cornerRadius(10)
                                                    
                                                    HStack(spacing: dailyRewardModel.rewards[index].isInfinityTime == true ? 1 : 3) {
                                                        Text("+\(dailyRewardModel.rewards[index].count.rawValue)")
                                                            .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        
                                                        if dailyRewardModel.rewards[index].isInfinityTime == true {
                                                            Text("min")
                                                                .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        }
                                                        
                                                        Text("\(dailyRewardModel.rewards[index].item)")
                                                            .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                        
                                                    }
                                                    .padding(.bottom, 3)
                                                }
                                                
                                                ZStack {
                                                    Image(.itemBack)
                                                        .resizable()
                                                        .frame(width: 64, height: 50)
                                                    
                                                    ZStack(alignment: .bottomTrailing) {
                                                        Image("\(dailyRewardModel.rewards[index].item)")
                                                            .resizable()
                                                            .frame(width: dailyRewardModel.rewards[index].item == .energy ? 25 : 30, height: 30)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        ZStack(alignment: .top) {
                                            ZStack(alignment: .bottom) {
                                                Rectangle()
                                                    .fill(Color(red: 106/255, green: 115/255, blue: 128/255))
                                                    .frame(width: 64, height: 70)
                                                    .cornerRadius(10)
                                                
                                                HStack(spacing: dailyRewardModel.rewards[index].isInfinityTime == true ? 1 : 3) {
                                                    Text("+\(dailyRewardModel.rewards[index].count.rawValue)")
                                                        .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                    
                                                    if dailyRewardModel.rewards[index].isInfinityTime == true {
                                                        Text("min")
                                                            .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                    }
                                                    
                                                    Text("\(dailyRewardModel.rewards[index].item)")
                                                        .Actor(size: dailyRewardModel.rewards[index].isInfinityTime == true ? 9 : 11)
                                                    
                                                }
                                                .padding(.bottom, 3)
                                            }
                                            
                                            ZStack {
                                                Image(.itemBack2)
                                                    .resizable()
                                                    .frame(width: 64, height: 50)
                                                
                                                Image("\(dailyRewardModel.rewards[index].item)2")
                                                    .resizable()
                                                    .frame(width: dailyRewardModel.rewards[index].item == .energy ? 25 : 30, height: 30)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 500)
                    
                    Button(action: {
                        withAnimation {
                            isOpen.toggle()
                            soundManager.playBtnSound()
                        }
                    }) {
                        Image(.closeDw)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    DailyRewardView(isOpen: .constant(false))
}

