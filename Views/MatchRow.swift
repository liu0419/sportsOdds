//
//  MatchRow.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/26.
//

import SwiftUI

struct MatchRow: View {
    let match: OddsResponse

    var body: some View {
        VStack(spacing: 8) {
            if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                Text(match.home_team)
                    .font(.headline).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("vs")
                    .foregroundColor(.gray)
                Text(match.away_team)
                    .font(.headline).bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
