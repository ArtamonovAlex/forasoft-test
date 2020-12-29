//
//  NoDataCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 29.12.2020.
//

import UIKit
import SnapKit

class NoDataCell: UITableViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var noDataLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24)
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        l.text = "No data available"
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
