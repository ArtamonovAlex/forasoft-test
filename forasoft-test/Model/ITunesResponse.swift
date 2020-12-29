//
//  ITunesResponse.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 27.12.2020.
//


class ITunesResponse: Decodable {
    public let resultCount: Int
    public let results:[ITunesItem]
}
