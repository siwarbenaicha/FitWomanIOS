//
//  AddMealViewController.swift
//  fitWomanProject
//
//  Created by marwa on 05/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit

class AddMealViewController: UIViewController {
    @IBOutlet weak var MealName: UITextField!
    
    @IBOutlet weak var valueType: UISegmentedControl!
    @IBOutlet weak var MealType: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancelee: UIButton!
    let defaults = UserDefaults.standard
    var UserEmail:String = ""
    var UserWeight:String = ""
    var TheSegmentChoosedType = "Breakfast"
    
    let URL_SAVE_USER = "http://\(MyIPAddress.IPAddress)/FitWomanServicesIOS/MaddMeal.php"
    override func viewDidLoad() {
        super.viewDidLoad()
      
        btnSave.layer.cornerRadius = 20
        btnSave.clipsToBounds = true
        
        btnCancelee.layer.cornerRadius = 20
        btnCancelee.clipsToBounds = true
        //////////////////////////////
        MealName.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "mmeal1")
        imageView.image = image
        MealName.leftView = imageView
        
        
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddMealViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @IBAction func SaveMeal(_ sender: Any) {
     
        UserEmail =  defaults.object(forKey:"email") as! String
        UserWeight =  defaults.object(forKey:"weight") as! String
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        if(MealName.text != ""){
        ////////////////////////////////
        let requestURL = NSURL(string: URL_SAVE_USER)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        request.httpMethod = "POST"
        let one = "name=" + MealName.text!
        let two = "&day=" + result
        let three = "&type=" +  TheSegmentChoosedType
        
        let five = "&emailUser=" + UserEmail
       
        let postParameters = one + two + three + five 
        
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
 
       
        self.performSegue(withIdentifier: "toAddIng", sender: nil)
    /////////////////////////
    }else{
    let alert = UIAlertController(title: "Alert", message: "you must to add the meal's name", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }
   
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func getTypeData(_ sender: Any) {
        let getIndex = valueType.selectedSegmentIndex
        print(getIndex)
        
        switch (getIndex) {
        case 0:
            
            TheSegmentChoosedType = "Breakfast"
           
        case 1:
           TheSegmentChoosedType = "Lunch"
     
            
        case 2:
           TheSegmentChoosedType = "Dinner"
   
        case 3:
            TheSegmentChoosedType = "Snack"
         
            
        default:
            print("no select")
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

}
