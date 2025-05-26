import SwiftUI

struct ParlayView: View {
    @State private var selections: [String: String] = [:] // match.id -> team name
    @State private var showSheet = false

    let matches: [OddsResponse]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(matches) { match in
                        VStack(spacing: 8) {
                            if let date = ISO8601DateFormatter().date(from: match.commence_time) {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                            }

                            
                            HStack {
                                Button(action: {
                                    if selections[match.id] == match.home_team {
                                        selections.removeValue(forKey: match.id)
                                    } else {
                                        selections[match.id] = match.home_team
                                    }
                                }) {
                                    Text(match.home_team)
                                        .font(.headline).bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selections[match.id] == match.home_team ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }

                                Text("vs")
                                    .foregroundColor(.gray)

                                Button(action: {
                                    if selections[match.id] == match.away_team {
                                        selections.removeValue(forKey: match.id)
                                    } else {
                                        selections[match.id] = match.away_team
                                    }
                                }) {
                                    Text(match.away_team)
                                        .font(.headline).bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selections[match.id] == match.away_team ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }

                    if !selections.isEmpty {
                        VStack(alignment: .leading) {
                            Text("你目前選擇的投注：")
                                .bold()
                            ForEach(selections.sorted(by: { $0.key < $1.key }), id: \.key) { (_, team) in
                                Text("• \(team)")
                            }
                        }
                        .padding()
                    }
                }
                .padding(.bottom, 100) // ⭐️ 留出底部按鈕空間
                .padding(.top)
            }

            // 固定在底部的按鈕
            Button(action: {
                showSheet = true
            }) {
                Text("比較串關賠率")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selections.count >= 2 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(selections.count < 2)
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)
           
        }
        .sheet(isPresented: $showSheet) {
            ParlayResultView(selections: selections, matches: matches)
                .presentationDetents([.medium]) // ⬅️ 不佔滿
        }
    }
}
