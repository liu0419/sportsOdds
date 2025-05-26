//
//   ParlayCalculator.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/26.
//

import Foundation

struct ParlayCalculator {
    static func calculate(from matches: [OddsResponse], selections: [String: String]) -> [(bookmaker: Bookmaker, odds: Double)] {
        let selectedMatches = matches.filter { selections[$0.id] != nil }
        guard !selectedMatches.isEmpty else { return [] }

        // 找出共同支援這些比賽的 bookmaker keys
        var commonKeys = selectedMatches.first?.bookmakers.map(\.key) ?? []

        for match in selectedMatches.dropFirst() {
            let keys = match.bookmakers.map(\.key)
            commonKeys = commonKeys.filter { keys.contains($0) }
        }

        var result: [(Bookmaker, Double)] = []

        for key in commonKeys {
            var totalOdds: Double = 1
            var valid = true
            var bookmakerRef: Bookmaker?

            for match in selectedMatches {
                guard let bookmaker = match.bookmakers.first(where: { $0.key == key }),
                      let market = bookmaker.markets.first(where: { $0.key == "h2h" }),
                      let pickName = selections[match.id],
                      let outcome = market.outcomes.first(where: {
                          $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                          == pickName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                      }) else {
                    valid = false
                    break
                }

                totalOdds *= outcome.price
                bookmakerRef = bookmaker
            }

            if valid, let bookmaker = bookmakerRef {
                result.append((bookmaker, totalOdds))
            }
        }

        return result
    }
}
