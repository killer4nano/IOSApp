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
    var listOfSosTasks = [SosTasks]()
    var taskNames = [String]()
    let computerName:String = "10.117.80.139"
    var name: String = ""
    var userId:String = ""
    var currentTask:Tasks? = nil
    @IBOutlet weak var myJob: UIButton!

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
        if (indexPath.row < listOfSosTasks.count) {
            cell.backgroundColor = UIColor(hex: "FF0000")
        }else {
            cell.backgroundColor = UIColor(hex: "000000")
        }
        cell.textLabel?.textColor = UIColor(hex: "FFFFFF")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if (row < listOfSosTasks.count) {
            showDescription(row: row, isSos: true)
        }else {
            showDescription(row: row, isSos: false)
        }
        
    }
    

    func grabData() {
        myTask()
        grabSosTasks(passedListOfTasks: &listOfSosTasks, passedStringArray: &taskNames)
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
            while (count  < listOfTasks.count) {
                taskNames.append(listOfTasks[count].getName())
                count += 1
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        passedListOfTasks = listOfTasks
        passedStringArray += taskNames
        
    }
    func sos(notes: String){
        let this = "/"+currentTask!.getName()+"/"+currentTask!.getDescription()
        let stringUrl = "/sos/"+String(currentTask!.getId())+this
        let fullUrl = "http:/"+computerName+":8080"+stringUrl+"/"+notes
        let urlPath = NSString(format: fullUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let url = URL(string: urlPath)
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func finish(notes: String){
        let this = "/"+String(currentTask!.getId())+"/"+currentTask!.getName()+"/"+currentTask!.getDescription()
        let stringUrl = "/finish/"+userId+this
        let fullUrl = "http:/"+computerName+":8080"+stringUrl+"/"+notes
        let urlPath = NSString(format: fullUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let url = URL(string: urlPath)
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        currentTask = nil
        myJob.backgroundColor = UIColor(hex: "00FF00")
    }
    
    func noSos(){
        let stringUrl = "/nosos/"+String(currentTask!.getId())+"/"+currentTask!.getName()
        let fullUrl = "http:/"+computerName+":8080"+stringUrl
        let urlPath = NSString(format: fullUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let url = URL(string: urlPath)
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    
    func myTask(){
        let url = URL(string: "http:/"+computerName+":8080/mytask/"+userId)
        let semaphore = DispatchSemaphore(value: 0)
        var jsonObj:JSON = ""
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            let string = (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            if (string != "") {
                jsonObj = try! JSON(data: data!)
                self.currentTask = Tasks(id: jsonObj["id"].int!,name: jsonObj["taskName"].string!, description: jsonObj["taskDescription"].string!,tech: jsonObj["tech"].string!,notes: jsonObj["notes"].string!)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        if (currentTask != nil) {
            let url2 = URL(string: "http:/"+computerName+":8080/issos/"+String(currentTask!.getId()))
            let semaphore2 = DispatchSemaphore(value: 0)
            let task2 = URLSession.shared.dataTask(with: url2!) {(data, response, error) in
                let string = (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                if (string == "yes") {
                    self.currentTask?.setSos(boolean: true)
                }
                semaphore2.signal()
            }
            task2.resume()
            semaphore2.wait()
            
            
            if (currentTask?.isSos())! {
                myJob.backgroundColor = UIColor(hex: "FF0000")
            }else {
                myJob.backgroundColor = UIColor(hex: "ffffbb33")
            }
        }
        
    }


    
    func grabSosTasks(passedListOfTasks:  inout [SosTasks],passedStringArray: inout [String]){
        let url = NSURL(string: "http:/"+computerName+":8080/sostasks")
        let semaphore = DispatchSemaphore(value: 0)
        var jsonObj:JSON = []
        var listOfTasks:[SosTasks] = []
        var taskNames:[String] = []
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            jsonObj = try! JSON(data: data!)
            var count = 0
            while (count < jsonObj.count) {
                listOfTasks.append(SosTasks(name: jsonObj[count]["name"].string!, description: jsonObj[count]["description"].string!,notes: jsonObj[count]["notes"].string!))
                
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
            if (currentTask?.isSos())! {
                myJob.sosButton.backgroundColor = UIColor(hex: "FF0000")
            }
            myJob.secondPage = self;
        }else {
            showMessage(message: "You are currently not doing anything!")
            
        }
    }
    
    func showDescription(row: Int,isSos: Bool){
        if (isSos) {
            let task:SosTasks = listOfSosTasks[row]
            let refreshAlert = UIAlertController(title: task.getName(), message: task.getDescription() + "\r\n" + task.getNotes(), preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                //Don't need to do anything when they click Ok
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }else {
            let task:Tasks = listOfTasks[row - listOfSosTasks.count]
            let refreshAlert = UIAlertController(title: task.getName(), message: task.getDescription(), preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
                if(self.currentTask == nil) {
                    if (self.acceptTask(task: task)) {
                        self.currentTask = task
                        self.showMessage(message: "Go and do you job!")
                    }else {
                        self.showMessage(message: "Someone else stole the job from you! Please pick another one")
                    }
                    self.grabData() // REMOVE LATER
                }else {
                    self.showMessage(message: "You can't do more than 1 job!")
                }
            }))
        
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //Don't need to do anything when they click cancel
            }))
        
            present(refreshAlert, animated: true, completion: nil)
        }
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

