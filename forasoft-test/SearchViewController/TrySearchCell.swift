//
//  TrySearchCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 29.12.2020.
//

import UIKit
import SnapKit

class TrySearchCell: UICollectionViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var noDataLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        l.text = "No data to present, try new search"
        l.textAlignment = .center
        return l
    }()
    
//    MARK: Set
    
    public func set() {
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        setup()
    }
    
//    MARK: Private Methods
    
    private func setup() {
        addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { m in
            m.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}
