//
//  UIView+Extension.swift
//  Sjauf
//
//  Created by Eugene Braginets on 10/6/16.
//  Copyright © 2016 Eugene Braginets. All rights reserved.
//

import Foundation

extension UIView {
    
    var defaultTransition: Double {
        get {
            return 0.3
        }
    }
    
    var defaultDelay: Double {
        get {
            return 0.3
        }
    }
    
    
    
    func animateAppearanceWithDelay(_ delay: Double) {
        
        self.alpha = 0
        UIView.animate(withDuration: self.defaultTransition, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1
            }, completion: nil)
    }
    
    func animateAppearance() {
        
        self.alpha = 0
        UIView.animate(withDuration: defaultTransition, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 1
            }, completion: nil)
    }

    func animateDisappearance() {
        
        self.alpha = 1
        UIView.animate(withDuration: defaultTransition, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
            }, completion: nil)
    }

    
    
    func animateDisappearanceWithDelay(_ delay: Double) {
        
        self.alpha = 1
        UIView.animate(withDuration: defaultTransition, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0
            }, completion: nil)
    }
    
    class func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }

    
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    
}
