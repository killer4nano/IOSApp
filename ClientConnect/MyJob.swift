//
//  MyJob.swift
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
    @IBOutlet weak var sosButton: UIButton!
   
    
    
    
    var secondPage:SecondPage! = nil
    var nameOfTask = ""
    var descriptionOfTask = ""
    
    override func viewDidLoad()
    {
        
        
    }
    
    func setText() {
        top.text = nameOfTask
        bottom.text = descriptionOfTask
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sos(_ sender: Any) {
        if(secondPage!.currentTask?.isSos())! {
            secondPage!.noSos()
        }else {
            secondPage!.sos(notes: "test")
        }
        secondPage!.grabData()
        dismiss(animated:true)
        
    }
    
    @IBAction func finish(_ sender: Any) {
        secondPage!.finish(notes: "test")
        secondPage!.grabData()
        dismiss(animated: true)
    }
}
