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
    
    @IBOutlet var imageView: UIImageView!
    var imageViewer = ImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        imageView.frame = CGRectMake(60, 100, 100, 100)
        imageView.image = UIImage(named: "1")
        imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView)
        addTapGestureToImageView()
        
        if let navi = self.navigationController as? CustomNavigationController {
            navi.imageView = imageView
        }
        
        if !isPresented {
            self.navigationController?.delegate = imageViewer
        }
    }
    
    func addTapGestureToImageView() {
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        imageView.addGestureRecognizer(tap)
        imageView.userInteractionEnabled = true
    }

    func tap() {
        let controller = ImageViewerViewController()
        controller.transitioningDelegate = imageViewer
        controller.image = imageView.image
        
        if !isPresented {
            controller.isPresented = false
            controller.title = "查看图片"
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
