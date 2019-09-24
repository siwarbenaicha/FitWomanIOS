//
//  MenuViewController.swift
//  fitWomanProject
//
//  Created by marwa on 26/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
protocol SlideMenuDelegate{
    func SlideMenuItemSelectedAtIndex(_index : Int32)
}
class MenuViewController: UIViewController {
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    @IBOutlet weak var btnMenuCloseOverlay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.menuView.backgroundColor = UIColor(patternImage: UIImage(named: "m57")!)
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet var btnCloseTapped: [UIButton]!
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        btnMenu.tag = 0
        btnMenu.isHidden = false
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.SlideMenuItemSelectedAtIndex(_index: index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    @IBAction func btnHomeTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "MHomeViewController") as! MHomeViewController
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    @IBAction func btnWorkoutTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "MWorkoutViewController") as! MWorkoutViewController
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    @IBAction func btnActivitiesTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "MActivitiesViewController") as! MActivitiesViewController
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    @IBAction func btnProfileTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    
    @IBAction func btnDietTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "DietViewController") as! DietViewController
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    @IBAction func btnMealsTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "MealsViewController") as! MealsViewController
        self.navigationController?.pushViewController(DVC, animated: true)
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
