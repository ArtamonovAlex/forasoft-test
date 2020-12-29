//
//  HistoryViewController.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

import UIKit
import SnapKit

protocol HistoryViewControllerDelegate {
    func runSearchFromHistory(_ text: String)
}

fileprivate let historyKey = "searchHistory"
class HistoryViewController: ForaSoftTestViewController {
    
//    MARK: Public Properties
    
    public var delegate: HistoryViewControllerDelegate?
    
//    MARK: Public Properties
    
    private enum Sections: Int, CaseIterable {
        case noData, history
    }
    
    private let userDefaults = UserDefaults.standard
    
    private var searchHistory: [String] = []
    
//    MARK: UIElements
    
    private lazy var titleLabel: UILabel = {
        var l = UILabel()
        l.text = "History"
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 24)
        return l
    }()
    
    private lazy var tableViewTitleView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        let l = UILabel()
        l.textColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        l.text = "You recently searched:"
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textAlignment = .center
        v.addSubview(l)
        l.snp.makeConstraints { m in
            m.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.estimatedSectionHeaderHeight = 100
        t.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        t.register(NoDataCell.self, forCellReuseIdentifier: NoDataCell.reuseId)
        return t
    }()
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchHistory = userDefaults.stringArray(forKey: historyKey) ?? []
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
//    MARK: Public methods
    
    public func saveNewSearch(_ text: String) {
        searchHistory.append(text)
        userDefaults.set(searchHistory, forKey: historyKey)
    }

//    MARK: Private methods
    
    private func setup() {
        navigationItem.titleView = titleLabel
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
    }
}

// MARK: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
            case .noData: return searchHistory.count > 0 ? 0 : 1
            case .history: return searchHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: indexPath.section)! {
            case .noData: return getNoDataCell(in: tableView, at: indexPath)
            case .history: return getHistoryCell(in: tableView, at: indexPath)
        }
    }
}

// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Sections(rawValue: indexPath.section)! {
            case .noData: return UITableView.automaticDimension
            case .history: return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchHistory.count > 0 ? tableViewTitleView: nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Sections(rawValue: section)! {
            case .noData: return 0
            case .history: return searchHistory.count > 0 ? UITableView.automaticDimension : 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Sections(rawValue: indexPath.section)! {
            case .noData: return
            case .history:
                let index = searchHistory.count - indexPath.row - 1
                delegate?.runSearchFromHistory(searchHistory[index])
        }
    }
}

// MARK: UITableViewCells

private extension HistoryViewController {
    func getNoDataCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: NoDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataCell.reuseId, for: indexPath) as! NoDataCell
        cell.set()
        return cell
    }
    
    func getHistoryCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        let index = searchHistory.count - indexPath.row - 1
        cell.set(text: searchHistory[index])
        return cell
    }
}
