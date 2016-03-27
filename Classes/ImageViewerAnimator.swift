//
//  BaseViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

public class ImageViewerAnimator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    private let animator = ImageViewerAnimationTransition()
    private let interativeAnimator = ImageViewerInteractiveTransition()

    //MARK: - UIViewControllerTransitioningDelegate
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source is ImageControllerProtocol && presenting is ImageControllerProtocol && presented is ImageViewerViewController {
            if let navi = presenting as? UINavigationController {
                navi.animationImageView = (source as! ImageControllerProtocol).animationImageView
            } else if let tabBarVC = presenting as? UITabBarController {
                tabBarVC.animationImageView = (source as! ImageControllerProtocol).animationImageView
            }
            
            interativeAnimator.wireToViewController(presented as! ImageViewerViewController)
            interativeAnimator.isPresented = true
            animator.isBack = false
            return animator
        }
        
        return nil
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is ImageViewerViewController {
            animator.isBack = true
            return animator
        }
        
        return nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
    
    //MARK: - UINavigationDelegate
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push && fromVC is ImageControllerProtocol && toVC is ImageViewerViewController {
            interativeAnimator.wireToViewController(toVC as! ImageViewerViewController)
            interativeAnimator.isPresented = false
            animator.isBack = false
            return animator
        } else if operation == .Pop  && fromVC is ImageViewerViewController && toVC is ImageControllerProtocol {
            animator.isBack = true
            return animator
        }
        
        return nil
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
}
