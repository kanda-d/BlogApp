//
//  PostDetailsViewController.swift
//  TryHarder
//
//  Created by Akhil Chaudhary on 10/10/20.
//

import UIKit
import Kingfisher

class PostDetailsViewController: UIViewController {

    var c: Int = 0
    var dicData = [Int: String]()

    @IBOutlet weak var heartCheck: UIImageView!
    
    @IBOutlet weak var descView: UILabel!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostDetailsViewController.heartTapped(gesture:)))

        // add it to the image view;
        heartCheck.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        heartCheck.isUserInteractionEnabled = true
        
        
      titleView.text = dicData[0]!
        descView.text = dicData[1]!
        
       let url = URL(string: dicData[2]!)
     imageView.kf.setImage(with: url)

        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func heartTapped(gesture: UIGestureRecognizer) {
            // if the tapped view is a UIImageView then set it to imageview
            if (gesture.view as? UIImageView) != nil {
                
                if c == 1 {
                    self.heartCheck.image = UIImage(named: "darkheart"); c=0 }
                else
                { self.heartCheck.image = UIImage(named: "redheart"); c=1 }

                

            }
        }

    
    

 

}
