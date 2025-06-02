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
                
                Picker("", selection: $mode) {
                    Text("賽事列表").foregroundColor(Color("RoseGold")).tag(Mode.list)
                    Text("串關模式").foregroundColor(Color("RoseGold")).tag(Mode.parlay)
                }
                .pickerStyle(.segmented)
                .foregroundColor(Color("RoseGold"))
                .padding(8)
                .background(Color("DarkPurple").opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
                                            .background(Color.white.opacity(0.8))
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
