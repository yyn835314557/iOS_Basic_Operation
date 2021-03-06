//
//  ViewController.swift
//  CustomizeControls
//
//  Created by 游义男 on 15/7/19.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var progress:ProgressControl!
    
    @IBAction func TappedModifiedBtn(sender: AnyObject) {
        progress.setProgressValue(progress.getProgressValue()+0.1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progress = ProgressControl(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        self.view.addSubview(progress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

