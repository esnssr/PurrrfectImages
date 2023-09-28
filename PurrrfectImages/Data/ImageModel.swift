//
//  ImageModel.swift
//  PurrrfectImages
//
//  Created by Eslam Nahel on 2023-09-27.
//

import Foundation

struct ImageModel: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let user: ImageUser
    let urls: ImageURLs
}

struct ImageURLs: Codable, Hashable {
    let raw: URL?
    let full: URL?
    let regular: URL?
    let small: URL?
    let thumb: URL?

    subscript(size: String) -> URL? {
        switch size {
        case "raw":
            return raw
        case "full":
            return full
        case "regular":
            return regular
        case "small":
            return small
        case "thumb":
            return thumb
        default:
            return nil
        }
    }
}

struct ImageUser: Codable, Hashable {
    let id: String
    let username: String
    let name: String
}
