//
//  ProfileViewController.swift
//  fitWomanProject
//
//  Created by marwa on 03/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
class ProfileViewController: BaseViewController {
var ActivitiesArray = [AnyObject]()
    let defaults = UserDefaults.standard
    var MarwaBMI:String = ""
    var UserEmail:String = ""
    var UserWeight:String = ""
    var UserHeight:String = ""
    var UserName:String = ""
    var UserFBID:String = ""
    var txtFWeight:String?
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var WeightView: UIView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var BMIView: UIView!
    
    @IBOutlet weak var ActivitiesView: UIView!
    @IBOutlet weak var MealsView: UIView!
   
    @IBOutlet weak var imgProfil: UIImageView!
    
    @IBOutlet weak var titleAddWeight: UILabel!
    @IBOutlet weak var textFieldAddWeight: UITextField!
   
    @IBOutlet weak var LabeluserName: UILabel!
    
    @IBOutlet weak var labelWeight: UILabel!
    
    @IBOutlet weak var labelBMI: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSlideMenuButton()
        
       /* UserFBID = defaults.object(forKey:"idFB") as! String
        let photoUserFB = "http://graph.facebook.com/\(UserFBID)/picture?type=large"
  imgProfil.af_setImage(withURL: URL(string: photoUserFB)!)*/
        ////////////////////////////
        
       // imgProfil.layer.borderWidth = 4
       imgProfil.layer.masksToBounds = false
        imgProfil.layer.cornerRadius = imgProfil.frame.height/2
        imgProfil.clipsToBounds = true
        ////////////////////////////////
        WeightView.layer.shadowColor = UIColor.gray.cgColor
       WeightView.layer.shadowOpacity = 0.3
        WeightView.layer.shadowOffset = CGSize.zero
        WeightView.layer.shadowRadius = 6
        /////////////////////////////////
        BMIView.layer.shadowColor = UIColor.gray.cgColor
       BMIView.layer.shadowOpacity = 0.3
        BMIView.layer.shadowOffset = CGSize.zero
        BMIView.layer.shadowRadius = 6
        BMIView.backgroundColor = UIColor(patternImage: UIImage(named: "Mbtn1")!)
        /////////////////////////////////
        ActivitiesView.layer.shadowColor = UIColor.gray.cgColor
        ActivitiesView.layer.shadowOpacity = 0.3
        ActivitiesView.layer.shadowOffset = CGSize.zero
        ActivitiesView.layer.shadowRadius = 6
        ActivitiesView.backgroundColor = UIColor(patternImage: UIImage(named: "Mbtn5")!)
        /////////////////////////////////
        MealsView.layer.shadowColor = UIColor.gray.cgColor
        MealsView.layer.shadowOpacity = 0.3
        MealsView.layer.shadowOffset = CGSize.zero
        MealsView.layer.shadowRadius = 6
        MealsView.backgroundColor = UIColor(patternImage: UIImage(named: "Mbtn6")!)
        /////////////////////////////////
        
      
        
         UserName =  defaults.object(forKey:"name") as! String
         MarwaBMI = defaults.object(forKey:"bmi") as! String   // !!!!!!!!!
         UserEmail =  defaults.object(forKey:"email") as! String
         UserWeight =  defaults.object(forKey:"weight") as! String
         UserHeight =  defaults.object(forKey:"height") as! String
        
        LabeluserName.text = UserName
         let hello = self.defaults.object(forKey:"weight") as? String
        labelWeight.text = hello! + " kg"
        let  FweightThree = (self.UserWeight as NSString).floatValue
        let  FheightThree = (self.UserHeight as NSString).floatValue
        
        
        let  bmiThree = 10000 * (FweightThree/(FheightThree * FheightThree))
        
        self.labelBMI.text = "\(String(format: "%.2f", bmiThree)) BMI"
     
        txtFWeight = textFieldAddWeight.text!
        
        if( MarwaBMI == "1"){
        labelStatus.text = "Under Weight"
        } else if( MarwaBMI == "2"){
            labelStatus.text = "Normal Weight"
        }
        else if( MarwaBMI == "3"){
            labelStatus.text = "Over Weight"
        }
        /////////////////////////////////////
        existingTest()
        
        
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ProfileViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
        /////////////////////////////////////////////
      /*let rectShape = CAShapeLayer()
        rectShape.bounds = self.mainview.frame
        rectShape.position = self.mainview.center
        rectShape.path = UIBezierPath(roundedRect: self.mainview.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: mainview.frame.height/2 , height: mainview.frame.height/2 )).cgPath
        
  
        self.mainview.layer.mask = rectShape*/
        ///////////////////////////////////////////////
 
    
       
    }
    
   
   
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func addWeight(_ sender: Any) {
        
        
        
        self.txtFWeight = self.textFieldAddWeight.text!
        
        UserEmail =  defaults.object(forKey:"email") as! String
        UserHeight =  defaults.object(forKey:"height") as! String
       
        //////////////////////////////
         let URL_SAVE = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MAddDailyBMI.php"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
         if(textFieldAddWeight.text != ""){
        ///////////////////////////////////////////////////////////
        let requestURL = NSURL(string: URL_SAVE)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        request.httpMethod = "POST"
     
        let two = "&day=" + result
   
        let five = "&emailUser=" + UserEmail
      let six = "&weight=\(textFieldAddWeight.text!)"
       //  let six = "&weight=88"
        let seven = "&height=" + UserHeight
        let postParameters =  two + five + six + seven
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error ")
                return;
            }
            
            do {
               
               // print("hellooo" + self.txtFWeight!)
                self.defaults.removeObject(forKey: "weight")
               self.defaults.synchronize()
               self.defaults.didChangeValue(forKey: "weight")
                self.defaults.set( self.txtFWeight!, forKey: "weight")
                self.defaults.didChangeValue(forKey: "weight")
                print("okkkkk \(self.defaults.object(forKey:"weight")!)")
                
                /////////////////////////////////////////////////////////
                self.defaults.removeObject(forKey: "bmi")
                self.defaults.synchronize()
                 self.defaults.didChangeValue(forKey: "bmi")
                ///////////////////////////////////////////////////////
                let  Fweight = (self.txtFWeight! as NSString).floatValue
                let  Fheight = (self.UserHeight as NSString).floatValue
                
                
                let  bmi = 10000 * (Fweight/(Fheight * Fheight))
                
                if(Float(bmi) > 18.5 && Float(bmi)<25.5){
                    
                    self.defaults.set("2", forKey: "bmi")
                } else if (Float(bmi) < 18.0 ){
                    
                    self.defaults.set("1", forKey: "bmi")
                }else if (Float(bmi) > 25.0 ){
                    
                    self.defaults.set("3", forKey: "bmi")
                }
             //   self.defaults.set( self.txtFWeight!, forKey: "weight")
                self.defaults.didChangeValue(forKey: "bmi")
                print("this is bmi\(self.defaults.object(forKey:"bmi")!)")
                
                ///////////////////////////////////////////////////////////
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
               
                if let parseJSON = myJSON {
                    
                    var msg : String!
                    
                    msg = parseJSON["message"] as! String?
                    
                    print(msg)

                }
          
            } catch {
                print(error)
            }
            DispatchQueue.main.async(execute: {
                let hello = self.defaults.object(forKey:"weight") as? String
                self.labelWeight.text = hello! + " kg"
                let  FweightTwo = (self.txtFWeight! as NSString).floatValue
                let  FheightTwo = (self.UserHeight as NSString).floatValue
                
                
                let  bmiTwo = 10000 * (FweightTwo/(FheightTwo * FheightTwo))
              
                self.labelBMI.text = "\(String(format: "%.2f", bmiTwo)) BMI"
                
                
                if( self.defaults.object(forKey:"bmi")! as? String == "1"){
                    self.labelStatus.text = "Under Weight"
                } else if( self.defaults.object(forKey:"bmi")! as? String == "2"){
                    self.labelStatus.text = "Normal Weight"
                }
                else if( self.defaults.object(forKey:"bmi")! as? String == "3"){
                    self.labelStatus.text = "Over Weight"
                }
                self.textFieldAddWeight.isHidden = true
                self.btnAdd.isHidden = true
                self.titleAddWeight.text = "Daily Weight is Added"
                self.titleAddWeight.textColor = UIColor(red: 200.0/255.0, green: 40.0/255.0, blue: 200.0/255.0, alpha: 1.0)
                self.WeightView.layer.shadowColor = UIColor(red: 200.0/255.0, green: 40.0/255.0, blue: 200.0/255.0, alpha: 1.0).cgColor
            })
        }
    
        task.resume()
      //////////////////////////////////////////
         } else{
            let alert = UIAlertController(title: "Alert", message: "you must to add your weight", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func existingTest(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        ///////////////////////////////////////////////////////////
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetDailyBMIByUserDay.php"
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
                   // self.tableView.reloadData()
                    print(responseData)
                    
                    
                }
                if self.ActivitiesArray.count > 0 {
                    
                    self.textFieldAddWeight.isHidden = true
                       self.btnAdd.isHidden = true
                    self.titleAddWeight.text = "Daily Weight is Added"
                    
                  
                    print(responseData)
                    
                } else {
                    self.textFieldAddWeight.isHidden = false
                    self.btnAdd.isHidden = false
                         self.titleAddWeight.text = "Add Daily Weight"
                }
            }else{
                
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
        
        
    }
 

}

