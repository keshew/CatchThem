import SwiftUI

enum SelectedShop {
    case birds
    case eggs
    case other
}

struct EggType: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var imageName: String
    var isSelected = false
    var isLocked = true
}

struct BitdType: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var imageName: String
    var isSelected = false
    var isLocked = true
}

struct ShopView: View {
    @StateObject var shopModel =  ShopViewModel()
    @Binding var openShop: Bool
    @State var selectedShop = SelectedShop.birds
    let grid = [GridItem(.flexible(minimum: 0, maximum: 85)),
                GridItem(.flexible(minimum: 0, maximum: 85)),
                GridItem(.flexible(minimum: 0, maximum: 85))]
    @State private var showAlert = false
    
    func saveSelectedEggImageName(_ imageName: String) {
        UserDefaults.standard.set(imageName, forKey: "selectedEggImageName")
    }

    func saveSelectedBirdImageName(_ imageName: String) {
        let trimmedName = String(imageName.prefix(imageName.count - 4))
        UserDefaults.standard.set(trimmedName, forKey: "selectedBirdImageName")
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Shop")
                    .font(.custom("ArchivoBlack-Regular", size: 40))
                    .foregroundStyle(LinearGradient(colors: [.white,.white, Color(red: 213/255, green: 33/255, blue: 32/255), Color(red: 213/255, green: 33/255, blue: 32/255)], startPoint: .top, endPoint: .bottom))
                
                    .outlineText(color: Color(red: 116/255, green: 0/255, blue: 0/255), width: 2)
                
                Spacer()
                
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .top) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    selectedShop = .birds
                                }
                            }) {
                                Image(selectedShop == .birds ? .selectedAction : .unselectedAction)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay {
                                        Text("BIRDS")
                                            .font(.custom("ArchivoBlack-Regular", size: selectedShop == .birds ? 18 : 18))
                                            .foregroundStyle(selectedShop == .birds ? LinearGradient(colors: [Color(red: 149/255, green: 244/255, blue: 255/255), Color(red: 40/255, green: 180/255, blue: 215/255)], startPoint: .top, endPoint: .bottom) :  LinearGradient(colors: [Color(red: 81/255, green: 207/255, blue: 255/255), Color(red: 27/255, green: 143/255, blue: 237/255)], startPoint: .top, endPoint: .bottom))
                                            .outlineText(color: Color(red: 0/255, green: 30/255, blue: 77/255), width: 1)
                                            .offset(y: -7)
                                    }
                                    .frame(width: 90, height: 90)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    selectedShop = .eggs
                                }
                            }) {
                                Image(selectedShop == .eggs ? .selectedAction : .unselectedAction)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay {
                                        Text("EGGS")
                                            .font(.custom("ArchivoBlack-Regular", size: selectedShop == .eggs ? 18 : 18))
                                            .foregroundStyle(selectedShop == .eggs ? LinearGradient(colors: [Color(red: 149/255, green: 244/255, blue: 255/255), Color(red: 40/255, green: 180/255, blue: 215/255)], startPoint: .top, endPoint: .bottom) :  LinearGradient(colors: [Color(red: 81/255, green: 207/255, blue: 255/255), Color(red: 27/255, green: 143/255, blue: 237/255)], startPoint: .top, endPoint: .bottom))
                                            .outlineText(color: Color(red: 0/255, green: 30/255, blue: 77/255), width: 1)
                                            .offset(y: -7)
                                    }
                                    .frame(width: 90, height: 90)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    selectedShop = .other
                                }
                            }) {
                                Image(selectedShop == .other ? .selectedAction : .unselectedAction)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay {
                                        Text("OTHER")
                                            .font(.custom("ArchivoBlack-Regular", size: selectedShop == .other ? 18 : 18))
                                            .foregroundStyle(selectedShop == .other ? LinearGradient(colors: [Color(red: 149/255, green: 244/255, blue: 255/255), Color(red: 40/255, green: 180/255, blue: 215/255)], startPoint: .top, endPoint: .bottom) :  LinearGradient(colors: [Color(red: 81/255, green: 207/255, blue: 255/255), Color(red: 27/255, green: 143/255, blue: 237/255)], startPoint: .top, endPoint: .bottom))
                                            .outlineText(color: Color(red: 0/255, green: 30/255, blue: 77/255), width: 1)
                                            .offset(y: -7)
                                    }
                                    .frame(width: 90, height: 90)
                            }
                        }
                        .offset(y: -50)
                        
                        VStack {
                            Image(.dwBg)
                                .resizable()
                                .overlay {
                                    switch selectedShop {
                                    case .birds:
                                        LazyVGrid(columns: grid, spacing: 10) {
                                            ForEach(0..<shopModel.arrayOfBrids.count, id: \.self) { index in
                                                Button(action: {
                                                    shopModel.selectBird(at: index)
                                                    saveSelectedBirdImageName(shopModel.arrayOfBrids[index].imageName)
                                                }) {
                                                    ZStack(alignment: .top) {
                                                        ZStack(alignment: .bottom) {
                                                            Rectangle()
                                                                .fill(shopModel.arrayOfBrids[index].isLocked ? Color(red: 106/255, green: 115/255, blue: 128/255) : Color(red: 13/255, green: 68/255, blue: 141/255))
                                                                .frame(width: 80, height: 90)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 13)
                                                                        .stroke(Color(red: 196/255, green: 255/255, blue: 113/255), lineWidth: shopModel.arrayOfBrids[index].isSelected ? 3 : 0)
                                                                }
                                                                .cornerRadius(13)
                                                            
                                                            Text(shopModel.arrayOfBrids[index].name)
                                                                .Actor(size: 12, color:  shopModel.arrayOfBrids[index].isLocked ? Color(red: 193/255, green: 193/255, blue: 193/255) : shopModel.arrayOfBrids[index].isSelected ? Color(red: 196/255, green: 255/255, blue: 113/255) : .white)
                                                                .padding(.bottom, 5)
                                                        }
                                                        
                                                        ZStack {
                                                            Image(shopModel.arrayOfBrids[index].isLocked ? .itemBack2 : .itemBack)
                                                                .resizable()
                                                                .frame(width: 77, height: 65)
                                                                .offset(y: 1.6)
                                                            
                                                            ZStack(alignment: .bottomTrailing) {
                                                                if shopModel.arrayOfBrids[index].isLocked {
                                                                    Image(shopModel.arrayOfBrids[index].imageName)
                                                                        .resizable()
                                                                        .overlay {
                                                                            Image(shopModel.arrayOfBrids[index].imageName)
                                                                                .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                                .frame(width: 45, height: 50)
                                                                                .saturation(0)
                                                                                .blendMode(.darken)
                                                                                .colorMultiply(Color(hue: 0, saturation: 1, brightness: 0))
                                                                        }
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 45, height: 50)
                                                                } else {
                                                                    Image(shopModel.arrayOfBrids[index].imageName)
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width:  45, height: 50)
                                                                        .shadow(color: Color(red: 196/255, green: 255/255, blue: 113/255), radius: shopModel.arrayOfBrids[index].isSelected ? 5 : 0)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                .disabled(shopModel.arrayOfBrids[index].isLocked)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    case .eggs:
                                        LazyVGrid(columns: grid, spacing: 10) {
                                            ForEach(0..<shopModel.arrayOfEggs.count, id: \.self) { index in
                                                Button(action: {
                                                    shopModel.selectEgg(at: index)
                                                    saveSelectedEggImageName(shopModel.arrayOfEggs[index].imageName)
                                                }) {
                                                    ZStack(alignment: .top) {
                                                        ZStack(alignment: .bottom) {
                                                            Rectangle()
                                                                .fill(shopModel.arrayOfEggs[index].isLocked ? Color(red: 106/255, green: 115/255, blue: 128/255) : Color(red: 13/255, green: 68/255, blue: 141/255))
                                                                .frame(width: 80, height: 90)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 13)
                                                                        .stroke(Color(red: 196/255, green: 255/255, blue: 113/255), lineWidth: shopModel.arrayOfEggs[index].isSelected ? 3 : 0)
                                                                }
                                                                .cornerRadius(13)
                                                            
                                                            Text(shopModel.arrayOfEggs[index].name)
                                                                .Actor(size: 12, color:  shopModel.arrayOfEggs[index].isLocked ? Color(red: 193/255, green: 193/255, blue: 193/255) : shopModel.arrayOfEggs[index].isSelected ? Color(red: 196/255, green: 255/255, blue: 113/255) : .white)
                                                                .padding(.bottom, 5)
                                                        }
                                                        
                                                        ZStack {
                                                            Image(shopModel.arrayOfEggs[index].isLocked ? .itemBack2 : .itemBack)
                                                                .resizable()
                                                                .frame(width: 77, height: 65)
                                                                .offset(y: 1.6)
                                                            
                                                            ZStack(alignment: .bottomTrailing) {
                                                                Image(shopModel.arrayOfEggs[index].isLocked ? "lockedEgg" : shopModel.arrayOfEggs[index].imageName)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width:  45, height: 50)
                                                                    .shadow(color: Color(red: 196/255, green: 255/255, blue: 113/255), radius: shopModel.arrayOfEggs[index].isSelected ? 5 : 0)
                                                            }
                                                        }
                                                    }
                                                }
                                                .disabled(shopModel.arrayOfEggs[index].isLocked)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    case .other:
                                        VStack(spacing: 10) {
                                            Rectangle()
                                                .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "coins")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.coins)
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x100")
                                                                .Archivo(size: 20, color: Color(red: 255/255, green: 245/255, blue: 140/255))
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("4.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                            
                                            Rectangle()
                                                .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "coins500")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.coins)
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x500")
                                                                .Archivo(size: 20, color: Color(red: 255/255, green: 245/255, blue: 140/255))
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("9.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                            
                                            Rectangle()
                                                .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "coins1000")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.coins)
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x1000")
                                                                .Archivo(size: 20, color: Color(red: 255/255, green: 245/255, blue: 140/255))
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("14.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                            
                                            Rectangle()
                                                .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "energy5")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.energy)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x5")
                                                                .Archivo(size: 20, color: Color(red: 131/255, green: 199/255, blue: 98/255))
                                                                .outlineTextLess(color: Color(red: 0/255, green: 144/255, blue: 5/255), width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("4.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                            
                                            Rectangle()
                                                .fill(Color(red: 0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "energy10")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.energy)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x10")
                                                                .Archivo(size: 20, color: Color(red: 131/255, green: 199/255, blue: 98/255))
                                                                .outlineTextLess(color: Color(red: 0/255, green: 144/255, blue: 5/255), width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("9.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                            
                                            Rectangle()
                                                .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                                .frame(height: 55)
                                                .overlay {
                                                    Button(action: {
                                                        shopModel.buyProduct(id: "energy15")
                                                    }) {
                                                        HStack(alignment: .bottom) {
                                                            Image(.energy)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text("x15")
                                                                .Archivo(size: 20, color: Color(red: 131/255, green: 199/255, blue: 98/255))
                                                                .outlineTextLess(color: Color(red: 0/255, green: 144/255, blue: 5/255), width: 0.6)
                                                            
                                                            Spacer()
                                                            
                                                            Text("14.99$")
                                                                .Archivo(size: 18, color: .white)
                                                                .outlineTextLess(color: .black, width: 0.6)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                                .cornerRadius(20)
                                                .shadow(radius: 3, y: 2)
                                        }
                                        .padding(.horizontal, 30)
                                        .padding(.bottom, 10)
                                    }
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 500)
                            
                            VStack {
                                HStack {
                                    Image(.coins)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    
                                    Text(selectedShop == .eggs ? "-10.000" : "-100.000")
                                        .Abel(size: 20, color: Color(red: 250/255, green: 255/255, blue: 191/255))
                                }
                                
                                Button(action: {
                                    switch selectedShop {
                                    case .birds:
                                        if UserDefaultsManager().getCoins() < 100000 {
                                            showAlert = true
                                        } else {
                                            shopModel.unlockRandomBird()
                                        }
                                    case .eggs:
                                        if UserDefaultsManager().getCoins() < 10000 {
                                            showAlert = true
                                        } else {
                                            shopModel.unlockRandomEgg()
                                        }
                                    case .other:
                                        print("other")
                                    }
                                }) {
                                    Image(.buy)
                                        .resizable()
                                        .frame(width: 220, height: 80)
                                }
                            }
                            .opacity(selectedShop == .other ? 0 : 1)
                            .disabled(selectedShop == .other)
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            openShop.toggle()
                        }
                    }) {
                        ZStack {
                            Image(.closeDw)
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .task {
            shopModel.loadProducts()
        }
        .alert("Not enough coins to unlock", isPresented: $showAlert) {
               Button("OK", role: .cancel) { }
           }
        .alert("All items are unlocked", isPresented: $shopModel.showAlert) {
               Button("OK", role: .cancel) { }
           }
    }
}

#Preview {
    ShopView(openShop: .constant(false))
}

extension View {
    func outlineText(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
    
    func outlineTextLess(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifierLess(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/1.9))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
struct StrokeModifierLess: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
