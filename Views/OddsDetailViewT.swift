import SwiftUI

struct OddsDetailViewT: View {
    let sport: Sport

    @State private var odds: [OddsResponse] = [
        OddsResponse(
            id: "6186c58f73be7feaea5a268a1c6cf519",
            sport_title: "MLB",
            commence_time: "2025-05-20T02:07:41Z",
            home_team: "Oakland Athletics",
            away_team: "Los Angeles Angels",
            bookmakers: [
                Bookmaker(
                    key: "fanduel",
                    title: "FanDuel",
                    last_update: "2025-05-20T04:33:16Z",
                    link: "https://sportsbook.fanduel.com/baseball/mlb/los-angeles-angels-%28j-soriano%29-%40-athletics-%28j-ginn%29-34333728",
                    markets: [
                        Market(
                            key: "h2h",
                            outcomes: [
                                Outcome(
                                    name: "Los Angeles Angels",
                                    price: 1.38,
                                    link: "https://sportsbook.fanduel.com/addToBetslip?marketId=42.505286286&selectionId=1093236"
                                ),
                                Outcome(
                                    name: "Oakland Athletics",
                                    price: 2.96,
                                    link: "https://sportsbook.fanduel.com/addToBetslip?marketId=42.505286286&selectionId=75117758"
                                )
                            ]
                        )
                    ]
                ),
                Bookmaker(
                    key: "draftkings",
                    title: "DraftKings",
                    last_update: "2025-05-20T04:31:37Z",
                    link: "https://sportsbook.draftkings.com/event/32314652",
                    markets: [
                        Market(
                            key: "h2h",
                            outcomes: [
                                Outcome(
                                    name: "Los Angeles Angels",
                                    price: 1.43,
                                    link: "https://sportsbook.draftkings.com/event/32314652?outcomes=0ML80000687_3"
                                ),
                                Outcome(
                                    name: "Oakland Athletics",
                                    price: 2.75,
                                    link: "https://sportsbook.draftkings.com/event/32314652?outcomes=0ML80000687_1"
                                )
                            ]
                        )
                    ]
                ),
                Bookmaker(
                    key: "mybookieag",
                    title: "MyBookie.ag",
                    last_update: "2025-05-20T04:32:09Z",
                    link: nil,
                    markets: [
                        Market(
                            key: "h2h",
                            outcomes: [
                                Outcome(
                                    name: "Los Angeles Angels",
                                    price: 1.3,
                                    link: nil
                                ),
                                Outcome(
                                    name: "Oakland Athletics",
                                    price: 3.3,
                                    link: nil
                                )
                            ]
                        )
                    ]
                ),
                Bookmaker(
                    key: "betmgm",
                    title: "BetMGM",
                    last_update: "2025-05-20T04:32:46Z",
                    link: "https://sports.{state}.betmgm.com/en/sports/events/los-angeles-angels-at-athletics-17432721",
                    markets: [
                        Market(
                            key: "h2h",
                            outcomes: [
                                Outcome(
                                    name: "Los Angeles Angels",
                                    price: 1.43,
                                    link: "https://sports.{state}.betmgm.com/en/sports?options=17432721-1288105739--636412273&type=Single"
                                ),
                                Outcome(
                                    name: "Oakland Athletics",
                                    price: 2.85,
                                    link: "https://sports.{state}.betmgm.com/en/sports?options=17432721-1288105739--636412272&type=Single"
                                )
                            ]
                        )
                    ]
                ),
                Bookmaker(
                    key: "bovada",
                    title: "Bovada",
                    last_update: "2025-05-20T04:33:16Z",
                    link: "https://www.bovada.lv/sports/baseball/mlb/los-angeles-angels-athletics-202505192205",
                    markets: [
                        Market(
                            key: "h2h",
                            outcomes: [
                                Outcome(
                                    name: "Los Angeles Angels",
                                    price: 1.43,
                                    link: nil
                                ),
                                Outcome(
                                    name: "Oakland Athletics",
                                    price: 2.75,
                                    link: nil
                                )
                            ]
                        )
                    ]
                )
            ]
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(odds) { match in
                    VStack(alignment: .leading, spacing: 15) {
                        // 🕒 比賽時間 + 對戰資訊
                        VStack(alignment: .leading, spacing: 14) {
                            if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                            HStack {
                                Text(match.home_team)
                                    .font(.headline)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("vs")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text(match.away_team)
                                    .font(.headline)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }                        }

                        // 📊 Bookmakers
                        ForEach(match.bookmakers) { bookmaker in
                            if let market = bookmaker.markets.first,
                               market.outcomes.count >= 2 {
                                let outcome1 = market.outcomes[0]
                                let outcome2 = market.outcomes[1]

                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(String(format: "%.2f", outcome1.price))
                                            .bold()
                                    }

                                    Spacer()

                                    Text(bookmaker.title)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    VStack(alignment: .trailing) {
                                        Text(String(format: "%.2f", outcome2.price))
                                            .bold()
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .navigationTitle(sport.title)
    }
}

#Preview {
    OddsDetailViewT(
        sport: Sport(
            key: "baseball_mlb",
            group: "Baseball",
            title: "MLB",
            description: "Major League Baseball",
            active: true,
            has_outrights: false
        )
    )
}

