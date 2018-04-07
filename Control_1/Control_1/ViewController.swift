//
//  ViewController.swift
//  Control_1
//
//  Created by prakash on 07/04/18.
//  Copyright © 2018 prakash. All rights reserved.
//

import UIKit
import LocoFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Activity.showLoading("Loading", disableUI: true)
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideLoader), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func hideLoader(){
        Activity.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnShow(_ sender: UIButton) {
        Activity.showLoading("Loading", disableUI: false)

    }
    
    @IBAction func btnHide(_ sender: UIButton) {
        Activity.hide()

    }
    
}

