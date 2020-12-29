//
//  SongCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit
import SnapKit

class SongCell: UITableViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var shadowView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        v.layer.cornerRadius = 6
        return v
    }()
    
    private lazy var songArtwork: UIImageView = {
        let i = UIImageView()
        i.layer.cornerRadius = 6
        i.layer.masksToBounds = true
        return i
    }()
    
    private lazy var songTitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
    private lazy var songDurationLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        return l
    }()
    
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
    
//    MARK: Set
    
    public func set(song: Song) {
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        
        songTitleLabel.text = song.name
        songArtwork.image = song.image ?? #imageLiteral(resourceName: "noAtrwork")
        
        let minutes: Int = song.duration / 60
        let seconds: Int = song.duration % 60
        songDurationLabel.text = "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
        
        setup()
    }
    
//    MARK: Private Methods
    
    private func setup() {
        
        addSubview(shadowView)
        shadowView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        shadowView.addSubview(songArtwork)
        songArtwork.snp.makeConstraints { m in
            m.width.equalTo(songArtwork.snp.height)
            m.top.leading.equalToSuperview().offset(10)
            m.bottom.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(songTitleLabel)
        songTitleLabel.snp.makeConstraints { m in
            m.centerY.equalTo(songArtwork)
            m.top.equalToSuperview().offset(20)
            m.bottom.equalToSuperview().offset(-20)
            m.leading.equalTo(songArtwork.snp.trailing).offset(10)
        }
        
        shadowView.addSubview(songDurationLabel)
        songDurationLabel.snp.makeConstraints { m in
            m.centerY.equalTo(songTitleLabel)
            m.trailing.equalToSuperview().offset(-10)
            m.leading.equalTo(songTitleLabel.snp.trailing).offset(10)
        }
    }
}
