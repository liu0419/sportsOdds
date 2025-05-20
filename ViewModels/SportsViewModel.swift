import Foundation

class SportsViewModel: ObservableObject {
    @Published var sports: [Sport] = []
    @Published var fetchError: String? = nil
    @Published var lastUpdated: Date? = nil
    @Published var selectedGroups: Set<String> = []  // 勾選的 group

    var filteredSports: [Sport] {
        if selectedGroups.isEmpty {
            return sports
        } else {
            return sports.filter { selectedGroups.contains($0.group) }
        }
    }
    
    var availableGroups: [String] {
            let groups = Set(sports.map { $0.group })
            return Array(groups).sorted()
        }
    
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
    
    func fetchSports() {
        guard let apiKey = getAPIKey() else {
               print("❌ 無法取得 API 金鑰")
               return
           }
        
        guard let url = URL(string: "https://api.the-odds-api.com/v4/sports?apiKey=\(apiKey)") else {
            self.fetchError = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.fetchError = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.fetchError = "No data received"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Sport].self, from: data)
                DispatchQueue.main.async {
                    self.sports = decoded
                    self.lastUpdated = Date()
                    self.fetchError = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchError = "Decoding error: \(error.localizedDescription)"
                }
            }

        }.resume()
    }
}
