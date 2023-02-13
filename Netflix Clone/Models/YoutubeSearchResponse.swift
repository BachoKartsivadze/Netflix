//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 11.12.22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
