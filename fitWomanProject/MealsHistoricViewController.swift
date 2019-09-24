//
//  MealsHistoricViewController.swift
//  fitWomanProject
//
//  Created by marwa on 08/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage
class MealsHistoricViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    

    
    var segmentResult = ""
    let defaults = UserDefaults.standard
    var ActivitiesArray = [AnyObject]()
    var UserEmail:String = ""
    
    @IBOutlet weak var segmentValue: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        UserEmail =  defaults.object(forKey:"email") as! String
        
        FetchData()
        self.tableView.reloadData()
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        let getIndex = segmentValue.selectedSegmentIndex
        print(getIndex)
        
        switch (getIndex) {
        case 0:
            
            segmentResult = "0"
            print(segmentResult as Any )
            FetchData()
        case 1:
            segmentResult = "1"
            print(segmentResult as Any )
            FetchDataYear()
        case 2:
            segmentResult = "2"
            print(segmentResult as Any )
            FetchDataMonth()
            
        default:
            print("no select")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ActivitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ham")
        
        
        let contentView = cell?.viewWithTag(0)
        
        
        
     
        let emchibark = contentView?.viewWithTag(200) as! UILabel
     let esmWtype = contentView?.viewWithTag(201) as! UILabel
         let caloriesLkol = contentView?.viewWithTag(202) as! UILabel
       
        let Activityarray  = ActivitiesArray[ indexPath.item] as! Dictionary<String,Any>
        let esem = Activityarray["name"] as! String
        let typee = Activityarray["type"] as! String
        let tCalories = Activityarray["totalCalories"] as! String
        
        emchibark.text = Activityarray["day"] as? String
        esmWtype.text = "\(typee) : \(esem)"
        caloriesLkol.text = "Calories: \(tCalories) KCal"
        return cell!
    }
    
    
    func FetchData() {
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/getMealByUser.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["emailUser":  UserEmail ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    self.ActivitiesArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                }
                if self.ActivitiesArray.count > 0 {
                    self.tableView.reloadData()
                } else {
                    
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)}
        }}
    
    
    
    
    func FetchDataMonth() {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentMonthInt = (calendar?.component(NSCalendar.Unit.month, from: Date()))!
        print(currentMonthInt)
        var currentMonthString = "\(String(currentMonthInt))"
        if(currentMonthInt<10){
            currentMonthString = "0\(String(currentMonthInt))"
        }
        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        
        
        
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/getMealByUserMonth.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["emailUser":  UserEmail , "month":  currentMonthString, "year": currentYearInt ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    
                    self.ActivitiesArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                }
                if self.ActivitiesArray.count > 0 {
                    self.tableView.reloadData()
                } else {
                    
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
    }
    
    func FetchDataYear() {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        print(currentYearInt)
        
        
        
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/getMealByUserYear.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["emailUser":  UserEmail , "year":  currentYearInt ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    
                    self.ActivitiesArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                }
                if self.ActivitiesArray.count > 0 {
                    self.tableView.reloadData()
                } else {
                    
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
    }

}
