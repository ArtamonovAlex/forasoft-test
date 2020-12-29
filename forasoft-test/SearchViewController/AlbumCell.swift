//
//  AlbumCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

import UIKit
import SnapKit

class AlbumCell: UICollectionViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .leading
        s.spacing = 10
        return s
    }()
    
    private lazy var shadowView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        return v
    }()
    
    private lazy var albumArtwork: UIImageView = {
        let i = UIImageView()
        i.layer.cornerRadius = 16
        i.layer.masksToBounds = true
        return i
    }()
    
    private lazy var albumTitle: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.numberOfLines = 1
        l.textColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        return l
    }()
    
    private lazy var artistTitle: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 1
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return l
    }()
    
    private lazy var releaseTitle: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 1
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return l
    }()
    
//    MARK: Set
    
    public func set(album: Album) {
        albumTitle.text = album.name
        artistTitle.text = album.artistName
        releaseTitle.text = album.releaseYear
        albumArtwork.image = album.image ?? #imageLiteral(resourceName: "noAtrwork")
        
        setup()
    }
    
//    MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.addShadow(
            withColor: #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1),
            opacity: 0.25,
            radius: 5,
            xOffset: 1,
            yOffset: 2)
    }
    
//    MARK: Private Methods
    
    private func setup() {
        
        addSubview(shadowView)
        shadowView.snp.makeConstraints { m in
            m.top.leading.equalToSuperview().offset(10)
            m.bottom.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(albumArtwork)
        albumArtwork.snp.makeConstraints { m in
            m.width.equalTo(albumArtwork.snp.height)
            m.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        
//        addSubview(albumArtwork)
//        albumArtwork.snp.makeConstraints { m in
//            m.width.equalTo(albumArtwork.snp.height)
//            m.top.leading.equalToSuperview().offset(10)
//            m.bottom.equalToSuperview().offset(-10)
//        }
        
        stackView.addArrangedSubview(albumTitle)
        stackView.addArrangedSubview(artistTitle)
        stackView.addArrangedSubview(releaseTitle)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { m in
            m.centerY.equalTo(shadowView)
            m.leading.equalTo(shadowView.snp.trailing).offset(15)
            m.trailing.equalToSuperview().offset(-10)
        }
        
    }
}
