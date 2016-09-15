//
//  NormalViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import CPImageViewer

class GeneralViewController: UIViewController, CPImageControllerProtocol {
    
    var isPresented = false
    
    @IBOutlet var animationImageView: UIImageView!
    var animator = CPImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(GeneralViewController.tap))
        animationImageView.addGestureRecognizer(tap)
        animationImageView.isUserInteractionEnabled = true
        
        if !isPresented {
            navigationController?.delegate = animator
        }
    }

    func tap() {
        let controller = CPImageViewerViewController()
        controller.transitioningDelegate = animator
        controller.image = animationImageView.image
        
        if !isPresented {
            controller.viewerStyle = .push
            controller.title = "CPImageViewer"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            present(controller, animated: true, completion: nil)
        }
    }
}
