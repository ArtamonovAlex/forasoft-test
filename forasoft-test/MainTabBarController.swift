//
//  MainTabBarController.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    
// MARK: Navigation Controllers
    
    private lazy var searchNavController: UINavigationController = {
        let searchVC = SearchViewController()
        searchVC.viewModel = SearchViewModel()
        searchVC.delegate = self
        let navVC = createNavController(searchVC, image: #imageLiteral(resourceName: "search"))
        return navVC
    }()
    
    private lazy var historyNavController: UINavigationController = {
        let historyVC = HistoryViewController()
        historyVC.delegate = self
        let navVC = createNavController(historyVC, image: #imageLiteral(resourceName: "history"))
        return navVC
    }()
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
//    MARK: Private methods
    
    private func setup() {
        viewControllers = [searchNavController, historyNavController]
        
        tabBar.tintColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        tabBar.barTintColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        tabBar.isTranslucent = false
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func createNavController(_ vc: ForaSoftTestViewController, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        vc.tabBarItem.image = image
        return navController
    }
}

// MARK: SearchViewControllerDelegate

extension MainTabBarController: SearchViewControllerDelegate {
    func saveSearch(_ text: String) {
        if let historyVC = historyNavController.viewControllers.last as? HistoryViewController {
            historyVC.saveNewSearch(text)
        }
    }
    
    func openAlbum(_ album: Album) {
        let vc = AlbumDetailsViewController()
        vc.viewModel = AlbumDetailsViewModel(album)
        searchNavController.pushViewController(vc, animated: true)
    }
}

// MARK: HistoryViewControllerDelegate

extension MainTabBarController: HistoryViewControllerDelegate {
    func runSearchFromHistory(_ text: String) {
        selectedViewController = searchNavController
        if let _ = searchNavController.viewControllers.last as? AlbumDetailsViewController {
            searchNavController.popViewController(animated: true)
        }
        if let searchVC = searchNavController.viewControllers.last as? SearchViewController {
            searchVC.performSearchFromHistory(text)
        }
    }
}
