//
//  ViewController.swift
//  fitWomanProject
//
//  Created by marwa on 09/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData

class ViewController: UIViewController {
var gradientLayer: CAGradientLayer!
    
    let URL_SAVE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/addUser.php"
    
var UName:String = ""
var UfirstName:String = ""
var UlastName:String = ""
var Uemail:String = ""
var elihowa:String = ""
  
var FormatUser:String?
    
let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            
            performSegue(withIdentifier: "toHomeL", sender: self)}
      
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
    
    @IBAction func loginWithFacebookTapped(_ sender: Any) {
        
        let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self){
            (result , error) in
            if(error == nil){
                let fbLoginresult:FBSDKLoginManagerLoginResult = result!
                if fbLoginresult.grantedPermissions != nil {
                    if(fbLoginresult.grantedPermissions.contains("email")){
                        //////
                        self.getUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    //MARK:- facebook delegate
    func loginButtonDidLogout(_loginButton: FBSDKLoginButton!){
        print ("user logout")
    }
    func getUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email , gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let faceDic = result as! [String:AnyObject]
                    print(faceDic)
                   
                    self.Uemail = faceDic["email"] as! String
                    print(self.Uemail)
                    
                    self.FormatUser = faceDic["id"] as? String
                    print(self.FormatUser!)
                   
                    self.UName = faceDic["name"] as! String
                    print(self.UName)
                    
                    self.UfirstName = faceDic["first_name"] as! String
                    print(self.UfirstName)
                    
                    self.UlastName = faceDic["last_name"] as! String
                    print(self.UlastName)
                    
                    
                 /*   let hkeya = faceDic["picture"] as! Dictionary<String,Any>
                    let abcdefg = hkeya["data"] as! Dictionary<String,Any>
                    self.elihowa = abcdefg["url"] as! String
                    print("houni houni url :" + self.elihowa) */
                    // go to imc view
                 self.performSegue(withIdentifier: "imcSegue", sender: nil)
                    ////////////
                   // self.defaults.set(true, forKey: "loggedIn")
                    self.defaults.set(self.Uemail, forKey: "email")
                    self.defaults.set(self.UName, forKey: "name")
                    self.defaults.set(self.FormatUser!, forKey: "idFB")
                    self.SaveUserData()
                     self.SaveInDB()
                    self.performSegue(withIdentifier: "imcSegue", sender: self)
                   

                }
            }
            )
        }
    }

    func SaveUserData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistContainer = appDelegate.persistentContainer
        let managedContext = persistContainer.viewContext
        let userDescription = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@ ", Uemail)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if(result.count == 0){
                //////////////////
                do {
                    let newUser = NSManagedObject(entity: userDescription!, insertInto: managedContext)
                    newUser.setValue(FormatUser!, forKey: "id")
                    newUser.setValue(Uemail, forKey: "email")
                    newUser.setValue(UName, forKey: "name")
                    newUser.setValue(UfirstName, forKey: "first_name")
                    newUser.setValue(UlastName, forKey: "last_name")
              
                    try managedContext.save()
                    print("ok")
                } catch {
                    print("Failed saving")
                }
              
   }
            else{
                let alert = UIAlertController(title: "Alert", message: "user existe", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
            catch {
            
            print("Failed")
        }
        
    }
    
  /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            let destVC : IMCViewController = segue.destination as! IMCViewController
         //   destVC.UserEmail = Uemail
       
     
    }*/
    
    func SaveInDB()
    {
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_USER)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        

       // print("here is my test" + elihowa)
        let postParameters = "name="+UName+"&email="+Uemail+"&logintype=FB"+"&photo="+self.FormatUser!;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error ")
                return;
            }
            
            //parsing the response
            do {
              
              let myJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }

    }
    //executing the task
    task.resume()
}

}
