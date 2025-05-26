import SwiftUI

struct OddsDetailView: View {
    let sport: Sport
    @StateObject private var viewModel = OddsViewModel()
    
    enum Mode { case list, parlay }
    @State private var mode: Mode = .list

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $mode) {
                Text("賽事列表").tag(Mode.list)
                Text("串關模式").tag(Mode.parlay)
            }
            .pickerStyle(.segmented)
            .padding()

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
        .navigationTitle(sport.title)
        .onAppear {
            viewModel.fetchOdds(for: sport.key)
        }
    }
}
