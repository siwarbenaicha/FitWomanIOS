//
//  MActivitiesViewController.swift
//  fitWomanProject
//
//  Created by marwa on 01/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
class MActivitiesViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {
        let URL_SAVE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MdeleteActivity.php"
    @IBOutlet weak var TotalActivities: UILabel!
    
    @IBOutlet weak var TotalCalories: UILabel!
    
    @IBOutlet weak var TotalMinutes: UILabel!
 
    
    let defaults = UserDefaults.standard
    var ActivitiesArray = [AnyObject]()
     var UserEmail:String = ""

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noActivity: UILabel!
    
    @IBOutlet weak var btnMarwa: UIButton!
    
    @IBOutlet weak var today: UILabel!
    
    
    var a:Int = 0
    var c:Int = 0
    var e:Int = 0
    var f:Int = 0
    var g:Int = 0
    var h:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        UserEmail =  defaults.object(forKey:"email") as! String
        self.tableView.reloadData()
        

        FetchData()
       
        // Do any additional setup after loading the view.
        let datex = Date()
        let formatterx = DateFormatter()
        formatterx.dateFormat = "yyyy-MM-dd"
        let resultx = formatterx.string(from: datex)
        
        self.today.text = "Today, \(resultx)"
        
        
        btnMarwa.layer.cornerRadius = 20
        btnMarwa.clipsToBounds = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityCell")
        
        
        let contentView = cell?.viewWithTag(0)
        
       
        
        let ActivityName = contentView?.viewWithTag(1) as! UILabel
        let ActivityDuration = contentView?.viewWithTag(2) as! UILabel
        let ActivityCalories = contentView?.viewWithTag(3) as! UILabel
        let ActivityIcon = contentView?.viewWithTag(4) as! UIImageView
        
        let ActivityView = contentView?.viewWithTag(8)
        let Activityarray  = ActivitiesArray[ indexPath.item] as! Dictionary<String,Any>
        
  
        ActivityName.text = Activityarray["name"] as? String
        ActivityDuration.text = Activityarray["duration"] as? String
        ActivityCalories.text = Activityarray["burnedCalories"] as? String
        let isHello = Activityarray["icon"] as! String
        let hello = "http://\(MyIPAddress.IPAddress)/\(isHello)"
        ActivityIcon.af_setImage(withURL: URL(string: hello)!)
       
        
        print ( ActivitiesArray.count )
        if ActivitiesArray.count > e {
            e = e + 1
            TotalActivities.text = String(e)
            let b = Int(ActivityCalories.text!)
            a = a + b!
            TotalCalories.text = String(a)
            ///////////////////////
            let d = Int(ActivityDuration.text!)
            c = c + d!
            TotalMinutes.text = String(c)
            ///////////////////////////
         
        }
        
        ActivityDuration.text = "Duration: \(Activityarray["duration"] as? String ?? "1") Minutes"
        ActivityCalories.text = "Burned Calories: \(Activityarray["burnedCalories"] as? String ?? "1") KCAL"
        ActivityView?.layer.cornerRadius = 9
        ActivityView?.layer.shadowColor = UIColor.gray.cgColor
        ActivityView?.layer.shadowOpacity = 0.3
        ActivityView?.layer.shadowOffset = CGSize.zero
        ActivityView?.layer.shadowRadius = 6
        return cell!
    }
    
    
    func FetchData() {
        ////////////////////////////////////////////////////////////
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        ///////////////////////////////////////////////////////////
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetActivityByUserDay.php"
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
                    self.noActivity.isHidden = true
                  
                    self.tableView.reloadData()
                    print(responseData)
                    
                } else {
                    self.tableView.isHidden = true
                    self.noActivity.isHidden = false
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goHome(_ sender: Any) {
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if(editingStyle == .delete){
            print("delet")
        let ActivityarrayD  = ActivitiesArray[ indexPath.row] as! Dictionary<String,Any>
           let idActivity = ActivityarrayD["id"] as! String
          let   ActivityD = ActivityarrayD["duration"] as! String
           let  ActivityC = ActivityarrayD["burnedCalories"] as! String
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
                self.noActivity.isHidden = true
                if ActivitiesArray.count > f {
                    f = e - 1
                    TotalActivities.text = String(f)
                    let b = Int(ActivityC)
                    g = a - b!
                    TotalCalories.text = String(g)
                    ///////////////////////
                    let d = Int(ActivityD)
                    h = c - d!
                    TotalMinutes.text = String(h)
                    ///////////////////////////
                    
                }
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.noActivity.isHidden = false
                TotalActivities.text = "0"
                TotalCalories.text = "0"
                 TotalMinutes.text = "0"
            }
           
            
        }
       
            ///////////////////////////
            
        }
}
    
    

