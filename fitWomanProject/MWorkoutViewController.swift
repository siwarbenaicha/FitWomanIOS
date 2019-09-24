//
//  MWorkoutViewController.swift
//  fitWomanProject
//
//  Created by marwa on 25/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage

class MWorkoutViewController: BaseViewController ,UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var theView: UIView!
    
    @IBOutlet weak var lblWorkoutType: UILabel!
    let defaults = UserDefaults.standard
  var MarwaBMI:String = ""
    var WorkoutArray = [AnyObject]()
  
    @IBOutlet weak var tableView: UITableView!
  
    func FetchData() {
  
  
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetWorkoutByBMI.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["bmi": MarwaBMI]
        
       // let urlL =  NSURL(string:url as String)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    self.WorkoutArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                    print(responseData)
                   
                }
                if self.WorkoutArray.count > 0 {
                   
                    self.tableView.reloadData()
                    print(responseData)
 
                }
            }else{
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         MarwaBMI = defaults.object(forKey:"bmi") as! String
        print(MarwaBMI)
        addSlideMenuButton()
        FetchData()
        // Do any additional setup after loading the view.
        
        
        
       
        if (MarwaBMI == "1"){
            lblWorkoutType.text = "to Gain Weight"
        } else  if (MarwaBMI == "2"){
            lblWorkoutType.text = "to Maintain Weight"
        }else  if (MarwaBMI == "3"){
           lblWorkoutType.text = "to Loose Weight"
        }
        
        
        
       theView.layer.shadowColor = UIColor.gray.cgColor
        theView.layer.shadowOpacity = 0.3
        theView.layer.shadowOffset = CGSize.zero
        theView.layer.shadowRadius = 6
      //  theView.backgroundColor = UIColor(patternImage: UIImage(named: "m71")!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")
        
        let contentView = cell?.viewWithTag(0)
        
        let workoutImg = contentView?.viewWithTag(1) as! UIImageView
        
        let workoutName = contentView?.viewWithTag(2) as! UILabel
        let workoutDescription = contentView?.viewWithTag(3) as! UILabel
        let workoutarray  = WorkoutArray[ indexPath.item] as! Dictionary<String,Any>
        
   
        let isHello = workoutarray["Image"] as! String
        let hello = "http://\(MyIPAddress.IPAddress)/\(isHello)" 
        print(hello)
     
        workoutName.text = workoutarray["Name"] as? String
        workoutDescription.text = workoutarray["Description"] as? String
    
        workoutImg.af_setImage(withURL: URL(string: hello)!)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkoutPopup") as! MSingleWorkoutViewController
        
 
        
        let workoutarray  = WorkoutArray[indexPath.item] as! Dictionary<String,Any>
   
        popOverVC.BName = workoutarray["Name"] as? String
         popOverVC.BDescription = workoutarray["Description"] as? String
         popOverVC.BSteps = workoutarray["Steps"] as? String
         popOverVC.BImage = workoutarray["Image"] as? String
         popOverVC.BVideo = workoutarray["Video"] as? String
         popOverVC.Bmistakes = workoutarray["mistakes"] as? String
         popOverVC.Bmet = workoutarray["met"] as? String
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        
        popOverVC.didMove(toParent: self)
      
       
    }

}
