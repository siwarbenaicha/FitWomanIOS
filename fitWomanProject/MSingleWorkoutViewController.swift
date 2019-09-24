//
//  MSingleWorkoutViewController.swift
//  fitWomanProject
//
//  Created by marwa on 28/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage

class MSingleWorkoutViewController: UIViewController {
    var BName:String?
    var BDescription:String?
    var BSteps:String?
    var BImage:String?
    var BVideo:String?
    var Bmistakes:String?
    var Bmet:String?
    
    @IBOutlet weak var AAImage: UIImageView!
    @IBOutlet weak var AName: UILabel!
    
    @IBOutlet weak var AImage: UIImageView!
    
    @IBOutlet weak var ADescription: UILabel!
    @IBOutlet weak var ASteps: UITextView!
    
    @IBOutlet weak var AMistakes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
        
        self.showAnimate()
        
    }
   
    func showAnimate()
    {
     
        AName.text = BName
        ADescription.text = BDescription
        ASteps.text = BSteps
        AMistakes.text = Bmistakes
        
       print("test")
       
       let hello = "http://\(MyIPAddress.IPAddress)/\(BImage!)"
        AAImage.af_setImage(withURL: URL(string: hello)!)
         print(hello)
        self.AAImage.layer.masksToBounds = true
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var closeMe: UIImageView! //WRONG
    
    @IBAction func closePopup(_ sender: Any) {
         self.removeAnimate()
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
  
}
