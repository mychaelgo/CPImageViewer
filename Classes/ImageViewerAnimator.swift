//
//  BaseViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class ImageViewerAnimator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    let animator = ImageViewerAnimationTransition()
    let interativeAnimator = ImageViewerInteractiveTransition()

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presenting is ImageControllerProtocol && presented is ImageViewerViewController {
            interativeAnimator.wireToViewController(presented as! ImageViewerViewController)
            interativeAnimator.isPresented = true
            animator.dismiss = false
            return animator
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is ImageControllerProtocol {
            animator.dismiss = true
            return animator
        }
        
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is ImageControllerProtocol && toVC is ImageViewerViewController {
            if operation == .Push {
                interativeAnimator.wireToViewController(toVC as! ImageViewerViewController)
                interativeAnimator.isPresented = false
                animator.dismiss = false
                return animator
            } else if operation == .Pop {
                animator.dismiss = true
                return animator
            }
        }
        
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
}
