import SwiftUI

struct ParlayView: View {
    @State private var selections: [String: String] = [:]
    @State private var showSheet = false

    let matches: [OddsResponse]

    var body: some View {
        ZStack(alignment: .bottom) {
            // 🔥 背景：暗紫色
            Color("DarkPurple")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(matches.enumerated()), id: \.element.id) { index, match in
                        VStack(alignment: .leading, spacing: 12) {
                            if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                            HStack(spacing: 12) {
                                teamButton(for: match.home_team, matchID: match.id, selected: selections[match.id] == match.home_team)

                                Text("vs")
                                    .foregroundColor(.white)

                                teamButton(for: match.away_team, matchID: match.id, selected: selections[match.id] == match.away_team)
                            }
                        }
                        .padding()
                        .background(index.isMultiple(of: 2) ? Color.gray.opacity(0.2) : Color("DarkPurple").opacity(0.6))
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                    }
                    if !selections.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("你目前選擇的投注：")
                                .bold()
                                .foregroundColor(.white)

                            ForEach(selections.sorted(by: { $0.key < $1.key }), id: \.key) { (_, team) in
                                Text("• \(team)")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 120) // 留底部按鈕空間
                .padding(.top)
            }
            
           

            // 底部按鈕
            ZStack {
                
                Color("DarkPurple")
                       .ignoresSafeArea(edges: .bottom)
                       .frame(height: 100)
                
                VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.7)) // ← 可自訂顏色
                            .frame(height: 1)
                        Spacer()
                    }
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .bottom)

                
                Button(action: {
                    showSheet = true
                }) {
                    Text("比較串關賠率")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selections.count >= 2 ? Color.white : Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .overlay(
                                   RoundedRectangle(cornerRadius: 12)
                                       .stroke(Color.white, lineWidth: 2)
                               )
                        .padding(.horizontal)
                }
                .ignoresSafeArea(edges: .bottom)
                .disabled(selections.count < 2)
                .sheet(isPresented: $showSheet) {
                    ParlayResultView(selections: selections, matches: matches)
                        .presentationDetents([.medium])
                }
            }
        }
    }

    // MARK: - 自訂選手按鈕
    @ViewBuilder
    private func teamButton(for name: String, matchID: String, selected: Bool) -> some View {
        Button {
            if selected {
                selections.removeValue(forKey: matchID)
            } else {
                selections[matchID] = name
            }
        } label: {
            Text(name)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selected ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

let mockMatches: [OddsResponse] = [
    OddsResponse(
        id: "match1",
        sport_title: "ATP French Open",
        commence_time: "2025-06-01T09:00:00Z",
        home_team: "Alexei Popyrin",
        away_team: "Tommy Paul",
        bookmakers: [
            Bookmaker(
                key: "fanduel",
                title: "FanDuel",
                last_update: "2025-06-01T04:18:56Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Alexei Popyrin", price: 2.46, link: nil),
                            Outcome(name: "Tommy Paul", price: 1.57, link: nil)
                        ]
                    )
                ]
            )
        ]
    ),
    OddsResponse(
        id: "match2",
        sport_title: "ATP French Open",
        commence_time: "2025-06-01T11:20:00Z",
        home_team: "Ben Shelton",
        away_team: "Carlos Alcaraz",
        bookmakers: [
            Bookmaker(
                key: "bovada",
                title: "Bovada",
                last_update: "2025-06-01T04:20:02Z",
                link: nil,
                markets: [
                    Market(
                        key: "h2h",
                        outcomes: [
                            Outcome(name: "Ben Shelton", price: 11.0, link: nil),
                            Outcome(name: "Carlos Alcaraz", price: 1.05, link: nil)
                        ]
                    )
                ]
            )
        ]
    )
]


#Preview {
    ParlayView(matches: mockMatches)
}
