//
//  ContentView.swift
//  Apex Legends Pinger
//
//  Created by David Paez on 3/13/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var hostName = "Hello World!"
    @State var durationText = "Duration: "
    @State var progress : CGFloat = 0
    let colors = [Color("Aqua"), Color("Teal")]
    
    var body: some View {
        
        VStack()
        {
            Text(hostName)
            Button("Click Here", action: doSomething)
            Text(durationText)
        }
        .padding(.bottom, 50)
        
        VStack
        {
            Meter(progress: self.$progress)
            
            HStack(spacing: 25){
                
                Button(action: {
                    
                    withAnimation(Animation.default.speed(0.55)){
                        
                        self.progress += 10
                        
                    }
                    
                }) {
                    
                    Text("Update")
                        .padding(.vertical,10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }
                .background(Capsule().stroke(LinearGradient(gradient: .init(colors: self.colors), startPoint: .leading, endPoint: .trailing), lineWidth: 2))
                
                
                Button(action: {
                    
                    withAnimation(Animation.default.speed(0.55)){
                        
                        self.progress = 0
                    }
                    
                }) {
                    
                    Text("Reset")
                        .padding(.vertical,10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }
                .background(Capsule().stroke(LinearGradient(gradient: .init(colors: self.colors), startPoint: .leading, endPoint: .trailing), lineWidth: 2))
            }
            .padding(.top, 55)
        }
    }
    
    func doSomething()
    {
        print("Hello David!");
        hostName = "www.google.com";
        
        // Ping once
        let once = try? SwiftyPing(host: hostName, configuration: PingConfiguration(interval: 0.2, with: 5), queue: DispatchQueue.global())
        once?.observer = { (response) in
            let durationInMs = response.duration * 1000
            print(durationInMs)
            durationText = "Duration: " + String(durationInMs)
            withAnimation(Animation.default.speed(0.15))
            {
                self.progress = durationInMs
            }
        }
        once?.targetCount = 100
        try? once?.startPinging()
    }
}

struct Meter: View
{
    let colors = [Color("Aqua"), Color("Teal")]
    @Binding var progress : CGFloat
    
    var body: some View {
         ZStack()
        {
            ZStack()
            {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.black.opacity((0.1)), lineWidth: 55)
                    .frame(width: 280, height: 280)
                
                Circle()
                    .trim(from: 0, to: self.setProgress())
                    .stroke(AngularGradient(gradient:.init(colors:self.colors), center:.center, angle: .init(degrees: 180)), lineWidth: 55)
                    .frame(width: 280, height: 280)
            }
            .rotationEffect(.init(degrees: 180))
            
            ZStack(alignment: .bottom) {
                
                self.colors[0]
                .frame(width: 2, height: 95)
                
                Circle()
                    .fill(self.colors[0])
                    .frame(width: 15, height: 15)
            }
            .offset(y: -35)
            .rotationEffect(.init(degrees: -90))
            .rotationEffect(.init(degrees: self.setArrow()))
        }
        .padding(.bottom, -20)
    }
    
    func setProgress()->CGFloat{
        
        let temp = self.progress / 2
        return temp * 0.01
    }
    
    func setArrow()->Double{
        
        let temp = self.progress / 100
        return Double(temp * 180)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
