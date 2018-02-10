//
//  ChannelVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 50
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
}
