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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        print(listOfTasks[row].getDescription())
        showDescription(taskName: listOfTasks[row].getName(),taskDescription: listOfTasks[row].getDescription())
    }
    

    func grabData() {
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
            repeat {
                listOfTasks.append(Tasks(name: jsonObj[count]["taskName"].string!, description: jsonObj[count]["taskDescription"].string!,tech: jsonObj[count]["tech"].string!,notes: jsonObj[count]["notes"].string!))
                
                count += 1
            }while count < jsonObj.count
            
            count = 0
            repeat {
                taskNames.append(listOfTasks[count].getName())
                count += 1
            }while count < listOfTasks.count
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        passedListOfTasks = listOfTasks
        passedStringArray = taskNames
        
    }
    
    func showDescription(taskName: String, taskDescription: String){
        let refreshAlert = UIAlertController(title: taskName, message: taskDescription, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    

}

