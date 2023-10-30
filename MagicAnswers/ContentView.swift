//
//  ContentView.swift
//  MagicAnswers
//
//  Created by Chuck Condron on 10/28/23.
//

import SwiftUI

// The notification we'll send when a shake gesture happens.
extension UIDevice {
  static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
  }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      .onAppear()
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
        action()
      }
  }
}

// A View extension to make the modifier easier to use.
extension View {
  func onShake(perform action: @escaping () -> Void) -> some View {
    self.modifier(DeviceShakeViewModifier(action: action))
  }
}

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
  //@State private var scale : CGFloat = 1.0
  @State private var spin = false
  @State private var angle: Double = 0
  
  @State private var opacityVal = 0.8
  
  @State private var isRunning = false
  
  @State private var isAnimated = false
  
  @State var timeRemaining = 8
  
  @State private var timer: Timer?
  
  @State private var feedback = UIImpactFeedbackGenerator(style: .heavy)
  
  var body: some View {
    VStack {
      Text("Magic Answers")
        .foregroundStyle(.white)
        .font(.title)
        .fontWeight(.bold)
        .padding()
      ZStack {
        BubbleView()
        ZStack {
          Triangle()
            .fill(.blue)
            .frame(width: 250, height: 200)
            .offset(y: -40)
          
          Text("\(answers[answerNum])")
            .frame(width: 100)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.white)
            .font(.title2)
            .fontWeight(.bold)
            .offset(y: -10)
        }
        .opacity(opacityVal)
        .rotation3DEffect(.degrees(spin ? 360 : 0), axis: (x: 0, y: 0, z: 1))
        .animation(.interpolatingSpring(mass: 1, stiffness: 5, damping: 2, initialVelocity: 6), value: angle)
 
        .onShake {
          animateAnswer()
          feedback.impactOccurred()
          print("Phone was shaken...")
        }
      }//vstack
      Button("Press for your answer") {
        print("Button tapped!")
        animateAnswer()
      }
      .padding()
      .background(.blue)
      .font(.title)
      .foregroundColor(.white)
      .clipShape(Capsule())
      Spacer()
      Spacer()
    }//body
    .background(.black)
  }//added
  
  func animateAnswer() {
    angle += 45
    spin.toggle()
    withAnimation {
      isAnimated = true
      opacityVal = 0
      answerNum = Int.random(in: 0...19)
      withAnimation(.easeInOut(duration: 5)) {
        feedback.impactOccurred()
        isAnimated = false
        opacityVal = 0.8
      }
    }
  }
  
}

#Preview {
  ContentView()
}
