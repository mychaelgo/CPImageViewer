//
//  DeleteImageViewController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, ImageControllerProtocol {
    var imageView = UIImageView()
    var image: UIImage?
    var rightBarItemTitle: String?
    var rightBarItemImage: UIImage?
    var rightAction: ((Void) -> (Void))?
    var isPresented = true
    var imageFrame: CGRect = CGRectZero

    private var scrollView: UIScrollView!
    
    private var naviBarHeight: CGFloat {
        return isPresented ? 0 : 64
    }
    
    /*
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .Custom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.edgesForExtendedLayout = .None
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-offsetY-[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["offsetY" : naviBarHeight], views: ["scrollView" : scrollView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        
        imageView.image = image
        scrollView.addSubview(imageView)
        
        //addPanGesture()
        
        if isPresented {
            let tap = UITapGestureRecognizer(target: self, action: "dismiss")
            self.scrollView.addGestureRecognizer(tap)
        } else if let title = rightBarItemTitle {
            let rightItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: "rightBarItemAction")
            self.navigationItem.rightBarButtonItem = rightItem
        } else if let image = rightBarItemImage {
            let rightItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "rightBarItemAction")
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.frame = centerFrameForImageView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        if isPresented {
            return true
        }
        
        return false
    }
    
    //MARK: - Custom Methods
    func centerFrameForImageView() -> CGRect {
        guard let aImage = image else { return CGRectZero }
        
        let viewWidth = self.scrollView.frame.size.width
        let viewHeight = self.scrollView.frame.size.height
        let imageWidth = aImage.size.width
        let imageHeight = aImage.size.height
        let newWidth = min(viewWidth, CGFloat(floorf(Float(imageWidth * (viewHeight / imageHeight)))))
        let newHeight = min(viewHeight, CGFloat(floorf(Float(imageHeight * (viewWidth / imageWidth)))))
        
        return CGRectMake((viewWidth - newWidth)/2, (viewHeight - newHeight)/2, newWidth, newHeight)
    }
    
    func centerScrollViewContents() {
        let viewWidth = self.scrollView.frame.size.width
        let viewHeight = self.scrollView.frame.size.height
        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        
        let originX = max(0, (viewWidth - imageWidth)/2)
        let originY = max(0, (viewHeight - imageHeight)/2)
        self.imageView.frame.origin = CGPointMake(originX, originY)
    }

    //MARK: - Button Action
    func rightBarItemAction() {
        self.navigationController!.popViewControllerAnimated(true)
        if let block = rightAction {
            block()
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    MARK: - UIPanGestureRecognizer
    func addPanGesture() {
        let panGestrue = UIPanGestureRecognizer(target: self, action: "gestureRecognizerDidPan:")
        panGestrue.delegate = self
        imageView.addGestureRecognizer(panGestrue)
        imageView.userInteractionEnabled = true
    }
    
    func gestureRecognizerDidPan(panGesture: UIPanGestureRecognizer) {
        let currentPoint = panGesture.translationInView(imageView)
        
        switch panGesture.state {
        case .Began:
            imageFrame = imageView.frame
            
        case .Changed:
            imageView.frame.origin.y = imageFrame.origin.y + currentPoint.y
            let percent = min(fabs(currentPoint.y) / (self.view.bounds.size.height / 2), 1)
            scrollView.backgroundColor = UIColor(white: 0.0, alpha: 1 - percent)
            imageView.bounds.size.width = imageFrame.width - percent * 60.0
            imageView.frame.origin.x = imageFrame.origin.x + percent * 60.0 / 2.0
            
        case .Ended:
            if fabs(currentPoint.y) > 50.0 {
                self.dismiss()
            } else {
                resetImageViewFrame()
            }
            
        case .Cancelled:
            resetImageViewFrame()
        default:
            break
        }
    }
    
    func resetImageViewFrame() {
        scrollView.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(0.25) {
            self.imageView.frame = self.imageFrame
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let currentPoint = panGesture.translationInView(imageView)
            return fabs(currentPoint.y) > fabs(currentPoint.x)
        }
        
        return false
    }
    */
    
    //MARK:- UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}
