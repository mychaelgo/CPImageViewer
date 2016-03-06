//
//  ViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "CPImageViewer Demo"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "General"
            
        case 1:
            cell.textLabel?.text = "TableView"
            
        case 2:
            cell.textLabel?.text = "CollectionView"
            
        default:
            break
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Present"
        default:
            return "Navigation"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var isPresented = false
        if indexPath.section == 0 {
            isPresented = true
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controller: UIViewController
        if indexPath.row == 0 {
            controller = storyboard.instantiateViewControllerWithIdentifier("GeneralVC")
            (controller as! GeneralViewController).isPresented = isPresented
        } else if indexPath.row == 1 {
            controller = storyboard.instantiateViewControllerWithIdentifier("TableVC")
            (controller as! TableViewController).isPresented = isPresented
        } else {
            controller = storyboard.instantiateViewControllerWithIdentifier("CollectionVC")
            (controller as! CollectionViewController).isPresented = isPresented
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

