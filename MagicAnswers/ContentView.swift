//
//  ContentView.swift
//  MagicAnswers
//
//  Created by Chuck Condron on 10/28/23.
//

import SwiftUI

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

struct ContentView: View {
  
  let answers = ["It is certain", "It is decidedly so", "Without a doubt", "Yes definitely", "you may rely on it", "As I see it, yes", "Most likely", "Outlook good", "Yes", "Signs point to yes", "Reply hazy, try again", "Ask again later", "Better not tell you now", "Cannot predict now", "Concentrate and ask again", "Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Very doubtful"]
  
  @State private var answerNum = 0
  @State private var scale : CGFloat = 1
  @State private var spin = false
  @State private var angle: Double = 0
  
  @State private var opacityVal = 0.0
  
  @State private var isRunning = false
  
  @State var timeRemaining = 10
  
  @State private var timer: Timer?
  var body: some View {
    VStack {
      Text("Magic Answers")
        .foregroundStyle(.white)
        .font(.title)
        .fontWeight(.bold)
        .padding()
      ZStack {
        ZStack {
          Triangle()
            .fill(.blue)
            .frame(width: 250, height: 200)
            .offset(y: -40)
          
          Text("\(answers[answerNum])")
            .multilineTextAlignment(.center)
            .frame(width: 100)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.white)
            .font(.title2)
            .fontWeight(.bold)
            .offset(y: -10)
          
          
        }
        .opacity(opacityVal)    // << animatable
        .animation(spin ? .easeIn : .easeOut, value: spin)
        .rotation3DEffect(.degrees(spin ? 360 : 0), axis: (x: 0, y: 0, z: 1))
        .animation(.interpolatingSpring(mass: 1, stiffness: 10, damping: 1, initialVelocity: 5), value: angle)
        ForEach (1...100, id:\.self) { _ in
          Circle ()
            .foregroundColor(Color (red: 0,
                                    green: 0.1,
                                    blue: .random(in: 0.3...1)))
          
            .blendMode(.colorDodge) // The bottom circle is lightened by an amount determined by the top layer
            .animation (Animation.spring (dampingFraction: 0.5)
              .repeatForever()
              .speed (.random(in: 0.4...0.9))
              .delay(.random (in: 0...1)), value: scale
            )
          
            .scaleEffect(self.scale * .random(in: 0.1...3))
            .frame(width: .random(in: 1...20),
                   height: CGFloat.random (in:10...25),
                   alignment: .center)
            .position(CGPoint(x: .random(in: 150...270),
                              y: .random (in:200...350)))
        }
      }
      .onAppear {
        self.scale = 1.2 // default circle scale
      }
      
      .drawingGroup(opaque: false, colorMode: .linear)
      .background(
        Circle()
          .stroke(.white, lineWidth: 30)
          .fill(.black)
          .frame(width: 350, height: 400))
      .foregroundColor(.black)
      .ignoresSafeArea()
      Button("Press for your answer") {
        print("Image tapped!")
        answerNum = Int.random(in: 0...19)
        angle += 45
        spin.toggle()
        isRunning.toggle()
        if isRunning {
          startTimer()
        } else {
          stopTimer()
        }
      }
      .padding()
      .background(.blue)
      .font(.title)
      .foregroundColor(.white)
      .clipShape(Capsule())
      Spacer()
      Spacer()
    }//vstack
    .background(.black)
  }//body
 
  func startTimer() {
    opacityVal = -0.2
    timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
      if timeRemaining > 0 {
        opacityVal += 0.1
        timeRemaining -= 1
      } else {
        stopTimer()
       }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timeRemaining = 10
    isRunning = false
  }
  
}

#Preview {
  ContentView()
}
