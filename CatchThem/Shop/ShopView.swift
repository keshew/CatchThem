import SwiftUI

struct ShopView: View {
    @StateObject var shopModel =  ShopViewModel()
    @Binding var openShop: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Shop")
                    .font(.custom("ArchivoBlack-Regular", size: 50))
                    .foregroundStyle(LinearGradient(colors: [.white,.white, Color(red: 213/255, green: 33/255, blue: 32/255), Color(red: 213/255, green: 33/255, blue: 32/255)], startPoint: .top, endPoint: .bottom))
                
                    .outlineText(color: Color(red: 116/255, green: 0/255, blue: 0/255), width: 2)
                
                ZStack(alignment: .topTrailing) {
                    Image(.dwBg)
                        .resizable()
                        .overlay {
                            VStack(spacing: 10) {
                                Rectangle()
                                    .fill(Color(red:  0/255, green: 173/255, blue: 216/255))
                                    .frame(height: 60)
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
                                    .frame(height: 60)
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
                                    .frame(height: 60)
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
                                    .frame(height: 60)
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
                                    .frame(height: 60)
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
                                    .frame(height: 60)
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
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 550)
                    
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
