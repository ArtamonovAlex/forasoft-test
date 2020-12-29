//
//  ITunesEndpoints.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 27.12.2020.
//

import Foundation
import Moya

public enum ITunesEndpoints {
    
    // MARK: - Albums
    /// Get albums by name
    /// - name: album name
    /// - offset: offset for pagination
    case albums(name: String, offset: Int = 0)
    
    // MARK: - Image
    /// Get image data from url
    /// - url: image url
    case image(url: URL)
    
    // MARK: - Songs
    /// Get songs of an album
    /// - albumId: album id
    case songs(albumId: Int)
}

extension ITunesEndpoints: TargetType {
    public var baseURL: URL {
        switch self {
            case .image(let url):
                return url
            case .albums, .songs:
                return URL(string: "https://itunes.apple.com/")!
        }
    }
    
    public var path: String {
        switch self {
            case .albums:
                return "search"
            case .image:
                return ""
            case .songs:
                return "lookup"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
            case .albums(let name, let offset):
                let queryItems: [String: Any] = [
                    "entity": "album",
                    "attribute": "albumTerm",
                    "term": name,
                    "offset": offset
                ]
                return .requestParameters(parameters: queryItems, encoding: URLEncoding.queryString)
            case .songs(let albumId):
                let queryItems: [String: Any] = [
                    "entity": "song",
                    "id": albumId
                ]
                return .requestParameters(parameters: queryItems, encoding: URLEncoding.queryString)
            case .image:
                return .requestPlain
        }
        
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
