//
//  ITunesItem.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

struct ITunesItem: Decodable {
    
    public let wrapperType: String
    public let collectionType: String?
    public let artistId: Int
    public let collectionId: Int
    public let artistName: String
    public let collectionName: String
    public let trackName: String?
    public let artworkUrl100: String?
    public let trackCount: Int
    public let releaseDate: String
    public let primaryGenreName: String
    public let trackTimeMillis: Int?
}
