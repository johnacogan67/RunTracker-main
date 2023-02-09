//
//  CustomViews.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 09/12/2021.
//

import SwiftUI

struct MainButton: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 2)
                    .background(Color.white.cornerRadius(25))
            )
    }
}

struct ConnectionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct SensorDataView: View {
    
    var imageName: String
    var dataName: String
    var dataValue: UInt32
    var dataUnit: String
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: 32)
            Text(dataName)
                .textCase(.uppercase)
                .font(.title3)
                .frame(width: 196, alignment: .leading)
            Text(String(dataValue) + " " + dataUnit)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 80)
                .padding(8)
        }
    }
}

struct SensorConnectView: View {
    
    var imageName: String
    var dataName: String
    var buttonText: String
    var buttonAction: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: 32)
            Text(dataName)
                .textCase(.uppercase)
                .foregroundColor(.white)
                .font(.title3)
                .frame(width: 196, alignment: .leading)
            Button(buttonText) {
                buttonAction()
            }
            .buttonStyle(ConnectionButton())
        }
    }
}

