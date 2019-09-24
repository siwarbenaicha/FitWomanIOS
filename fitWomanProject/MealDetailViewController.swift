//
//  MealDetailViewController.swift
//  fitWomanProject
//
//  Created by marwa on 05/12/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {

    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var theView: UIView!
    
    var BIngredients:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var closeee: UIImageView!
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        ingredients.text = BIngredients
       
        // AAImage.image = UIImage(named: "m19")
    }
    @IBAction func closeMe(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
