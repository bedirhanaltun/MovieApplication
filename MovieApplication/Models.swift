//
//  Models.swift
//  MovieApplication
//
//  Created by Bedirhan Altun on 26.07.2022.
//

import Foundation

//Structs From API

struct Movie: Codable {
    var search: [Search]?
    let totalResults: String?
    let response: String?
    let error: String?
    

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}
struct Search: Codable {
    let title, year, imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
}

//Segment For Scope Button Titles

enum SegmentType: Int {
    case all = 0
    case movies = 1
    case series = 2
    case games = 3
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .movies:
            return "Movies"
        case .series:
            return "Series"
        case .games:
            return "Games"
        }
    }
}
