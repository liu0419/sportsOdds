//
//  MatchRow.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/26.
//

import SwiftUI

struct MatchRow: View {
    let match: OddsResponse
    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 8) {
            if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
            }
            HStack {
                Text(match.home_team)
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("vs")
                    .foregroundColor(Color("RoseGold"))
                Text(match.away_team)
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .background(Color("LightPurple"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2.5)
        )
        .cornerRadius(12)
        .onHover { hovering in isHovering = hovering }
    }
}
