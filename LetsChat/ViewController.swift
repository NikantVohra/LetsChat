//
//  ViewController.swift
//  LetsChat
//
//  Created by Vohra, Nikant on 4/29/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(MessageConverter.sharedInstance.convertMessage("@nikant @nik (asdhasdhajshdhjas)(asdhasghd) www.nikantvohra.com http://www.quora.com")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

