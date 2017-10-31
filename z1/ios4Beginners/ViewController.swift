//
//  ViewController.swift
//  ios4Beginners
//
//  Created by Karolina Beata Natalia Guzewska on 30.10.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func okButton(_ sender: Any) {
        if (textField.text?.isEmpty)!
        {
            print("No text found!")
        } else {
            print(textField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

