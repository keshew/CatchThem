import SwiftUI

struct Setup {
    var name: String
    var countOfEnergy: Int
    var isOn = false
}

struct TrialsSetupView: View {
    @StateObject var trialsSetupModel =  TrialsSetupViewModel()
    @State var arrayOfTasks = [Setup(name: "Regular game", countOfEnergy: 0, isOn: true), Setup(name: "Catch only golden eggs", countOfEnergy: 1), Setup(name: "High-speed eggs", countOfEnergy: 2),
                               Setup(name: "High complexity - High reward", countOfEnergy: 3), Setup(name: "10 eggs - x2 coins", countOfEnergy: 4), Setup(name: "1,000 eggs - 1 skin", countOfEnergy: 5),
                               Setup(name: "Only from the bottom shelves", countOfEnergy: 6), Setup(name: "Only from the middle shelves", countOfEnergy: 7), Setup(name: "Only from the top shelves", countOfEnergy: 8)]
    @ObservedObject private var soundManager = SoundManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State var isPlay = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 99/255, green: 159/255, blue: 191/255),
                                    Color(red: 32/255, green: 76/255, blue: 133/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(.closeDw)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 0) {
                    Text("CATCH THEM!")
                        .font(.custom("ArchivoBlack-Regular", size: 45))
                        .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 150/255, blue: 44/255), Color(red: 255/255, green: 150/255, blue: 44/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 178/255, green: 62/255, blue: 1/255), width: 2)
                    
                    Text("TRIALS SETUP")
                        .font(.custom("ArchivoBlack-Regular", size: 30))
                        .foregroundStyle(LinearGradient(colors: [.white, .white, Color(red: 125/255, green: 177/255, blue: 255/255), Color(red: 125/255, green: 177/255, blue: 255/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 2/255, green: 60/255, blue: 126/255), width: 2)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        ForEach(0..<arrayOfTasks.count, id: \.self) { index in
                            ZStack {
                                Image(.shadow)
                                    .resizable()
                                    .frame(height: 20)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(arrayOfTasks[index].name)
                                            .Actor(size: 16)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(.energy)
                                        .resizable()
                                        .frame(width: 10, height: 15)
                                    
                                    Text("-\(arrayOfTasks[index].countOfEnergy)")
                                        .Abel(size: 12)
                                    
                                    Toggle("", isOn: Binding(
                                        get: { arrayOfTasks[index].isOn },
                                        set: { newValue in
                                            if newValue {
                                                for i in arrayOfTasks.indices {
                                                    arrayOfTasks[i].isOn = (i == index)
                                                }
                                            } else {
                                                arrayOfTasks[index].isOn = false
                                            }
                                        }
                                    ))
                                    .toggleStyle(CustomToggleStyle())
                                }
                            }
                            .opacity(arrayOfTasks[index].isOn ? 1 : 0.5)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Button(action: {
                    isPlay = true
                    soundManager.playPlayTap()
                }) {
                    Image(.play)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: 90)
                }
            }
        }
        .fullScreenCover(isPresented: $isPlay) {
            if let index = arrayOfTasks.firstIndex(where: { $0.isOn }) {
                CatchGameView(setup: $arrayOfTasks[index])
            } else {
                Text("No selection")
            }
        }
    }
}

#Preview {
    TrialsSetupView()
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0/255, green: 43/255, blue: 134/255))
                .frame(width: 45, height: 23)
                .overlay(
                    Image(configuration.isOn ? .on : .off)
                        .resizable()
                        .overlay {
                            Text(configuration.isOn ? "l" : "0")
                                .Abel(size: 15, color: configuration.isOn ? Color(red: 0/255, green: 106/255, blue: 62/255) : Color(red: 76/255, green: 76/255, blue: 76/255))
                        }
                        .frame(width: 24, height: 23)
                        .offset(x: configuration.isOn ? 10 : -11)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
