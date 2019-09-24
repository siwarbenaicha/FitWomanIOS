//
//  DietViewController.swift
//  fitWomanProject
//
//  Created by marwa on 05/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage
class DietViewController: BaseViewController ,UITableViewDataSource , UITableViewDelegate {
    
    let defaults = UserDefaults.standard
    var MarwaBMI:String = ""
    var DietArray = [AnyObject]()
    
    
    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var titleforwelcome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         addSlideMenuButton()
        MarwaBMI = defaults.object(forKey:"bmi") as! String
        FetchData()
        if (MarwaBMI == "1"){
           titleforwelcome.text = "Diet to Gain Weight"
        } else  if (MarwaBMI == "2"){
            titleforwelcome.text = "Diet to Maintain Weight"
        }else  if (MarwaBMI == "3"){
            titleforwelcome.text = "Diet to Loose Weight"
        }
        // Do any additional setup after loading the view.
    }
    func FetchData() {
        
        
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetDietByBMI.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["bmi": MarwaBMI]
        
        // let urlL =  NSURL(string:url as String)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    self.DietArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                    print(responseData)
                    
                }
                if self.DietArray.count > 0 {
                    
                    self.tableView.reloadData()
                    print(responseData)
                    
                }
            }else{
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return DietArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell")
        
        let contentView = cell?.viewWithTag(0)
        
        let DietImg = contentView?.viewWithTag(1) as! UIImageView
        
        let DietName = contentView?.viewWithTag(2) as! UILabel
        let DietDescription = contentView?.viewWithTag(3) as! UILabel
         let DietCalories = contentView?.viewWithTag(4) as! UILabel
         let DietView = contentView?.viewWithTag(5)
        let dietarray  = DietArray[ indexPath.item] as! Dictionary<String,Any>
        
        
        let isHello = dietarray["image"] as! String
        let hello = "http://\(MyIPAddress.IPAddress)/\(isHello)"
        print(hello)
        
        let day = dietarray["Day"] as! String
        let type = dietarray["Type"] as! String
        let calories = dietarray["calories"] as! String
        DietName.text = "Day \(day) : \(type) "
        DietDescription.text = dietarray["description"] as? String
        DietCalories.text = "Calories: \(calories) KCAL "
        DietImg.af_setImage(withURL: URL(string: hello)!)
      
       
        DietView?.layer.cornerRadius = 9
        DietView?.layer.shadowColor = UIColor.gray.cgColor
        DietView?.layer.shadowOpacity = 0.3
        DietView?.layer.shadowOffset = CGSize.zero
        DietView?.layer.shadowRadius = 6
        
        return cell!
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
