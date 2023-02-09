//
//  SensorsDataView.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 05/12/2021.
//

import SwiftUI

struct SensorsDataView: View {
    
    @EnvironmentObject var bleController: BLEController
    
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
                
//                SensorDataView(imageName: "figure.walk", dataName: "Running Speed", dataValue: UInt16(bleController.runningSpeed), dataUnit: "m/s")
                SensorDataView(imageName: "lungs", dataName: "IR", dataValue: UInt32(bleController.heartRate), dataUnit: "")
                SensorDataView(imageName: "lungs", dataName: "Red", dataValue: UInt32(bleController.heartRate2), dataUnit: "")//                SensorDataView(imageName: "thermometer.sun.fill", dataName: "Temperature", dataValue: UInt16(bleController.temperature), dataUnit: "C")
                
                Spacer()
                       
                Button(action: {
                    bleController.disconnectAllSensors()
                    
                }) {
                    MainButton(text: "End Session")
                }
                       
                
                Spacer()
            }
        }
        .navigationTitle("Active Session")
    }
}

struct SensorsDataView_Previews: PreviewProvider {
    static var previews: some View {
        SensorsDataView()
    }
}
