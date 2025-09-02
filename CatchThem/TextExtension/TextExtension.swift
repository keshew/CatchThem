import SwiftUI

extension Text {
    func Abel(size: CGFloat,
              color: Color = .white)  -> some View {
        self.font(.custom("Abel-Regular", size: size))
            .foregroundColor(color)
    }
    
    func Actor(size: CGFloat,
               color: Color = .white)  -> some View {
        self.font(.custom("Actor-Regular", size: size))
            .foregroundColor(color)
    }
    
    func Archivo(size: CGFloat,
                 color: Color = .white)  -> some View {
        self.font(.custom("ArchivoBlack-Regular", size: size))
            .foregroundColor(color)
    }
}
