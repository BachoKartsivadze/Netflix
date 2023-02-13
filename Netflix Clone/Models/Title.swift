//
//  Movie.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 05.12.22.
//

import Foundation

struct TitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let title: String?
    let original_title: String?
    let name: String?
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let media_type: String?
    let release_date: String?
    let vote_count: Int
    let vote_average: Double
}
