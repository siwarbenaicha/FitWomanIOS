//
//  MaddActivityViewController.swift
//  fitWomanProject
//
//  Created by marwa on 30/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
class MaddActivityViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource{
   
    var UserEnteredActivity = ""

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var textField: UITextField!
   var ActivityArray = [AnyObject]()
    @IBOutlet weak var tableView: UITableView!
  

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
      textField.delegate = self
        textField.tag = 0
       
        
        btnCancel.layer.cornerRadius = 20
        btnCancel.clipsToBounds = true
        //////////////////////////////
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "msearch1")
        imageView.image = image
        textField.leftView = imageView
        
        
      
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            
            action: #selector(MaddActivityViewController.dismissKeyboard))
         tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
       
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    func FetchData() {
        
        //
        
        
    }
    
    @IBAction func EditChanged(_ sender: UITextField) {
        UserEnteredActivity = sender.text!
        print(UserEnteredActivity )
      ////////////////////////////
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetAllMET.php"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : Parameters = ["name":UserEnteredActivity]
        
        // let urlL =  NSURL(string:url as String)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //
                if let resData = swiftyJsonVar[].arrayObject {
                    self.ActivityArray = resData as [AnyObject]; ()
                    self.tableView.reloadData()
                    print(responseData)
                    
                }
                if self.ActivityArray.count > 0 {
                    
                    self.tableView.reloadData()
                    print(responseData)
                    
                }
            }else{
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
      ////////////////////////////
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell")
        
        let contentView = cell?.viewWithTag(0)
        
  
        
        let ActivityName = contentView?.viewWithTag(1) as! UILabel
        let ActivityImg = contentView?.viewWithTag(2) as! UIImageView
        let workoutarray  = ActivityArray[ indexPath.item] as! Dictionary<String,Any>
      
    
       // let ActivityMet:String?
        ActivityName.text = workoutarray["name"] as? String
       // let ActivityMet = workoutarray["met_value"] as! String
        
        let isHello = workoutarray["icon"] as! String
        let hello = "http://\(MyIPAddress.IPAddress)/\(isHello)"
        ActivityImg.af_setImage(withURL: URL(string: hello)!)
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddActivityPopup") as! MAddActivityNextViewController
        let activityarray  = ActivityArray[indexPath.item] as! Dictionary<String,Any>
        
        popOverVC.BName = activityarray["name"] as? String
        popOverVC.BMet = activityarray["met_value"] as? String
      popOverVC.BIcon = activityarray["icon"] as? String
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
