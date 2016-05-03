//
//  ViewController.swift
//  LetsChat
//
//  Created by Vohra, Nikant on 4/29/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButtonPressed(sender: AnyObject) {
        MessageConverter.sharedInstance.convertMessage(self.inputTextView.text, completion: { (result) in
            dispatch_async(dispatch_get_main_queue(), {
                self.outputLabel.text = result

            })
        })
    }

}

