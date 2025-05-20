//
//  OddsResponse.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/20.
//

struct OddsResponse: Codable, Identifiable {
    let id: String
    let sport_title: String
    let commence_time: String
    let home_team: String
    let away_team: String
    let bookmakers: [Bookmaker]
}

struct Bookmaker: Codable, Identifiable {
    var id: String { key }
    let key: String
    let title: String
    let last_update: String
    let link: String?
    let markets: [Market]
}

struct Market: Codable {
    let key: String
    let outcomes: [Outcome]
}

struct Outcome: Codable, Identifiable {
    var id: String { name }
    let name: String
    let price: Double
    let link: String?
}
