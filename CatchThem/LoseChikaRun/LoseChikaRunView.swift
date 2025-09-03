import SwiftUI

struct LoseChikaRunView: View {
    @EnvironmentObject var router: Router
    @State var again = false
    @Binding var reward: Double
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
                
                Image(.loseLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 110)
                
                Spacer()
                
                Image(.loseRun)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 290, height: 160)
                
                Spacer()
                
                Button(action: {
                    if UserDefaultsManager().getCoins() > 0 {
                        again = true
                    } else {
                        router.pop()
                    }
                }) {
                    Image(.againBtn)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 210, height: 80)
                }
            }
            .padding(.vertical)
        }
        .onAppear() {
            UserDefaultsManager().minusCoins(reward)
            soundManager.stopBackgroundMusic()
            soundManager.playLose()
            
        }
        .onDisappear {
            soundManager.playBackgroundMusic()
        }
        .fullScreenCover(isPresented: $again) {
            RunGameView()
        }
    }
}

#Preview {
    LoseChikaRunView(reward: .constant(0))
}

