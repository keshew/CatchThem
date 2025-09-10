import SwiftUI

struct FactsModel: Identifiable {
    var id = UUID().uuidString
    var birdName: String
    var fact: [Fact]
}

struct Fact {
    var title: String
    var desc: String
}

struct FunFactsView: View {
    @StateObject var funFactsModel =  FunFactsViewModel()
    @State var currentIndex = 0
    @State var isRead = false
    @State var selectedFact = FactsModel(birdName: "", fact: [Fact(title: "", desc: "")])
    @State var indexOfFact = 0
    @Environment(\.presentationMode) var presentationMode
    
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
                    Text("FUN FACTS")
                        .font(.custom("ArchivoBlack-Regular", size: 50))
                        .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 150/255, blue: 44/255), Color(red: 255/255, green: 150/255, blue: 44/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 178/255, green: 62/255, blue: 1/255), width: 2)
                    
                    Text(funFactsModel.contact.facts[currentIndex].birdName)
                        .font(.custom("ArchivoBlack-Regular", size: 30))
                        .foregroundStyle(LinearGradient(colors: [.white, .white, Color(red: 125/255, green: 177/255, blue: 255/255), Color(red: 125/255, green: 177/255, blue: 255/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 2/255, green: 60/255, blue: 126/255), width: 2)
                }
                
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                        ForEach(0..<funFactsModel.contact.facts[currentIndex].fact.count, id: \.self) { index in
                            let fact = funFactsModel.contact.facts[currentIndex].fact[index]
                            ZStack {
                                Image(.shadow)
                                    .resizable()
                                    .frame(height: 20)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(index + 1). \(fact.title)")
                                            .Actor(size: 16)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        selectedFact = funFactsModel.contact.facts[currentIndex]
                                        indexOfFact = index
                                        isRead = true
                                    }) {
                                        Image(.read)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 45, height: 20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 3) {
                    ForEach(0..<12, id: \.self) { index in
                        Rectangle()
                            .fill(currentIndex == index ? Color(red: 170/255, green: 235/255, blue: 255/255) : Color(red: 17/255, green: 39/255, blue: 118/255))
                            .frame(width: 15, height: 8)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 50 {
                        withAnimation {
                            if currentIndex >= 1 {
                                currentIndex -= 1
                            }
                        }
                    } else if gesture.translation.width < -50 {
                        withAnimation {
                            if currentIndex <= 10 {
                                currentIndex += 1
                            }
                        }
                    }
                }
        )
        .fullScreenCover(isPresented: $isRead) {
            FactBirdView(model: $selectedFact, index: $indexOfFact)
        }
    }
}

struct FactBirdView: View {
    @Binding var model: FactsModel
    @Binding var index: Int
    @Environment(\.presentationMode) var presentationMode
    
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
                    Text("FUN FACTS")
                        .font(.custom("ArchivoBlack-Regular", size: 50))
                        .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 245/255, blue: 142/255), Color(red: 255/255, green: 150/255, blue: 44/255), Color(red: 255/255, green: 150/255, blue: 44/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 178/255, green: 62/255, blue: 1/255), width: 2)
                    
                    Text("\(index + 1). \(model.fact[index].title)")
                        .font(.custom("ArchivoBlack-Regular", size: 30))
                        .foregroundStyle(LinearGradient(colors: [.white, .white, Color(red: 125/255, green: 177/255, blue: 255/255), Color(red: 125/255, green: 177/255, blue: 255/255)], startPoint: .top, endPoint: .bottom))
                        .outlineText(color: Color(red: 2/255, green: 60/255, blue: 126/255), width: 2)
                }
                
                ScrollView(showsIndicators: false) {
                    Text("\(model.fact[index].desc)")
                        .Actor(size: 25)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                HStack(spacing: 3) {
                    ForEach(0..<10, id: \.self) { index in
                        Rectangle()
                            .fill(self.index == index ? Color(red: 170/255, green: 235/255, blue: 255/255) : Color(red: 17/255, green: 39/255, blue: 118/255))
                            .frame(width: 15, height: 8)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 50 {
                        withAnimation {
                            if index >= 1 {
                                index -= 1
                            }
                        }
                    } else if gesture.translation.width < -50 {
                        withAnimation {
                            if index <= 8 {
                                index += 1
                            }
                        }
                    }
                }
        )
    }
}

#Preview {
    FunFactsView()
}
