//
//  Activity.swift
//  Control_1
//
//  Created by prakash on 07/04/18.
//  Copyright © 2018 prakash. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public struct Activity {
    
    //MARK: - Change the variables values here for Custom uses
    public static var showFadeOutAnimation = false
    public static var pulseAnimation = true
    public static var activityColor: UIColor = UIColor.white
    public static var activityBackgroundColor: UIColor = UIColor.darkGray
    public static var activityTextColor: UIColor = UIColor.white
    public static var activityTextFontName: UIFont = UIFont.systemFont(ofSize: 23)
    fileprivate static var activityWidth = (UIScreen.screenWidth / widthDivision) / 2
    fileprivate static var activityHeight = activityWidth
    public static var widthDivision: CGFloat {
        get {
            guard UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad else {
                return 1.6
            }
            return 3.5
        }
    }
    public static var viewBackgroundDark: Bool = false
    public static var loadOverApplicationWindow: Bool = false
    
    
    //MARK: - Loading View
    fileprivate static var instance: LoadingResource?
    fileprivate static var backgroundView: UIView!
    fileprivate static var hidingInProgress = false
    
    
    public static func showLoading(_ text: String, disableUI: Bool) {
        Activity().startLoadingActivity(text, with: disableUI)
    }
    
    public static func showLoading() {
        Activity().startLoadingActivity("", with: false)
    }
    
    public static func hide(){
        DispatchQueue.main.async {
            instance?.hideActivity()
        }
    }
    
    //MARK: - Main Loading View creating here
    fileprivate class LoadingResource: UIView {
        fileprivate var textLabel: UILabel!
        fileprivate var activityView: UIActivityIndicatorView!
        fileprivate var disableUIIntraction = false
        
        convenience init(text: String, disableUI: Bool) {
            self.init(frame: CGRect(x: 0, y: 0, width: activityWidth, height: activityHeight))
            center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            backgroundColor = activityBackgroundColor
            alpha = 1
            layer.cornerRadius = 5
            
            let yPosition = frame.height/2 - 20
            
            addActivityView(yPosition)
            
            addTextLabel(yPosition + activityView.frame.size.height, text: text)
            
            //Apply here Border & Shadow
            checkActivityBackgroundColor()
            
            guard disableUI else {
                return
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
            disableUIIntraction = true
        }
        
        private func checkActivityBackgroundColor(){
            guard activityBackgroundColor != .clear else {
                return
            }
            self.dropShadow()
            self.addBorder()
            addPulseAnimation()
        }
        
        //MARK: - Pulse Animation adding here
        fileprivate func addPulseAnimation(){
            guard pulseAnimation else {
                return
            }
            DispatchQueue.main.async {
                let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
                pulseAnimation.duration = 0.4
                pulseAnimation.fromValue = 0.8
                pulseAnimation.toValue = 1
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = .greatestFiniteMagnitude
                self.layer.add(pulseAnimation, forKey: "animateOpacity")
            }
        }
        
        fileprivate func addActivityView(_ yPosition: CGFloat){
            activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityView.frame = CGRect(x: (frame.width/2) - 20, y: yPosition, width: 40, height: 40)
            activityView.color = activityColor
            activityView.startAnimating()
        }
        
        fileprivate func addTextLabel(_ yPosition: CGFloat, text: String){
            textLabel = UILabel(frame: CGRect(x: 5, y: yPosition - 10, width: activityWidth - 10, height: 40))
            textLabel.textColor = activityTextColor
            textLabel.font = activityTextFontName
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.text = text
        }
        
        fileprivate func showLoadingActivity() {
            addSubview(activityView)
            addSubview(textLabel)
            
            guard loadOverApplicationWindow else {
                topMostViewController!.view.addSubview(self)
                return
            }
            UIApplication.shared.windows.first?.addSubview(self)
        }
        
        fileprivate var fadeOutValue: CGFloat = 10.0
        
        fileprivate func hideActivity(){
            checkBackgoundWasClear()
            guard showFadeOutAnimation else {
                clearView()
                return
            }
            fadeOutAnimation()
        }
        
        fileprivate func fadeOutAnimation(){
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.3, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: self.fadeOutValue, y: self.fadeOutValue)
                    self.alpha = 0.2
                }, completion: { (value: Bool) in
                    self.clearView()
                })
            }
        }
        
        fileprivate func checkBackgoundWasClear(){
            guard activityBackgroundColor != .clear else {
                fadeOutValue = 2
                return
            }
            textLabel.alpha = 0
            activityView.alpha = 0
        }
        
        fileprivate func clearView(){
            activityView.stopAnimating()
            self.removeFromSuperview()
            instance = nil
            hidingInProgress = false
            
            if backgroundView != nil {
                UIView.animate(withDuration: 0.1, animations: {
                    backgroundView.backgroundColor = backgroundView.backgroundColor?.withAlphaComponent(0)
                }, completion: { _ in
                    backgroundView.removeFromSuperview()
                })
            }
            
            guard disableUIIntraction else {
                return
            }
            disableUIIntraction = false
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

fileprivate extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addBorder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }
}

fileprivate extension Activity{
    
    fileprivate func startLoadingActivity(_ text: String,with disableUI: Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard Activity.instance == nil else {
               
                return
            }
            
            guard topMostViewController != nil else {
               
                return
            }
            // Separate creation from showing
            Activity.instance = LoadingResource(text: text, disableUI: disableUI)
            DispatchQueue.main.async {
                if Activity.viewBackgroundDark {
                    if Activity.backgroundView == nil {
                        Activity.backgroundView = UIView(frame: UIApplication.shared.keyWindow!.frame)
                    }
                    Activity.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
                    topMostViewController?.view.addSubview(Activity.backgroundView)
                    UIView.animate(withDuration: 0.2, animations: {Activity.backgroundView.backgroundColor = Activity.backgroundView.backgroundColor?.withAlphaComponent(0.5)})
                }
                Activity.instance?.showLoadingActivity()
            }
        }
    }
}

fileprivate extension UIScreen {
    class var orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }
    class var screenWidth: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(orientation) {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    class var screenHeight: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(orientation) {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}

fileprivate var topMostViewController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let controller = presentedVC?.presentedViewController {
        presentedVC = controller
    }
    return presentedVC
}