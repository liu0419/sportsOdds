import SwiftUI

struct OddsDetailView: View {
    let sport: Sport
    @StateObject private var viewModel = OddsViewModel()
    
    enum Mode { case list, parlay }
    @State private var mode: Mode = .list
    
    var body: some View {
        ZStack {
            Color("DarkPurple").ignoresSafeArea()
            VStack(spacing: 0) {
                Image(sport.title)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                Spacer()
                
                HStack(spacing: 12) {
                    ForEach([Mode.list, Mode.parlay], id: \.self) { option in
                        let label = option == .list ? "賽事列表" : "串關模式"
                        Button(action: {
                            mode = option
                        }) {
                            Text(label)
                                .font(.subheadline)
                                .bold()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(mode == option ? Color("RoseGold").opacity(0.25) : Color.clear)
                                .foregroundColor(mode == option ? Color("RoseGold") : Color.white.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(mode == option ? Color("RoseGold") : Color.white.opacity(0.4), lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                if let error = viewModel.errorMessage {
                    Text("❌ \(error)").foregroundColor(.red).padding()
                } else if viewModel.odds.isEmpty {
                    ProgressView("Loading odds...").padding()
                } else {
                    switch mode {
                    case .list:
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(viewModel.odds) { match in
                                    NavigationLink(destination: MatchOddsDetailView(match: match)) {
                                        MatchRow(match: match)
                                            .foregroundColor(Color("RoseGold"))
                                            .background(Color("WimbledonBackground").opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.purple.opacity(0.7), lineWidth: 1)
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                        }
                    case .parlay:
                        ParlayView(matches: viewModel.odds)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(sport.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                viewModel.fetchOdds(for: sport.key)
            }
            .navigationTitle(sport.title)
        }
    }
}
