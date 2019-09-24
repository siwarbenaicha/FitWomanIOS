//
//  MealsViewController.swift
//  fitWomanProject
//
//  Created by marwa on 05/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage
class MealsViewController: BaseViewController ,UITableViewDataSource , UITableViewDelegate{

    
      let URL_SAVE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MdeleteMeal.php"
    let defaults = UserDefaults.standard
    var ActivitiesArray = [AnyObject]()
    var UserEmail:String = ""
    var MarwaBMI:String = ""
    
    var a:Int = 0
    var c:Int = 0
    var e:Int = 0
    
    var f:Int = 0
    var g:Int = 0
    var h:Int = 0
    
    @IBOutlet weak var AddMealView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var consumed: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var today: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
 addSlideMenuButton()
        
        addSlideMenuButton()
        UserEmail =  defaults.object(forKey:"email") as! String
        MarwaBMI = defaults.object(forKey:"bmi") as! String
        self.tableView.reloadData()
        FetchData()
        let datex = Date()
        let formatterx = DateFormatter()
        formatterx.dateFormat = "yyyy-MM-dd"
        let resultx = formatterx.string(from: datex)
        
        self.today.text = "Today, \(resultx) "
        
        if(MarwaBMI == "1"){
            budget.text = "2500"
            consumed.text = "0"
            remaining.text = "2500"
        }else if(MarwaBMI == "2"){
            budget.text = "2000"
            consumed.text = "0"
            remaining.text = "2000"
        } else if(MarwaBMI == "3"){
            budget.text = "1500"
            consumed.text = "0"
            remaining.text = "1500"
        }
        
        c = Int(budget.text!)!
        
        
        
        
        AddMealView.layer.shadowColor = UIColor.gray.cgColor
        AddMealView.layer.shadowOpacity = 0.3
        AddMealView.layer.shadowOffset = CGSize.zero
       AddMealView.layer.shadowRadius = 6
    }
    func FetchData() {
        ////////////////////////////////////////////////////////////
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        ///////////////////////////////////////////////////////////
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetMealByUserDay.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["emailUser":  UserEmail ,
                                   "day": result]
        
        // let urlL =  NSURL(string:url as String)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    self.ActivitiesArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                    print(responseData)
                    
                    
                }
                if self.ActivitiesArray.count > 0 {
                    self.tableView.isHidden = false
                 //   self.noActivity.isHidden = true
                    
                    self.tableView.reloadData()
                    print(responseData)
                    
                } else {
                    self.tableView.isHidden = true
                    //self.noActivity.isHidden = false
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ActivitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell")
        
        
        let contentView = cell?.viewWithTag(0)
        
        
        
        let ActivityName = contentView?.viewWithTag(1) as! UILabel
       
        let ActivityCalories = contentView?.viewWithTag(2) as! UILabel
       let iew = contentView?.viewWithTag(50) 
        let Activityarray  = ActivitiesArray[ indexPath.item] as! Dictionary<String,Any>
        
        let type = Activityarray["type"] as! String
        let name = Activityarray["name"] as! String
        let totalCal = Activityarray["totalCalories"] as! String
        ActivityName.text = "\(type) : \(name)"
       
        ActivityCalories.text = "Total Calories: \(totalCal) cal"
     
        iew?.layer.cornerRadius = 9
        iew?.layer.shadowColor = UIColor.gray.cgColor
        iew?.layer.shadowOpacity = 0.3
        iew?.layer.shadowOffset = CGSize.zero
        iew?.layer.shadowRadius = 6
        
        if ActivitiesArray.count > e {
            e = e + 1
          
            //budget.text = String(e)
            let b = Int(totalCal)
            a = a + b!
            consumed.text = String(a)
            ///////////////////////
            
            c = c - b!
            remaining.text = String(c)
            ///////////////////////////
            
        }
        
        
    
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            print("delet")
            let ActivityarrayD  = ActivitiesArray[ indexPath.row] as! Dictionary<String,Any>
            let idActivity = ActivityarrayD["id"] as! String
          
            let  ActivityC = ActivityarrayD["totalCalories"] as! String
            //////////////////////////////////////////
            let requestURL = NSURL(string: URL_SAVE_USER)
            
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            request.httpMethod = "POST"
            
            let postParameters = "id=" + idActivity
            
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print("error ")
                    return;
                }
                
                do {
                    
                    let myJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    
                    if let parseJSON = myJSON {
                        
                        var msg : String!
                        
                        msg = parseJSON["message"] as! String?
                        
                        print(msg)
                        
                    }
                } catch {
                    print(error)
                }
                
            }
            task.resume()
            //////////////////////////////////////////
            ActivitiesArray.remove(at: indexPath.row)
            tableView.reloadData()
            if self.ActivitiesArray.count > 0 {
                self.tableView.isHidden = false
              //  self.noActivity.isHidden = true
                if ActivitiesArray.count > f {
                    f = e - 1
                    let b = Int(ActivityC)
                    g = a - b!
                    consumed.text = String(g)
                    ///////////////////////
                    
                    h = c + b!
                    remaining.text = String(h)
                    ///////////////////////////
                    
                }
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
               // self.noActivity.isHidden = false
            
                consumed.text = "0"
                remaining.text = budget.text
            }
            
            
        }
        
        ///////////////////////////
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealDetailViewController") as! MealDetailViewController
        let workoutarray  = ActivitiesArray[indexPath.item] as! Dictionary<String,Any>
        
        popOverVC.BIngredients = workoutarray["ingredients"] as? String
     
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        
        popOverVC.didMove(toParent: self)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
