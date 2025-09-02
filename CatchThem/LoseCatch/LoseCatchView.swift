import SwiftUI

struct LoseCatchView: View {
    @StateObject var loseCatchModel =  LoseCatchViewModel()
    @Binding var count: Int
    @EnvironmentObject var router: Router
    @ObservedObject private var soundManager = SoundManager.shared
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack {
                Image(.loseLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 110)
                
                Spacer()
                
                Image(.loseCatch)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 290, height: 160)
                
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
                                Text("\(count * 100)")
                                    .Abel(size: 26)
                                    .padding(.leading, 30)
                            }
                        
                        Image(.coins)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    UserDefaultsManager().addCoins(Double(count * 100))
                    router.pop()
                }) {
                    Image(.menuBtn)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 210, height: 80)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            soundManager.stopBackgroundMusic()
            soundManager.playLose()
        }
        .onDisappear {
            soundManager.playBackgroundMusic()
        }
    }
}

#Preview {
    LoseCatchView(count: .constant(10))
}

