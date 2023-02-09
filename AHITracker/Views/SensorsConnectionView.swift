//
//  SensorsConnectionView.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 05/12/2021.
//

import SwiftUI

struct SensorsConnectionView: View {
    
    @EnvironmentObject var bleController: BLEController
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ZStack {
            Color("ThemeColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.white)
                    .font(.system(size: 120))
                
                Spacer()
                
                Text("Connect to the sensors before bed")
                    .foregroundColor(.white)
                
//                SensorConnectView(
//                    imageName: "figure.walk",
//                    dataName: "Running Speed",
//                    buttonText: bleController.sensorConnectionStatus(type: .speed) ? "Disconnect" : "Connect") {
//                        sensorsButtonAction(sensorType: .speed)
//                    }
                
                SensorConnectView(
                    imageName: "lungs",
                    dataName: "SpO2",
                    buttonText: bleController.sensorConnectionStatus(type: .heart) ? "Disconnect" : "Connect") {
                        sensorsButtonAction(sensorType: .heart)
                    }
                
//                SensorConnectView(
//                    imageName: "thermometer.sun.fill",
//                    dataName: "Temperature",
//                    buttonText: bleController.sensorConnectionStatus(type: .environment) ? "Disconnect" : "Connect") {
//                        sensorsButtonAction(sensorType: .environment)
//                    }
                
                Spacer()
                
                NavigationLink(destination: SensorsDataView()) {
                    MainButton(text: "Let's Go")
                }
                
                Spacer()
            }
        }
        .navigationBarTitle("Configuration", displayMode: .large)

    }
    
    func sensorsButtonAction(sensorType: RTSensorType) {
        if bleController.sensorConnectionStatus(type: sensorType) {
            bleController.disconnectFromSensor(type: sensorType)
        }
        else {
            bleController.connectToSensor(type: sensorType)
        }
    }
}

struct SensorsConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SensorsConnectionView()
    }
}
