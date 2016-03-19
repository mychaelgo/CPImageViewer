//
//  UINavigationViewController.swift
//  CPImageViewer
//
//  Created by CP3 on 16/3/17.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import ObjectiveC

//http://stackoverflow.com/questions/24133058/is-there-a-way-to-set-associated-objects-in-swift/24133626#24133626
//http://nshipster.cn/swift-objc-runtime/

extension UINavigationController : ImageControllerProtocol {
    
    private struct AssociatedKeys {
        static var DescriptiveName = "cp_navigation_animationImageView"
    }
    
    public var animationImageView: UIImageView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as! UIImageView
        }
        set {
           return objc_setAssociatedObject(self, &AssociatedKeys.DescriptiveName, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UITabBarController : ImageControllerProtocol {
    
    private struct AssociatedKeys {
        static var DescriptiveName = "cp_tabBar_animationImageView"
    }
    
    public var animationImageView: UIImageView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as! UIImageView
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.DescriptiveName, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
