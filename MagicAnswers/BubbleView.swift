//
//  BubbleView.swift
//  MagicAnswers
//
//  Created by Chuck Condron on 10/30/23.
//

import SwiftUI

struct BubbleView: View {
  @State private var scale : CGFloat = 1.0
  
    var body: some View {
      ZStack {
        ForEach (1...100, id:\.self) { _ in
          Circle ()
            .foregroundColor(Color (red: 0,
                                    green: 0.1,
                                    blue: .random(in: 0.3...1)))
          
            .blendMode(.colorDodge) // The bottom circle is lightened by an amount determined by the top layer
            .animation (Animation.spring (dampingFraction: 0.5).repeatForever()
              .speed (.random(in: 0.4...1.5))
              .delay(.random (in: 0...1)), value: scale)
          
            .scaleEffect(self.scale * .random(in: 0.1...3))
            .frame(width: .random(in: 1...20),
                   height: CGFloat.random (in: 10...25),
                   alignment: .center)
            .position(CGPoint(x: .random(in: 130...280),
                              y: .random (in: 250...425)))
        }
      }
      .onAppear { self.scale = 0.5 } // default circle scale
      .drawingGroup(opaque: false, colorMode: .linear)
      .background(
        Circle()
          .stroke(.white, lineWidth: 30)
          .fill(.black)
          .frame(width: 350, height: 400))
    }//view
}

#Preview {
    BubbleView()
}
