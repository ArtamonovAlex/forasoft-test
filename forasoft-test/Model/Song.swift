//
//  Song.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit

class Song {

    public let name: String
    public var image: UIImage? = nil
    public let duration: Int
    
    init(from item: ITunesItem) {
        self.name = item.trackName ?? "Undefined"
        if let inMillis = item.trackTimeMillis {
            self.duration = inMillis / 1000
        } else {
            self.duration = 0
        }
    }
}
