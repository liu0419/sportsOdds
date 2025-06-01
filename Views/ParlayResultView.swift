//
//  ParlayResultView.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/26.
//

import SwiftUI

struct ParlayResultView: View {
    let selections: [String: String]
    let matches: [OddsResponse]
    
    var body: some View {
        ZStack {
            // 🔧 背景設為 lightpurple
            Color("LightPurple")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Text("📊 串關賠率比較")
                    .font(.title2)
                    .bold()
                
                if selections.count < 2 {
                    Text("請至少選擇兩場比賽")
                        .foregroundColor(.red)
                } else {
                    let results = ParlayCalculator.calculate(from: matches, selections: selections)
                    
                    if results.isEmpty {
                        Text("🚫 此組合無任何 bookmaker 可串關")
                            .foregroundColor(.red)
                    } else {
                        ForEach(results.sorted(by: { $0.odds > $1.odds }), id: \.bookmaker.key) { item in
                            HStack {
                                Text(item.bookmaker.title)
                                Spacer()
                                Text(String(format: "%.2f", item.odds))
                                    .bold()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
