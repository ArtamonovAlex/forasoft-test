//
//  AlbumInfoCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit

class AlbumInfoCell: UITableViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var shadowView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        return v
    }()
    
    private lazy var albumArtworkView: UIImageView = {
        let i = UIImageView()
        i.layer.cornerRadius = 16
        i.layer.masksToBounds = true
        return i
    }()
    
    private lazy var albumTitle: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.numberOfLines = 0
        l.textColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        return l
    }()
    
    private lazy var infoTitle: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return l
    }()
    
//    MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.addShadow(
            withColor: #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1),
            opacity: 0.25,
            radius: 10,
            xOffset: 0,
            yOffset: 0)
    }
    
//    MARK: Set
    
    public func set(_ album: Album) {
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        
        albumArtworkView.image = album.image ?? #imageLiteral(resourceName: "noAtrwork")
        albumTitle.text = album.name
        
        var infoText = album.artistName
        if !album.genre.isEmpty {
            infoText.append(" ⬩ \(album.genre)")
        }
        if let year = album.releaseYear {
            infoText.append(" ⬩ \(year)")
        }
        infoTitle.text = infoText
        
        setup()
    }
    
//    MARK: Private Methods
    
    private func setup() {
        
        addSubview(shadowView)
        shadowView.snp.makeConstraints { m in
            m.top.equalToSuperview().offset(30)
            m.leading.equalToSuperview().offset(60)
            m.trailing.equalToSuperview().offset(-60)
        }

        shadowView.addSubview(albumArtworkView)
        albumArtworkView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
            m.height.equalTo(albumArtworkView.snp.width)
        }
        
        addSubview(albumTitle)
        albumTitle.snp.makeConstraints { m in
            m.top.equalTo(shadowView.snp.bottom).offset(20)
            m.centerX.equalTo(shadowView)
            m.leading.equalToSuperview().offset(10)
            m.trailing.equalToSuperview().offset(-10)
        }
        
        addSubview(infoTitle)
        infoTitle.snp.makeConstraints { m in
            m.top.equalTo(albumTitle.snp.bottom).offset(10)
            m.centerX.equalTo(albumTitle)
            m.leading.leading.equalTo(albumTitle)
            m.bottom.equalToSuperview().offset(-20)
        }
    }
}
