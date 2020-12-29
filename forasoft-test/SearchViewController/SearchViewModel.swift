//
//  SearchViewModel.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

import Foundation
import UIKit
import Moya

class SearchViewModel {
    
//    MARK: Public Properties
    
    enum Sections: Int, CaseIterable {
        case noData, albums
    }
    
    private(set) var albums: [Album] = []
    
    public var isUpdating: ((Bool) -> ())?
    public var onError: ((String) -> ())?
    public var needLoadMore: Bool = true
    
//    MARK: Private Properties
    
    private let provider = MoyaProvider<ITunesEndpoints>(plugins: [NetworkLoggerPlugin()])
    private var searchText: String = ""
    
//    MARK: Public methods
    
    // Function to initiate search
    /// - Parameter text: text to search
    public func search(_ text: String) {
        albums = []
        searchText = text
        isUpdating?(true)
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "\(Self.self) \(#function)")
        
        provider.request(.albums(name: text)) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    guard let iTunesResp: ITunesResponse = try? response.map(ITunesResponse.self) else {
                        print("Decode error")
                        return
                    }
                    queue.sync { [weak self] in
                        let albums: [Album] = iTunesResp.results.map { item in
                            let album = Album(from: item)
                            if let imageUrlString = item.artworkUrl100, let url = URL(string: imageUrlString) {
                                group.enter()
                                self?.loadImage(url) { image in
                                    album.image = image
                                    group.leave()
                                }
                            }
                            return album
                        }
                        self?.needLoadMore = iTunesResp.resultCount == 50
                        self?.albums = albums.sorted(by: { (lhs, rhs) -> Bool in
                            return lhs.name < rhs.name
                        })
                    }
                    group.notify(queue: queue) { [weak self] in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self?.isUpdating?(false)
                        }
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    self.isUpdating?(false)
                    self.onError?("Error occurred while getting data")
            }
        }
    }
    
    // Function to load more results on last search
    public func loadMoreResults() {
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "\(Self.self) \(#function)")
        
        provider.request(.albums(name: searchText, offset: albums.count)) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    guard let iTunesResp: ITunesResponse = try? response.map(ITunesResponse.self) else {
                        print("Decode error")
                        return
                    }
                    queue.sync { [weak self] in
                        let albums: [Album] = iTunesResp.results.map { item in
                            let album = Album(from: item)
                            if let imageUrlString = item.artworkUrl100, let url = URL(string: imageUrlString) {
                                group.enter()
                                self?.loadImage(url) { image in
                                    album.image = image
                                    group.leave()
                                }
                            }
                            return album
                        }
                        self?.needLoadMore = iTunesResp.resultCount == 50
                        
                        // Use this approach to add sorted page to collection view
                        self?.albums.append(contentsOf: albums.sorted(by: { (lhs, rhs) -> Bool in
                            return lhs.name < rhs.name
                        }))
                        
                        // Use this approach to add new contents and sort the whole collection view
//                        self?.albums.append(contentsOf: albums)
//                        self?.albums.sort(by: { (lhs, rhs) -> Bool in
//                            return lhs.name < rhs.name
//                        })
                    }
                    group.notify(queue: queue) { [weak self] in
                        self?.isUpdating?(false)
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    self.onError?("Error occurred while getting data")
                    self.isUpdating?(false)
            }
        }
    }
    
//    MARK: Private methods
    
    private func loadImage(_ url: URL, onComplete: @escaping ((UIImage?) -> ())) {
        provider.request(.image(url: url)) { result in
            switch result {
                case .success(let response):
                    onComplete(UIImage(data: response.data))
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    onComplete(nil)
            }
        }
    }
}
