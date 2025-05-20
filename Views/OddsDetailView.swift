import SwiftUI

struct OddsDetailView: View {
    let sport: Sport
    @StateObject private var viewModel = OddsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let error = viewModel.errorMessage {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                } else if viewModel.odds.isEmpty {
                    ProgressView("Loading odds...")
                } else {
                    ForEach(viewModel.odds) { match in
                        VStack(alignment: .leading, spacing: 15) {
                            // 🕒 比賽時間 + 對戰資訊
                            VStack(alignment: .leading, spacing: 4) {
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
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text("vs")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text(match.away_team)
                                        .font(.headline)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }                            }
                            
                            // 📊 每個 bookmaker 的賠率
                            ForEach(match.bookmakers) { bookmaker in
                                if let market = bookmaker.markets.first,
                                   market.outcomes.count >= 2 {
                                    let outcome1 = market.outcomes[0]
                                    let outcome2 = market.outcomes[1]
                                    
                                    HStack {
                                        // 主隊
                                        VStack(alignment: .leading) {
                                            //                                            Text(outcome1.name)
                                            //                                                .font(.subheadline)
                                            Text(String(format: "%.2f", outcome1.price))
                                                .bold()
                                        }
                                        
                                        Spacer()
                                        
                                        // Bookmaker 名稱
                                        Text(bookmaker.title)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        // 客隊
                                        VStack(alignment: .trailing) {
                                            //                                            Text(outcome2.name)
                                            //                                                .font(.subheadline)
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
            }
            .padding()
        }
        .navigationTitle(sport.title)
        .onAppear {
            viewModel.fetchOdds(for: sport.key)
        }
    }
}

#Preview {
    ContentView()
}

