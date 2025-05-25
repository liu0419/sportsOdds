import SwiftUI

struct OddsDetailView: View {
    let sport: Sport
    @StateObject private var viewModel = OddsViewModel()
    
    enum SortBy {
        case none
        case outcome1
        case outcome2
    }
    
    @State private var sortBy: SortBy = .none
    
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
                                }
                            }
                            
                            // 📊 Bookmaker 賠率 + 排序
                            let sortedBookmakers = match.bookmakers.sorted { a, b in
                                guard let aMarket = a.markets.first,
                                      let bMarket = b.markets.first,
                                      aMarket.outcomes.count >= 2,
                                      bMarket.outcomes.count >= 2 else {
                                    return false
                                }
                                let aOutcome1 = aMarket.outcomes[0]
                                let aOutcome2 = aMarket.outcomes[1]
                                let bOutcome1 = bMarket.outcomes[0]
                                let bOutcome2 = bMarket.outcomes[1]
                                
                                switch sortBy {
                                case .outcome1:
                                    return aOutcome1.price > bOutcome1.price
                                case .outcome2:
                                    return aOutcome2.price > bOutcome2.price
                                case .none:
                                    return false
                                }
                            }
                            
                            ForEach(sortedBookmakers) { bookmaker in
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
            }
            .padding()
        }
        .safeAreaInset(edge: .top) {
            VStack(spacing: 0) {
                    Picker("Sort By", selection: $sortBy) {
                        Text("Default").tag(SortBy.none)
                        Text("Sort by Home").tag(SortBy.outcome1)
                        Text("Sort by Away").tag(SortBy.outcome2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal) // 可調整為 .padding(.horizontal, 16) 看你需求
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity) // ⭐️ 讓 Picker 撐滿整個寬度
                .background(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2) // ⭐️ 加陰影
        }
        .navigationTitle(sport.title)
        .onAppear {
            viewModel.fetchOdds(for: sport.key)
        
        }
    }
}

#Preview {
    OddsDetailView(sport: Sport(
        key: "baseball_mlb",
        group: "Baseball",
        title: "MLB",
        description: "Major League Baseball",
        active: true,
        has_outrights: false
    ))
}
