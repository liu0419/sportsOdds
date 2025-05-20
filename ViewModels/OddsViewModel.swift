//
//  OddsViewModel.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/20.
//

import Foundation

class OddsViewModel: ObservableObject {
    @Published var odds: [OddsResponse] = []
    @Published var errorMessage: String? = nil
    
    func getAPIKey() -> String? {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = dict["ODDS_API_KEY"] as? String
        else {
            return nil
        }
        return key
    }

    func fetchOdds(for sportKey: String) {
       
       
        guard let apiKey = getAPIKey() else {
               print("❌ 無法取得 API 金鑰")
               return
           }

        let urlString = "https://api.the-odds-api.com/v4/sports/\(sportKey)/odds/?apiKey=\(apiKey)&regions=us&oddsFormat=decimal"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([OddsResponse].self, from: data)
                DispatchQueue.main.async {
                    self.odds = decoded
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
