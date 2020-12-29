//
//  SearchViewController.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 25.12.2020.
//

import UIKit
import SnapKit

protocol SearchViewControllerDelegate {
    func openAlbum(_ album: Album)
    func saveSearch(_ text: String)
}

fileprivate typealias Sections = SearchViewModel.Sections
class SearchViewController: ForaSoftTestViewController {
    
//    MARK: Public Properties
    
    public var viewModel: SearchViewModel!
    public var delegate: SearchViewControllerDelegate?
    
//    MARK: UIElements
    
    private lazy var titleLabel: UILabel = {
        var l = UILabel()
        l.text = "Search albums"
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 24)
        return l
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sB = UISearchBar()
        sB.showsCancelButton = true
        sB.returnKeyType = .search
        sB.delegate = self
        sB.searchBarStyle = UISearchBar.Style.minimal
        sB.tintColor = .white
        sB.barTintColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        var textField: UITextField? = sB.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
        return sB
    }()
    
    private lazy var startSearchButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        btn.tintColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        return btn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        cv.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseId)
        cv.register(TrySearchCell.self, forCellWithReuseIdentifier: TrySearchCell.reuseId)
        return cv
    }()
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
//    MARK: Public methods
    
    public func performSearchFromHistory(_ text: String) {
        searchBar.text = text
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        startSearch()
    }
    
//    MARK: Private methods
    
    private func setup() {
        navigationItem.rightBarButtonItem = startSearchButton
        navigationItem.titleView = titleLabel
        navigationItem.backButtonTitle = "Search"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.isUpdating = { [weak self] isUpdating in
            DispatchQueue.main.async {
                self?.setActivityIndication(isUpdating)
                if !isUpdating {
                    self?.collectionView.reloadData()
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            self?.presentAlert(withTitle: "Error", message: error)
        }
    }
    
    @objc private func showSearchBar() {
        searchBar.text = ""
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    private func startSearch() {
        searchBar.resignFirstResponder()
        if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        if let text = searchBar.text, !text.isEmpty {
            delegate?.saveSearch(text)
            viewModel.search(text)
        }
    }
}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = startSearchButton
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
}

// MARK: UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
            case .noData: return viewModel.albums.count > 0 ? 0 : 1
            case .albums: return viewModel.albums.count
        } 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Sections(rawValue: indexPath.section)! {
            case .noData: return getTrySearchCell(in: collectionView, at: indexPath)
            case .albums: return getAlbumCell(in: collectionView, at: indexPath)
        }

    }
}

// MARK: UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Sections(rawValue: indexPath.section)! {
            case .noData: return
            case .albums: delegate?.openAlbum(viewModel.albums[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch Sections(rawValue: indexPath.section)! {
            case .noData:
                return
            case .albums:
                if (viewModel.albums.count - indexPath.row == 8) && viewModel.needLoadMore {
                    // Used to enable pagination
                    /// There is a design issue about pagination since itunes api do not provide api to
                    /// get sorted results. There are two possible approaches:
                    ///  1. Add sorted pages to collection view
                    ///  2. Sort the whole collection view after adding new items
                    /// But both of them have drawbacks
                    viewModel.loadMoreResults()
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 125)
    }
}

// MARK: UICollectionViewCells

private extension SearchViewController {
    func getTrySearchCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TrySearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrySearchCell.reuseId, for: indexPath) as! TrySearchCell
        cell.set()
        return cell
    }
    
    func getAlbumCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseId, for: indexPath) as! AlbumCell
        let album = viewModel.albums[indexPath.row]
        cell.set(album: album)
        return cell
    }
}
