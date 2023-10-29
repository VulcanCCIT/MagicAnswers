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
  @State private var scale : CGFloat = 1
  @State private var spin = false
  @State private var angle: Double = 0
  
  @State private var opacityVal = 0.7
  
  @State private var isRunning = false
  
  @State var timeRemaining = 8
  
  @State private var timer: Timer?
  
  @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)
  
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
            .frame(width: 100)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.white)
            .font(.title2)
            .fontWeight(.bold)
            .offset(y: -10)
         }
        .opacity(opacityVal)
        .animation(spin ? .easeIn : .easeOut, value: spin)
        .rotation3DEffect(.degrees(spin ? 360 : 0), axis: (x: 0, y: 0, z: 1))
        .animation(.interpolatingSpring(mass: 1, stiffness: 5, damping: 2, initialVelocity: 6), value: angle)
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
                   height: CGFloat.random (in: 10...25),
                   alignment: .center)
            .position(CGPoint(x: .random(in: 150...270),
                              y: .random (in: 250...425)))
        }
      }
      .onAppear {
        self.scale = 0.5 // default circle scale
      }
      
      .drawingGroup(opaque: false, colorMode: .linear)
      .background(
        Circle()
          .stroke(.white, lineWidth: 30)
          .fill(.black)
          .frame(width: 350, height: 400))
      .foregroundColor(.black)
      .ignoresSafeArea()
      .onShake {
      feedback.impactOccurred()
       print("Phone was shaken...")
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
    opacityVal = -0.5
    timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
      if timeRemaining > 0 {
        feedback.impactOccurred()
        opacityVal += 0.17
        timeRemaining -= 1
      } else {
        stopTimer()
        //opacityVal = 0.7
       }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timeRemaining = 8
    isRunning = false
  }
  
}

#Preview {
  ContentView()
}
