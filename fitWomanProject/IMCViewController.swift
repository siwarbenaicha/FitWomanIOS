//
//  IMCViewController.swift
//  fitWomanProject
//
//  Created by marwa on 10/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import CoreData
class IMCViewController: UIViewController , UITextFieldDelegate{
  let URL_UPDATE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/AddFirst.php"
    
    @IBOutlet weak var TextLogin: UITextField! //weight
    @IBOutlet weak var textPAssword: UITextField! //height
    @IBOutlet weak var btnLogin: UIButton! //confirm
    
    @IBOutlet weak var theView: UIView!
    @IBOutlet weak var textAge: UITextField!
    
    
    
    var UserNameNew:String = ""
    var weight:String = ""
    var height:String = ""
    var age:String = ""
    
    var Fweight:Float?
    var Fheight:Float?
    var Iage:Int?
    var bmi:Float?
     let defaults = UserDefaults.standard
    var UserEmail = ""
    //var UserEmail = "my test";
    //@IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var txtNameNew: UITextField!
    
    
    var UserEmailNew:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.bool(forKey: "loggedInNew") == true {
            
            performSegue(withIdentifier: "toHomeNew", sender: self)}
   
        
        
     //    UserName = defaults.object(forKey:"name") as! String
//        lblName.text = "Welcome " + UserName
        
        
        theView.layer.cornerRadius = 20
        theView.clipsToBounds = true
        

        btnLogin.layer.cornerRadius = 20
        btnLogin.clipsToBounds = true
        /////////////////////////
        TextLogin.underlined()
        textPAssword.underlined()
        textAge.underlined()
       txtNameNew.underlined()
        //////////////////////////
        weight = TextLogin.text!
        height = textPAssword.text!
        age = textAge.text!
        UserNameNew = txtNameNew.text!
        //////////////////////////
        TextLogin.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "mscale")
        imageView.image = image
        TextLogin.leftView = imageView
        //////////////////////////
        textPAssword.leftViewMode = UITextField.ViewMode.always
        let imageViewa = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imagea = UIImage(named: "mmeter")
        imageViewa.image = imagea
        textPAssword.leftView = imageViewa
        //////////////////////////
        textAge.leftViewMode = UITextField.ViewMode.always
        let imageViewb = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imageb = UIImage(named: "mcacke")
        imageViewb.image = imageb
         textAge.leftView = imageViewb
        //////////////////////////
        txtNameNew.leftViewMode = UITextField.ViewMode.always
        let imageViewc = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imagec = UIImage(named: "mname2")
        imageViewc.image = imagec
        txtNameNew.leftView = imageViewc
        ///////////////////////////////
        self.TextLogin.delegate = self
        self.textPAssword.delegate = self
        self.textAge.delegate = self
        self.txtNameNew.delegate = self
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(IMCViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
        ///////////////////////
         addGradientToView(view: view)
        
    }
    func addGradientToView(view: UIView)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        
        let colorTop =  UIColor(red: 74.0/255.0, green: 18.0/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        let colorMiddle = UIColor(red: 153.0/255.0, green: 0.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        let colorBottom = UIColor(red: 204.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorMiddle,  colorBottom]
        
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
  
    @IBAction func getUserBMI(_ sender: Any) {
       //  self.defaults.set(TextLogin.text , forKey: "weight")
        // self.defaults.set(textPAssword.text , forKey: "height")
        if (TextLogin.text != "" || textPAssword.text != "" || textAge.text != "" ) {
          //  self.defaults.set(true, forKey: "loggedIn")
            Fweight = (TextLogin.text! as NSString).floatValue
            Fheight = (textPAssword.text! as NSString).floatValue
            Iage = Int(age)
            if ((Fweight?.isLess(than: 25))! || (Fheight?.isLess(than: 50))!){
                let alert = UIAlertController(title: "Data out of range", message: "Application made for weight between 25 250kg, Height between 50 and 250cm", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else if ((Fweight?.isLess(than: 250))! || (Fheight?.isLess(than: 250))!){
                bmi = 10000 * (Fweight!/(Fheight! * Fheight!))
                
                print("your bmi is" + String(bmi!))
                AddUserInDB()
                
                self.defaults.set(self.txtNameNew.text , forKey: "name")
                self.defaults.set(self.UserEmailNew , forKey: "email")
                self.defaults.set(self.TextLogin.text , forKey: "weight")
                self.defaults.set(self.textPAssword.text , forKey: "height")
               // self.defaults.set(true, forKey: "loggedInNew")
                self.defaults.synchronize()
                
                self.performSegue(withIdentifier: "toimcResult", sender: nil)
            }else{
                let alert = UIAlertController(title: "Data out of range", message: "Application made for weight between 25 250kg, Height between 50 and 250cm", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            
        }else{
            let alert = UIAlertController(title: "Alert", message: "you must to add all your data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if UserDefaults.standard.bool(forKey: "loggedInNew") != true {
            
            let destVCI : IMCResultViewController = segue.destination as! IMCResultViewController
            destVCI.BMI = bmi
            
        }
        
        
        
    }
    func AddUserInDB(){
       //  UserEmail = defaults.object(forKey:"email") as! String
        let datex = Date()
        let formatterx = DateFormatter()
        formatterx.dateFormat = "yyyy-MM-dd hh:mm"
        let resultx = formatterx.string(from: datex)
        
        let number = Int.random(in: 999 ... 99999)
       UserEmailNew = txtNameNew.text!+"IOS\(resultx)"+String(number)
            
        let requestURL = NSURL(string: URL_UPDATE_USER)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        let postParameters = "nom="+txtNameNew.text!+"&email="+UserEmailNew+"&lastWeight="+TextLogin.text!+"&height="+textPAssword.text!+"&age="+textAge.text!+"&logintype=IOSApp";
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
        /////////////////////////////////
    
    }
    

}
