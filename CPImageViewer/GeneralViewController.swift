//
//  NormalViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController, ImageControllerProtocol {
    
    var isPresented = false
    
    @IBOutlet var animationImageView: UIImageView!
    var imageViewer = ImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.greenColor()
    
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        animationImageView.addGestureRecognizer(tap)
        animationImageView.userInteractionEnabled = true
        
        if !isPresented {
            self.navigationController?.delegate = imageViewer
        }
    }

    func tap() {
        let controller = ImageViewerViewController()
        controller.transitioningDelegate = imageViewer
        controller.image = animationImageView.image
        
        if !isPresented {
            controller.isPresented = false
            controller.title = "查看图片"
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
