//
//  HistoryCell.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit
import SnapKit

class HistoryCell: UITableViewCell, CellInstantiable {
    
//    MARK: UIElements
    
    private lazy var arrowImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "chevron")
        i.tintColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        return i
    }()
    
    private lazy var historyItemLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
//    MARK: Set
    
    public func set(text: String) {
        historyItemLabel.text = text
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        setup()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
//    MARK: Private Methods
    
    private func setup() {
        
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { m in
            m.height.equalTo(8)
            m.width.equalTo(arrowImageView.snp.height).dividedBy(1.5)
            m.leading.equalToSuperview().offset(10)
            m.centerY.equalToSuperview()
        }
        
        addSubview(historyItemLabel)
        historyItemLabel.snp.makeConstraints { m in
            m.centerY.equalTo(arrowImageView).offset(-1)
            m.leading.equalTo(arrowImageView.snp.trailing).offset(10)
            m.trailing.equalToSuperview().offset(-10)
        }
    }
}

