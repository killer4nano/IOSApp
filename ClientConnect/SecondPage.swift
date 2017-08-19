//
//  SecondPage.swift
//  ClientConnect
//
//  Created by Ali Khaliq on 8/19/17.
//  Copyright © 2017 Humber. All rights reserved.
//

import UIKit

class SecondPage: UIViewController,UITableViewDataSource, UITableViewDelegate
{
    
    var listOfTasks = [Tasks]()
    var taskNames = [String]()
    let computerName:String = "10.117.80.139"
    var name: String = ""
    var userId:String = ""
    var currentTask:Tasks? = nil


    @IBOutlet weak var out: UITableView!
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view, typically from a nib.
        out.dataSource = self
        out.delegate = self
        out.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        grabData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = out.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = taskNames[indexPath.row]
        cell.backgroundColor = UIColor(hex: "000000")
        cell.textLabel?.textColor = UIColor(hex: "FFFFFF")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        print(listOfTasks[row].getDescription())
        showDescription(task: listOfTasks[row])
        
    }
    

    func grabData() {
        myTask()
        grabTasks(passedListOfTasks: &listOfTasks,passedStringArray: &taskNames)
        out.reloadData()
    }
    
    func grabTasks(passedListOfTasks:  inout [Tasks],passedStringArray: inout [String]){
        let url = NSURL(string: "http:/"+computerName+":8080/tasks")
        let semaphore = DispatchSemaphore(value: 0)
        var jsonObj:JSON = []
        var listOfTasks:[Tasks] = []
        var taskNames:[String] = []
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            jsonObj = try! JSON(data: data!)
            var count = 0
            while (count < jsonObj.count) {
                listOfTasks.append(Tasks(id: jsonObj[count]["id"].int!,name: jsonObj[count]["taskName"].string!, description: jsonObj[count]["taskDescription"].string!,tech: jsonObj[count]["tech"].string!,notes: jsonObj[count]["notes"].string!))
                
                count += 1
            }
            
            count = 0
            while (count < listOfTasks.count) {
                taskNames.append(listOfTasks[count].getName())
                count += 1
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        passedListOfTasks = listOfTasks
        passedStringArray = taskNames
        
    }
    
    func myTask(){
        let url = NSURL(string: "http:/"+computerName+":8080/mytask/"+userId)
        let semaphore = DispatchSemaphore(value: 0)
        var jsonObj:JSON = ""
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            jsonObj = try! JSON(data: data!)
            if (jsonObj.count > 0) {
                self.currentTask = Tasks(id: jsonObj["id"].int!,name: jsonObj["taskName"].string!, description: jsonObj["taskDescription"].string!,tech: jsonObj["tech"].string!,notes: jsonObj["notes"].string!)

            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
    }

    func acceptTask(task: Tasks) -> Bool{
        var string:NSString = ""
        let stringUrl = "/accept/"+userId+"/"+name+"/"+task.getName()
        let fullUrl = "http:/"+computerName+":8080"+stringUrl
        let urlPath = NSString(format: fullUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let url = URL(string: urlPath)
        let semaphore = DispatchSemaphore(value: 0)
        let task1 = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            string = (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")            //string = data
            semaphore.signal()
        }
        task1.resume()
        
        semaphore.wait()
        if (string == "done") {
            return true
        }else {
            return false
        }
        
    }
    
    @IBAction func myJob(_ sender: Any) {
        if (currentTask != nil) {
            let myJob = self.storyboard!.instantiateViewController(withIdentifier: "MyJob") as! MyJob
            self.navigationController!.present(myJob, animated: true)
            myJob.nameOfTask = (currentTask?.getName())!
            myJob.descriptionOfTask = (currentTask?.getDescription())!
            myJob.setText()
        }else {
            showMessage(message: "You are currently not doing anything!")
            
        }
    }
    func showDescription(task: Tasks){
        let refreshAlert = UIAlertController(title: task.getName(), message: task.getDescription(), preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentTask == nil) {
                if (self.acceptTask(task: task)) {
                    self.currentTask = task
                    self.showMessage(message: "Go and do you job!")
                }else {
                    self.showMessage(message: "Someone else stole the job from you! Please pick another one")
                }
                self.grabData()
            }else {
                self.showMessage(message: "You can't do more than 1 job!")
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Don't need to do anything when they click cancel
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showMessage(message: String){
        let refreshAlert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //Don't need to do anything if they press ok.
        }))
        
       
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    

}

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

