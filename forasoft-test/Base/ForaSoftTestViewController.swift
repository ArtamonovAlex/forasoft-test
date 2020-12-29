//
//  ForaSoftTestViewController.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 26.12.2020.
//

import UIKit
import SnapKit

class ForaSoftTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        navigationController?.navigationBar.barStyle = .black

        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
            navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    open override func loadView() {
        super.loadView()
        view.addSubview(activityView)
        activityView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
    }
    
    open func setActivityIndication(_ active: Bool, animated: Bool = true) {
        let duration: TimeInterval = animated ? TimeInterval(0.33) : 0
        view.bringSubviewToFront(activityView)
        active ? activityView.show(duration: duration) : activityView.hide(duration: duration)
    }
    
    private lazy var activityView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        v.isHidden = true
        
        let l = UILabel()
        l.textColor = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.text = "Loading"
        
        let a = UIActivityIndicatorView(style: .gray)
        a.color = #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1)
        a.hidesWhenStopped = false
        a.startAnimating()
        v.addSubview(a)
        v.addSubview(l)
        
        l.snp.makeConstraints { m in
            m.center.equalToSuperview()
        }
        
        a.snp.makeConstraints { m in
            m.centerX.equalTo(l.snp.centerX)
            m.bottom.equalTo(l.snp.top).offset(-5)
        }
        return v
    }()
}

