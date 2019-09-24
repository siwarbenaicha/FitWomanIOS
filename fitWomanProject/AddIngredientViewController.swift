//
//  AddIngredientViewController.swift
//  fitWomanProject
//
//  Created by marwa on 05/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AddIngredientViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
var UserEnteredActivity = ""
       var ActivityArray = [AnyObject]()
    

    @IBOutlet weak var btnSaveClose: UIButton!
    @IBOutlet weak var btnSaveAdd: UIButton!
    @IBOutlet weak var Iname: UITextField!
    @IBOutlet weak var IQuantity: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var BName:String?
    var BCalories:String?
    
    let defaults = UserDefaults.standard
    var UserEmail:String = ""
    var UserWeight:String = ""
    
    
    let URL_UPDATE = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MUpdateMeal.php"
    override func viewDidLoad() {
        super.viewDidLoad()
        Iname.delegate = self
        Iname.tag = 0
        
        self.tableView.isHidden = true
        
        btnSaveAdd.layer.cornerRadius = 20
        btnSaveAdd.clipsToBounds = true
        btnSaveClose.layer.cornerRadius = 20
        btnSaveClose.clipsToBounds = true
        //////////////////////////////
        Iname.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "msearch1")
        imageView.image = image
        Iname.leftView = imageView
        //////////////////////////////
        IQuantity.leftViewMode = UITextField.ViewMode.always
        let imageViewa = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imagea = UIImage(named: "mkg1")
        imageViewa.image = imagea
        IQuantity.leftView = imageViewa
        
        
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddIngredientViewController.dismissKeyboard))
         tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @IBAction func EditChanged(_ sender: UITextField) {
        UserEnteredActivity = sender.text!
        print(UserEnteredActivity )
        ////////////////////////////
        
        let url = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MgetAllIngredient.php"
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
                     self.tableView.isHidden = false
                    self.tableView.reloadData()
                    print(responseData)
                    
                }else{
                    self.tableView.isHidden = true
                }
            }else{
                print(responseData)
                print(responseData.result.value as Any)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ActivityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ICell")
        
        let contentView = cell?.viewWithTag(0)
        
        
        
        let IngName = contentView?.viewWithTag(1) as! UILabel
        
        let workoutarray  = ActivityArray[ indexPath.item] as! Dictionary<String,Any>
        
        
       // let IngCalories:String?
        IngName.text = workoutarray["name"] as? String
    //  let  IngCalories = workoutarray["calories"] as? String
        
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let activityarray  = ActivityArray[indexPath.item] as! Dictionary<String,Any>
        
        BName = activityarray["name"] as? String
        BCalories = activityarray["calories"] as? String
        
        
        
        
    }
    
    
    @IBAction func SaveAndAddMore(_ sender: Any) {
        if( BName != nil && IQuantity.text != ""){
            UpdateIngredients()
        }else{
            let alert = UIAlertController(title: "Alert", message: "you have to select an ingredient and/or quantity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       self.performSegue(withIdentifier: "toAddIngMore", sender: nil)
    }
    
    @IBAction func SaveAndClose(_ sender: Any) {
        if( BName != nil && IQuantity.text != ""){
            UpdateIngredients()
        }else{
            let alert = UIAlertController(title: "Alert", message: "you have to select an ingredient and/or quantity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.performSegue(withIdentifier: "toMyMeals", sender: nil)
    }
    
    func UpdateIngredients()
    { UserEmail = defaults.object(forKey:"email") as! String
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)

        
        
        
        let requestURL = NSURL(string: URL_UPDATE)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        let one = "day=" + result
        let two = "&nameI=" + BName!
        let three = "&quantity=" + IQuantity.text!
        let four = "&calories=" + BCalories!
        let five = "&emailUser=" + UserEmail
        let postParameters = one + two + three + four + five;
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
          
            if error != nil{
                print("error ")
                return;
            }
            
            do {
              
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
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
