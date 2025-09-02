import SwiftUI

struct WinRunView: View {
    @StateObject var winRunModel =  WinRunViewModel()
    @Binding var reward: Double
    @EnvironmentObject var router: Router
    @State var again = false
    @ObservedObject private var soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        router.pop()
                    }) {
                        Image(.backBtn)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                
                Image(.winLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 110)
                
                Spacer()
                
                ZStack {
                    Image(.layer1)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 310, height: 300)
                        .opacity(0.4)
                    
                    Image(.layer2)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 310, height: 300)
                    
                    Image(.win)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 290, height: 290)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("Reward:")
                        .Abel(size: 20)
                        
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: 190, height: 50)
                            .opacity(0.6)
                            .cornerRadius(30)
                            .overlay {
                                Text("\(reward)")
                                    .Abel(size: 20)
                                    .padding(.leading, 35)
                            }
                        
                        Image(.coins)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    again = true
                }) {
                    Image(.againBtn)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 210, height: 80)
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $again) {
            RunGameView()
        }
        .onAppear {
            UserDefaultsManager().addCoins(reward)
            soundManager.stopBackgroundMusic()
            soundManager.playWinMusic()
        }
        
        .onDisappear() {
            soundManager.playBackgroundMusic()
        }
    }
}

#Preview {
    WinRunView(reward: .constant(10))
}

