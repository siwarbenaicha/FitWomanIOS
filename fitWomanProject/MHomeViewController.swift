//
//  MHomeViewController.swift
//  fitWomanProject
//
//  Created by marwa on 21/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class MHomeViewController: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate{

    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var btnActivities: UIButton!
    
    @IBOutlet weak var weights: UIImageView!
    @IBOutlet weak var yoga: UIImageView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var ThirdView: UIView!
    
    @IBOutlet weak var moreWorkout: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    let tabNames = ["Pluse Lunges","Jumping Jacks","Squats"]
    let tabImages = ["pluselunges" ,"jumpingjacks","squats"]
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        addSlideMenuButton()
        print("hello")
       self.lastView.backgroundColor = UIColor(patternImage: UIImage(named: "m57")!)
        lastView.layer.shadowColor = UIColor.gray.cgColor
        lastView.layer.shadowOpacity = 0.3
        lastView.layer.shadowOffset = CGSize.zero
        lastView.layer.shadowRadius = 6
      //   self.SecondView.backgroundColor = UIColor(patternImage: UIImage(named: "m70")!)
        //self.ThirdView.backgroundColor = UIColor(patternImage: UIImage(named: "m71")!)
        
        yoga.layer.masksToBounds = false
        yoga.layer.cornerRadius = yoga.frame.height/2
       yoga.clipsToBounds = true
      
        
        
        weights.layer.masksToBounds = false
        weights.layer.cornerRadius = weights.frame.height/2
       weights.clipsToBounds = true
    
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath)
        let contentView = cell.viewWithTag(0)
        let iew = contentView?.viewWithTag(300)
        let img = contentView?.viewWithTag(301) as! UIImageView
        let name = contentView?.viewWithTag(302) as! UILabel
     
        img.image = UIImage(named:tabImages[indexPath.item])
        name.text = tabNames[indexPath.item]
     
        img.layer.cornerRadius = 20
        iew?.layer.cornerRadius = 9
        iew?.layer.shadowColor = UIColor.gray.cgColor
        iew?.layer.shadowOpacity = 0.3
        iew?.layer.shadowOffset = CGSize.zero
        iew?.layer.shadowRadius = 6
        return cell
    }
   
    
   
}
