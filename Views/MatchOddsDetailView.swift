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
                if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                    Text(date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                HStack(alignment: .top, spacing: 16) {
                    VStack {
                        ForEach(match.home_team.split(separator: " "), id: \.self) { word in
                            Text(String(word))
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("vs")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.black.opacity(0.2)))
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .padding(.top, 8)
                    }
                    Spacer()
                    VStack {
                        ForEach(match.away_team.split(separator: " "), id: \.self) { word in
                            Text(String(word))
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 🔀 Sort Button Group (Custom Style)
                HStack(spacing: 12) {
                    ForEach([SortBy.none, SortBy.outcome1, SortBy.outcome2], id: \.self) { option in
                        let label: String = {
                            switch option {
                            case .none: return "Default"
                            case .outcome1: return "Sort by Home"
                            case .outcome2: return "Sort by Away"
                            }
                        }()
                        
                        Button(action: {
                            sortBy = option
                        }) {
                            Text(label)
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(sortBy == option ? Color("WimbledonBackground").opacity(0.3) : Color.clear)
                                .foregroundColor(Color("RoseGold"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("RoseGold"), lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
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
                                    .font(.footnote)
                                    .foregroundColor(Color("RoseGold"))
                                    .bold()
                                Text(String(format: "%.2f", homeOutcome?.price ?? 0))
                                    .bold()
                                    .foregroundColor(Color("RoseGold"))
                                
                            }
                            Spacer()
                            Text(bookmaker.title)
                                .font(.footnote)
                                .foregroundColor(Color("RoseGold"))
                                .bold()
                            
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(match.away_team)
                                    .font(.footnote)
                                    .foregroundColor(Color("RoseGold"))
                                    .bold()
                                Text(String(format: "%.2f", awayOutcome?.price ?? 0))
                                    .bold()
                                    .foregroundColor(Color("RoseGold"))
                            }
                        }
                        .padding()
                        .background(Color("WimbledonBackground").opacity(0.3))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("RoseGold"), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Odds Detail")
        }
        .padding(.top)
        .background(Color("DarkPurple"))
    }
}
#Preview {
    MatchOddsDetailView(match: OddsResponse(
        id: "match1",
        sport_title: "ATP Tennis",
        commence_time: "2025-06-05T15:00:00Z",
        home_team: "Carlos Alcaraz",
        away_team: "Novak Djokovic",
        bookmakers: [
            Bookmaker(
                key: "bet365",
                title: "Bet365",
                last_update: "2025-06-03T10:00:00Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Carlos Alcaraz", price: 1.85, link: nil),
                            Outcome(name: "Novak Djokovic", price: 1.95, link: nil)
                        ]
                    )
                ]
            ),
            Bookmaker(
                key: "williamhill",
                title: "William Hill",
                last_update: "2025-06-03T10:05:00Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Carlos Alcaraz", price: 1.80, link: nil),
                            Outcome(name: "Novak Djokovic", price: 2.00, link: nil)
                        ]
                    )
                ]
            ),
            Bookmaker(
                key: "unibet",
                title: "Unibet",
                last_update: "2025-06-03T10:10:00Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Carlos Alcaraz", price: 1.90, link: nil),
                            Outcome(name: "Novak Djokovic", price: 1.90, link: nil)
                        ]
                    )
                ]
            ),
            Bookmaker(
                key: "pinnacle",
                title: "Pinnacle",
                last_update: "2025-06-03T10:15:00Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Carlos Alcaraz", price: 1.95, link: nil),
                            Outcome(name: "Novak Djokovic", price: 1.85, link: nil)
                        ]
                    )
                ]
            ),
            Bookmaker(
                key: "draftkings",
                title: "DraftKings",
                last_update: "2025-06-03T10:20:00Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Carlos Alcaraz", price: 2.00, link: nil),
                            Outcome(name: "Novak Djokovic", price: 1.80, link: nil)
                        ]
                    )
                ]
            )
        ]
    ))
}
