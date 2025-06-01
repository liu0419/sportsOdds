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
                .font(.title3.bold())
            Text(sport.description)
                .font(.body)
                .foregroundColor(Color("RoseGold"))
            Text("Group: \(sport.group)")
                .font(.callout)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }
}
