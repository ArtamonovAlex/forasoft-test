//
//  Album.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 27.12.2020.
//

import Foundation
import UIKit

class Album {
    
    public let id: Int
    public let name: String
    public let genre: String
    public let artistName: String
    public var releaseYear: String? = nil
    public var image: UIImage? = nil
    
    init(from item: ITunesItem) {
        self.id = item.collectionId
        self.name = item.collectionName
        self.genre = item.primaryGenreName
        self.artistName = item.artistName
        
        let dF = DateFormatter()
        dF.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dF.date(from: item.releaseDate) {
            dF.dateFormat = "yyyy"
            self.releaseYear = dF.string(from: date)
        }
    }
}
