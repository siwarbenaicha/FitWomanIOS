//
//  MAddActivityNextViewController.swift
//  fitWomanProject
//
//  Created by marwa on 30/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage
class MAddActivityNextViewController: UIViewController , UITextViewDelegate{
    var BName:String?
    var BMet:String?
    var BIcon:String?
    
    @IBOutlet weak var btnCancelMe: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var AName: UILabel!
    @IBOutlet weak var ADuration: UITextField!
    
    @IBOutlet weak var ActivityImg: UIImageView!
    
    let defaults = UserDefaults.standard
    var UserEmail:String = ""
    var UserWeight:String = ""
    
    
    let URL_SAVE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MaddActivity.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ADuration.delegate = self as! UITextFieldDelegate
        
        
        btnSave.layer.cornerRadius = 20
        btnSave.clipsToBounds = true
        
        btnCancelMe.layer.cornerRadius = 20
        btnCancelMe.clipsToBounds = true
        ////////
        AName.text = BName
        
      //////////////////////
      
        let hello = "http://\(MyIPAddress.IPAddress)/" + BIcon!
        print("hello" + hello)
        ActivityImg.af_setImage(withURL: URL(string: hello)!)
         //////////////////////
        ADuration.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "mtimer1")
        imageView.image = image
        ADuration.leftView = imageView
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MAddActivityNextViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ADuration{
            let allowingChars = "0123456789"
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        }
        return true
    }
  /*  func showAnimate()
    {
       self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });

    }*/
    
    @IBAction func goBack(_ sender: Any) {
       // self.removeAnimate()
        // dismiss(animated: true, completion: nil)
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    @IBAction func SaveActivity(_ sender: Any) {
        // counte burned calories
      UserEmail =  defaults.object(forKey:"email") as! String
        UserWeight =  defaults.object(forKey:"weight") as! String
       ////////////////////////////////////////////////////////////
       let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        if(ADuration.text != ""){
        ///////////////////////////////////////////////////////////
        let requestURL = NSURL(string: URL_SAVE_USER)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        request.httpMethod = "POST"
        let one = "name=" + BName!
        let two = "&day=" + result
        let three = "&duration=" + ADuration.text!
        let four = "&met=" + BMet!
        let five = "&emailUser=" + UserEmail
        let six = "&weight=" + UserWeight
         let seven = "&icon=" + BIcon!
        let postParameters = one + two + three + four + five + six + seven
        
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
        ///////////////////////////////////////////////////////////
        } else{
    let alert = UIAlertController(title: "Alert", message: "you must to add the duration", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }
         self.performSegue(withIdentifier: "toMyActivities", sender: nil)
   
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
