//
//  ImageViewerAnimationController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

public protocol ImageControllerProtocol {
    var animationImageView: UIImageView! { get }
}

public class ImageViewerAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    public var isBack = false
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        let style = transitionContext.presentationStyle()
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        if style != .OverFullScreen && isBack {
            
            containerView.addSubview(toVC.view)
            containerView.sendSubviewToBack(toVC.view)
            
            if toVC.view.bounds.size != finalFrame.size {
                toVC.view.frame = finalFrame
                toVC.view.setNeedsLayout()
                toVC.view.layoutIfNeeded()
            }
        }
        
        let backgroundView = UIView(frame: finalFrame)
        backgroundView.backgroundColor = UIColor.blackColor()
        containerView.addSubview(backgroundView)
        
        let fromImageView = (fromVC as! ImageControllerProtocol).animationImageView
        let toImageView = (toVC as! ImageControllerProtocol).animationImageView
        let fromFrame = fromImageView.convertRect(fromImageView.bounds, toView: containerView)
        let toFrame = toImageView.convertRect(toImageView.bounds, toView: containerView)
        
        let newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .ScaleAspectFit
        containerView.addSubview(newImageView)
        
        if !isBack {
            print(fromImageView.frame, fromFrame)
        } else {
            print(toImageView.frame, toFrame)
        }
        
        if !isBack {
            backgroundView.alpha = 0.0
            fromImageView.alpha = 0.0
        } else {
            backgroundView.alpha = 1.0
            fromVC.view.alpha = 0.0
        }
        
        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            if !self.isBack {
                newImageView.frame = finalFrame
                backgroundView.alpha = 1.0
            } else {
                newImageView.frame = toFrame
                backgroundView.alpha = 0.0
            }
            }, completion: { finished in
                newImageView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                
                let cancel = transitionContext.transitionWasCancelled()
                
                if !self.isBack {
                    if cancel {
                        fromImageView.alpha = 1.0
                    } else {
                        containerView.addSubview(toVC.view)
                    }
                } else {
                    if cancel {
                        fromVC.view.alpha = 1.0
                        if style != .OverFullScreen {
                            toVC.view.removeFromSuperview()
                        }
                    } else {
                        toImageView.alpha = 1.0
                    }
                }
                transitionContext.completeTransition(!cancel)
        })
    }
}
