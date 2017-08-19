//
//  test.swift
//  ClientConnect
//
//  Created by Ali Khaliq on 8/19/17.
//  Copyright © 2017 Humber. All rights reserved.
//
import UIKit

class MyJob: UIViewController
{
    

    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var bottom: UILabel!
    
    var nameOfTask = ""
    var descriptionOfTask = ""
    
    override func viewDidLoad()
    {
        
        
    }
    
    func setText() {
        top.text = nameOfTask
        bottom.text = descriptionOfTask
    }

}
