//
//  BaseViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

public class CPImageViewerAnimator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    private let animator = CPImageViewerAnimationTransition()
    private let interativeAnimator = CPImageViewerInteractiveTransition()

    //MARK: - UIViewControllerTransitioningDelegate
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source is CPImageControllerProtocol && presenting is CPImageControllerProtocol && presented is CPImageViewerViewController {
            if let navi = presenting as? UINavigationController {
                navi.animationImageView = (source as! CPImageControllerProtocol).animationImageView
            } else if let tabBarVC = presenting as? UITabBarController {
                tabBarVC.animationImageView = (source as! CPImageControllerProtocol).animationImageView
            }
            
            interativeAnimator.wireToViewController(presented as! CPImageViewerViewController)
            interativeAnimator.isPresented = true
            animator.isBack = false
            return animator
        }
        
        return nil
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is CPImageViewerViewController {
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
        
        if operation == .Push && fromVC is CPImageControllerProtocol && toVC is CPImageViewerViewController {
            interativeAnimator.wireToViewController(toVC as! CPImageViewerViewController)
            interativeAnimator.isPresented = false
            animator.isBack = false
            return animator
        } else if operation == .Pop  && fromVC is CPImageViewerViewController && toVC is CPImageControllerProtocol {
            animator.isBack = true
            return animator
        }
        
        return nil
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
}
