//
//  ContentView.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 29/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var bleController = BLEController()
    
    var body: some View {
        NavigationView{
            ZStack {
                Color("ThemeColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Text("Track your ahi with\nreal-time metrics")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.white)
                        .font(.system(size: 120))
                    
                    
                        
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("AHI")
                            .font(.system(size: 52))
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        Text("Tracker")
                            .font(.system(size: 50))
                    }
                
                    Spacer()
                    Spacer()
                
                    NavigationLink(destination: SensorsConnectionView()) {
                        MainButton(text: "Get Started")
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .environmentObject(bleController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
