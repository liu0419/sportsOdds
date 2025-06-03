//
//  SplashView.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/6/3.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image(systemName: "sportscourt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("RoseGold"))
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.scale = 1.0
                            self.opacity = 1.0
                        }
                    }

                Text("SPORTS ODDS")
                    .font(.title)
                    .foregroundColor(Color("RoseGold"))
                    .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("DarkPurple"))
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

//#Preview {
//    SplashView()
//}
