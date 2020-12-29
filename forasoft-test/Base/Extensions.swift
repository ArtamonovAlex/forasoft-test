//
//  Extensions.swift
//  forasoft-test
//
//  Created by Artamonov Aleksandr on 28.12.2020.
//

import UIKit

//    MARK: CellInstantiable

public protocol CellInstantiable {
    static var reuseId: String { get }
}

public extension CellInstantiable {
    
    static var reuseId: String {
        return String(describing: Self.self)
    }
    
}

//    MARK: UIView

public extension UIView {
    
    /**
     Smoothly show the view
     
     - Parameters:
        - duration: animation diration
        - completion: Completion handler. *Optional*.
    */
    func show(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
      
    /**
     Smoothly hide the view
     
     - Parameters:
        - duration: animation diration
        - completion: Completion handler. *Optional*.
    */
    func hide(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseIn], animations: {
            self.alpha = 0.0
        }) { success in
            self.isHidden = true
            if let completion = completion { completion(success) }
        }
    }
    
    /**
     Add shadow to view
     
     - Parameters:
        - withColor: shadow color
        - opacity: shadow opacity
        - radius: shadow radius
        - xOffset: shadow horizontal offset
        - yOffset: shadow vertical offset
        - roundingCorners: shadows corners to round
        
    */
    func addShadow(withColor color: UIColor, opacity: Float = 0.3, radius: CGFloat = 10, xOffset: CGFloat = 0, yOffset: CGFloat = 0, roundingCorners: UIRectCorner = [.allCorners]) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        DispatchQueue.main.async {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
        }
    }
}

//    MARK: UIViewController

extension UIViewController {
    
    /**
     Presents an "Ok" alert
     
     - Parameters:
        - title: Alert title.
        - message: Alert message.
        - completionHandler: Completion handler. *Optional*.
    */
    public func presentAlert(withTitle title: String?, message: String?, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completionHandler?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
