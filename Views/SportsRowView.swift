//
//  SportsListView.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/19.
//

import SwiftUI

struct SportRowView: View {
    let sport: Sport

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(sport.title)
                .font(.headline)
            Text(sport.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Group: \(sport.group)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}
