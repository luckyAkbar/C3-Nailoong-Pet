//
//  ProcessPage.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI

struct ProcessPage: View {
    var progressPercentage: Float = 0
    
    var body: some View {
        ZStack {
            // Background dasar (Simulasi Kamera Feed LiDAR menggunakan token abu-abu)
            Color.blackSecondarySurface.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing:16){
                
                if progressPercentage < 100 {
                    //Loading Image
                    Image(AppIcon.moli.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                    
                    //Loading Text
                    Text("Preserving 3D model of your pet...")
                        .foregroundColor(.whitePrimarySurface)
                        .font(.title2Bold)
                    Text("Please don’t close the app while it’s working")
                        .foregroundColor(.graySecondaryText)
                    
                    //Loading Progress
                    Gauge(value: progressPercentage, in: 0...100) {
                    } currentValueLabel: {
                        Text(String(Int(progressPercentage)) + "%")
                    }
                } else {
                    //Completeed Image
                    Image(AppIcon.moli.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                    
                    //Loading Text
                    Text("Preserving 3D model of your pet...")
                        .foregroundColor(.whitePrimarySurface)
                        .font(.title2Bold)
                    Text("Your pet has been succesfully preserved and ready to interact with")
                        .foregroundColor(.graySecondaryText)
                        .multilineTextAlignment(.center)
                    
                    
                    Button(action: {

                    }) {
                        BrandButton(
                            text: "Start"
                        )
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ProcessPage(
        progressPercentage : 100
    )
}
