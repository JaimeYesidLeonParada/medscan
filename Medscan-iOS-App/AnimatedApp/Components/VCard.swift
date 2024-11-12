//
//  VCard.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-14.
//
import RiveRuntime
import SwiftUI

struct VCard: View {
    @AppStorage("alertPermission") private var alertPermission = false
    @State var show = false
    @State var isLoading = false
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    
    var course: Course
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .customFont(.title3)
                    .frame(maxWidth: 170, alignment: .leading)
                    .layoutPriority(1)
                Text(course.subtitle)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(course.caption.uppercased())
                    .customFont(.footnote2)
                    .opacity(0.7)
                Spacer()
                HStack {
                    ForEach(Array([4, 5, 6].shuffled().enumerated()), id: \.offset) { index, number in
                        Image("Avatar \(number)")
                            .resizable()
                            .mask(Circle())
                            .frame(width: 44, height: 44)
                            .offset(x: CGFloat(index * -20))
                    }
                }
            }
            .foregroundColor(.white)
            .padding(30)
            .frame(width: 260, height: 310)
            .background(.linearGradient(colors: [course.color.opacity(1), course.color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: course.color.opacity(0.3), radius: 8, x: 0, y: 12)
            .shadow(color: course.color.opacity(0.3), radius: 2, x: 0, y: 1)
            .overlay(
                course.image
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(20)
            )
        
            if show {
                
                HStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Alerta")
                            .customFont(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Programar aviso cada 8 horas durante 2 semanas.")
                            .customFont(.subheadline)
                        
                        HStack(alignment: .center) {
                            
                            if alertPermission == false {
                                Button {
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                        if success {
                                            print("All set!")
                                            alertPermission = true
                                        } else if let error {
                                            print(error.localizedDescription)
                                            alertPermission = false
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "hourglass.bottomhalf.filled")
                                        Text("Solcitar")
                                            .customFont(.subheadline)
                                    }
                                    .mediumButton()
                                }
                                
                            }
                            
                        
                            Button {
                                let content = UNMutableNotificationContent()
                                content.title = "Hora de la pildora."
                                content.subtitle = "Es hora de tomar tu Medicamento 1."
                                content.sound = UNNotificationSound.default

                                // show this notification five seconds from now
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

                                // choose a random identifier
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                // add our notification request
                                UNUserNotificationCenter.current().add(request)
                                
                                isLoading = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    try? check.triggerInput("Check", stateMachineName: "State Machine 1")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    try? confetti.triggerInput("Trigger explosion", stateMachineName: "State Machine 1")
                                    withAnimation {
                                        isLoading = false
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        self.show.toggle()
                                    }
                                }
                                
                            } label: {
                                HStack {
                                    Image(systemName: "timer")
                                    Text("Programar")
                                        .customFont(.caption)
                                }
                                .largeButton()
                                
                                
                            }
                            
                            
                        }
                        .padding([ .top], 10)
                    }
                  
                    
                    Button {
                        withAnimation {
                            show.toggle()
                            isLoading = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 26, height: 26)
                            .background(.black)
                            .mask(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                    .frame(maxWidth: 26.0, maxHeight: .infinity, alignment: .topTrailing)
                    
                }
                .padding(10)
                .frame(maxWidth: 300, maxHeight: 240)
                .foregroundColor(.white)
                .background(Color(hex: "005FE7"))
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
        }
        .onTapGesture {
            show.toggle()
        }
        .overlay(
            ZStack {
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
                confetti.view()
                    .scaleEffect(3)
                    .allowsHitTesting(false)
            }
        )
        .padding()
        
    }
}

struct VCard_Previews: PreviewProvider {
    static var previews: some View {
        VCard(course: courses[1])
    }
}
