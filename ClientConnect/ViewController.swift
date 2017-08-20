//
//  ViewController.swift
//  ClientConnect
//
//  Created by Andrew McGuire on 7/31/17.
//  Copyright © 2017 Humber. All rights reserved.
//

import UIKit
import FirebaseMessaging
class ViewController: UIViewController
{

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    let computerName:String = "10.117.80.139"
    var usersName = ""
    var userId:String = ""
    
           override func viewDidLoad()
           {
                    }
    
    @IBAction func login(_ sender: Any) {
        let username: String = self.username.text!
        let password: String = self.password.text!
        if (login(userName: username,password: password)) {
             let jj = self.storyboard!.instantiateViewController(withIdentifier: "SecondPage") as! SecondPage
            self.navigationController!.pushViewController(jj, animated: true)
            jj.name = username
            jj.userId = self.userId
            //print("success")
        }else {
            showMessage(message: "Wrong username or password!")
        }

    }
    
    func login(userName: String,password: String) -> Bool{
        var string:NSString = ""
        let url = NSURL(string: "http:/"+computerName+":8080/login/"+userName+"/"+password)
        let semaphore = DispatchSemaphore(value: 0)
        let task1 = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            string = (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")            //string = data
            
            semaphore.signal()
        }
        task1.resume()
        semaphore.wait()
        if (string != "0") {
            userId = string as String
            return true
        }else {
            return false
        }
        
    }
    
    
    func showMessage(message: String){
        let refreshAlert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        
        
        present(refreshAlert, animated: true, completion: nil)
    }

}



