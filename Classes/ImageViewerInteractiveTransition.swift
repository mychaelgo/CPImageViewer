//
//  InteractiveTransition.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

public class ImageViewerInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning, UIGestureRecognizerDelegate {
    public var isPresented = true
    weak var controller: UIViewController!
    var distance = UIScreen.mainScreen().bounds.size.height/2
    var interactionInProgress = false
    var shouldCompleteTransition = false
    
    var transitionContext: UIViewControllerContextTransitioning?
    var fromVC: ImageViewerViewController!
    var toVC: UIViewController!
    var newImageView: UIImageView!
    var backgroundView: UIView!
    var toImageView: UIImageView!
    var fromFrame: CGRect = CGRectZero
    var toFrame: CGRect = CGRectZero
    
    func wireToViewController(vc: UIViewController) {
        
        controller = vc
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        vc.view.addGestureRecognizer(panGesture)
    }
    
    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ImageViewerViewController
        toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        backgroundView = UIView(frame: finalFrame)
        backgroundView.backgroundColor = UIColor.blackColor()
        containerView?.addSubview(backgroundView)
        
        let fromImageView = fromVC.imageView
        toImageView = (toVC as! ImageControllerProtocol).imageView
        fromFrame = fromImageView.convertRect(fromImageView.bounds, toView: containerView)
        toFrame = toImageView.convertRect(toImageView.bounds, toView: containerView)
        
        newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .ScaleAspectFit
        containerView?.addSubview(newImageView)
        
        fromVC.view.alpha = 0.0
        containerView!.addSubview(toVC.view)
        containerView!.sendSubviewToBack(toVC.view)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        let currentPoint = gesture.translationInView(controller.view)
        switch (gesture.state) {
        case .Began:
            
            interactionInProgress = true
            if isPresented {
                controller.dismissViewControllerAnimated(true, completion: nil)
            } else {
               controller.navigationController?.popViewControllerAnimated(true)
            }
        
        case .Changed:
            
            let percent = min(fabs(currentPoint.y) / distance, 1)
            shouldCompleteTransition = (percent > 0.3)
            transitionContext?.updateInteractiveTransition(percent)
            backgroundView.alpha = 1 - percent
            
            newImageView.frame.origin.y = fromFrame.origin.y + currentPoint.y
            newImageView.bounds.size.width = fromFrame.width - percent * 60.0
            newImageView.frame.origin.x = fromFrame.origin.x + percent * 60.0 / 2.0
        
        case .Ended, .Cancelled:

            interactionInProgress = false
            if (!shouldCompleteTransition || gesture.state == .Cancelled) {
                cancelTransition()
            } else {
                completeTransition()
            }
            
        default:
            break
        }
    }
    
    func completeTransition() {
        let duration = 0.3
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            self.newImageView.frame = self.toFrame
            self.backgroundView.alpha = 0.0
            }, completion: { finished in
                self.newImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                
                self.toImageView.alpha = 1.0
                
                self.transitionContext?.finishInteractiveTransition()
                self.transitionContext?.completeTransition(true)
        })
    }
    
    func cancelTransition() {
        
        let duration = 0.3
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            self.newImageView.frame = self.fromFrame
            self.backgroundView.alpha = 1.0
            }, completion: { finished in
                self.newImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                
                self.fromVC.view.alpha = 1.0
                self.toVC.view.removeFromSuperview()
                
                self.transitionContext?.cancelInteractiveTransition()
                self.transitionContext?.completeTransition(false)
        })
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let currentPoint = panGesture.translationInView(controller.view)
            return fabs(currentPoint.y) > fabs(currentPoint.x)
        }
        
        return true
    }
}
