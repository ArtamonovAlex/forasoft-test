//
//  AlbumDetailsViewModel.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit
import Moya
import SnapKit

class AlbumDetailsViewModel {
    
//    MARK: Public Properties
    
    enum Sections: Int, CaseIterable {
        case albumInfo, songs
    }
    
    public var isUpdating: ((Bool) -> ())?
    public var onError: ((String) -> ())?
    
//    MARK: Private Properties
    
    private(set) var album: Album
    private(set) var songs: [Song] = []
    
    private let provider = MoyaProvider<ITunesEndpoints>(plugins: [NetworkLoggerPlugin()])
    
//    MARK: Init
    
    init(_ album: Album) {
        self.album = album
    }
    
//    MARK: Actions
    
    func reloadData() {
        isUpdating?(true)
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "\(Self.self) \(#function)")
        
        provider.request(.songs(albumId: album.id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    guard let iTunesResp: ITunesResponse = try? response.map(ITunesResponse.self) else {
                        print("Decode error")
                        return
                    }
                    queue.sync { [weak self] in
                        let songItems = iTunesResp.results.filter { item in
                            return item.wrapperType == "track"
                        }
                        self?.songs = songItems.map {item in
                            let song = Song(from: item)
                            if let imageUrlString = item.artworkUrl100, let url = URL(string: imageUrlString) {
                                group.enter()
                                self?.loadImage(url) { image in
                                    song.image = image
                                    group.leave()
                                }
                            }
                            return song
                        }
                    }
                    group.notify(queue: queue) { [weak self] in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self?.isUpdating?(false)
                        }
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    self.onError?("Error occurred while getting data")
                    self.isUpdating?(false)
            }
        }
    }
    
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
