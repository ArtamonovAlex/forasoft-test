//
//  AlbumDetailsViewController.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit
import SnapKit

fileprivate typealias Sections = AlbumDetailsViewModel.Sections
class AlbumDetailsViewController: ForaSoftTestViewController {
    
//    MARK: Public Properties
    
    public var viewModel: AlbumDetailsViewModel!
    
//    MARK: UIElements
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.estimatedSectionHeaderHeight = 100
        t.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        t.register(AlbumInfoCell.self, forCellReuseIdentifier: AlbumInfoCell.reuseId)
        t.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseId)
        return t
    }()
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bindViewModel()
        reloadData()
    }
    
//    MARK: Private methods
    
    private func setup() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    func reloadData() {
        viewModel.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.isUpdating = { isUpdating in
            DispatchQueue.main.async {
                self.setActivityIndication(isUpdating)
                if !isUpdating {
                    self.tableView.reloadData()
                }
            }
        }
        viewModel.onError = { [weak self] error in
            self?.presentAlert(withTitle: "Error", message: error) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension AlbumDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
            case .albumInfo: return 1
            case .songs: return viewModel.songs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: indexPath.section)! {
            case .albumInfo: return getAlbumInfoCell(in: tableView, at: indexPath)
            case .songs: return getSongCell(in: tableView, at: indexPath)
        }
    }
    
}

// MARK: UITableViewDelegate

extension AlbumDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: UITableViewCells

private extension AlbumDetailsViewController {
    
    func getAlbumInfoCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumInfoCell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoCell.reuseId, for: indexPath) as! AlbumInfoCell
        let album = viewModel.album
        cell.set(album)
        return cell
    }
    
    func getSongCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: SongCell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseId, for: indexPath) as! SongCell
        let song = viewModel.songs[indexPath.row]
        cell.set(song: song)
        return cell
    }
}
