//
//  IMCResultViewController.swift
//  fitWomanProject
//
//  Created by marwa on 12/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit

class IMCResultViewController: UIViewController {
   
    
 var BMI:Float?
    @IBOutlet weak var lblIMC: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var AView: UIView!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imgg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.defaults.set(true, forKey: "loggedInNew")
        //////////////////////////////
        lblIMC.text = String((BMI?.description)!.prefix(5))
        if(Float(BMI!) > 18.5 && Float(BMI!)<25.5){
            lblStatus.text = " Normal Weight"
            self.defaults.set("2", forKey: "bmi")
        } else if (Float(BMI!) < 18.0 ){
            lblStatus.text = " Underweight"
            self.defaults.set("1", forKey: "bmi")
        }else if (Float(BMI!) > 25.0 ){
            lblStatus.text = " Overweight"
            self.defaults.set("3", forKey: "bmi")
        }
        /////////////////////////////
        let imagesListArray :NSMutableArray = []
        //use for loop
        for position in 1...8
        {
            
            let strImageName : String = "l\(position).png"
            let image  = UIImage(named:strImageName)
            imagesListArray.add(image as Any)
        }
        
        self.imgg.animationImages = (imagesListArray as! [UIImage]);
        self.imgg.animationDuration = 2.0
        self.imgg.startAnimating()
        /////////////////////////////
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /////////////////////////////////
        
        
        ////////////////////////////////
        lblStatus.center.x = view.center.x // Place it in the center x of the view.
        lblStatus.center.x -= view.bounds.width // Place it on the left of the view with the width =
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.lblStatus.center.x += self.view.bounds.width
           
           
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        self.lblIMC.center.x = self.view.center.x // Place it in the center x of the view.
        self.lblIMC.center.x -= self.view.bounds.width // Place it on the left of the view with the
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseOut], animations: {
            self.lblIMC.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
       
        
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
