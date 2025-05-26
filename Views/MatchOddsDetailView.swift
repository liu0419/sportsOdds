//
//  DetailView.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/25.
//

import SwiftUI

struct MatchOddsDetailView: View {
    let match: OddsResponse
    
    enum SortBy {
        case none, outcome1, outcome2
    }
    
    @State private var sortBy: SortBy = .none
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 📌 Header: 比賽資訊
                VStack(spacing: 8) {
                    if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    HStack {
                        Text(match.home_team)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text("vs")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(match.away_team)
                            .font(.title2)
                            .bold()
                    }
                }
                .padding(.horizontal)
                
                // 🔀 Sort Picker
                Picker("Sort By", selection: $sortBy) {
                    Text("Default").tag(SortBy.none)
                    Text("Sort by Home").tag(SortBy.outcome1)
                    Text("Sort by Away").tag(SortBy.outcome2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // 📊 Bookmakers
                let sortedBookmakers = match.bookmakers.sorted { a, b in
                    guard let aMarket = a.markets.first,
                          let bMarket = b.markets.first,
                          aMarket.outcomes.count >= 2,
                          bMarket.outcomes.count >= 2 else {
                        return false
                    }
                    let aO1 = aMarket.outcomes[0], aO2 = aMarket.outcomes[1]
                    let bO1 = bMarket.outcomes[0], bO2 = bMarket.outcomes[1]
                    switch sortBy {
                    case .outcome1: return aO1.price > bO1.price
                    case .outcome2: return aO2.price > bO2.price
                    case .none: return false
                    }
                }
                
                ForEach(sortedBookmakers) { bookmaker in
                    if let market = bookmaker.markets.first {
                        let homeOutcome = market.outcomes.first {
                            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
                            match.home_team.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        }
                        
                        let awayOutcome = market.outcomes.first {
                            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
                            match.away_team.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(match.home_team)
                                    .font(.caption)
                                Text(String(format: "%.2f", homeOutcome?.price ?? 0))
                                    .bold()
                            }
                            Spacer()
                            Text(bookmaker.title)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(match.away_team)
                                    .font(.caption)
                                Text(String(format: "%.2f", awayOutcome?.price ?? 0))
                                    .bold()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Odds Detail")
        }
    }
}
//#Preview {
//    MatchOddsDetailView()
//}
