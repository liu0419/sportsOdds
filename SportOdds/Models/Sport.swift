//
//  Sport.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/19.
//

import Foundation

struct Sport: Codable, Identifiable {
    let key: String
    let group: String
    let title: String
    let description: String
    let active: Bool
    let has_outrights: Bool
    var id: String { key }
}


