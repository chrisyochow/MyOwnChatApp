//
//  AddChannelVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 11/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var channelNameTxt: UITextField!
    @IBOutlet weak var channelDescriptionTxt: UITextField!
    
    @IBOutlet weak var createBtn: RoundCornerButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        setupUserInteraction(enableOrNot: true)
        
        channelNameTxt.attributedPlaceholder = NSAttributedString(string: "channel name", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        channelDescriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTap))
        bgView.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap() {
        if channelNameTxt.isEditing || channelDescriptionTxt.isEditing {
            view.endEditing(true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func setupUserInteraction(enableOrNot: Bool) {
        self.channelNameTxt.isUserInteractionEnabled = enableOrNot
        self.channelDescriptionTxt.isUserInteractionEnabled = enableOrNot
        self.createBtn.isUserInteractionEnabled = enableOrNot
        self.closeBtn.isUserInteractionEnabled = enableOrNot
        self.bgView.isHidden = !enableOrNot
        self.coverView.isHidden = enableOrNot
        self.spinner.isHidden = enableOrNot
        if enableOrNot {
            self.spinner.stopAnimating()
            self.createBtn.setTitle("Create", for: .normal)
        } else {
            spinner.startAnimating()
            self.createBtn.setTitle(" ", for: .normal)
        }
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        guard let channelName = channelNameTxt.text, channelNameTxt.text != "" else { return }
        guard let channelDescription = channelDescriptionTxt.text, channelDescriptionTxt.text != "" else { return }
        
        setupUserInteraction(enableOrNot: false)
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("cannot add a channel...")
            }
            
            self.setupUserInteraction(enableOrNot: true)
        }
//        MessageService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
//            if success {
//                print("a new channel is added...")
//
////                NotificationCenter.default.post(name: NOTIF_NEW_CHANNEL_ADDED, object: nil)
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                print("cannot add a channel...")
//            }
//
//            self.setupUserInteraction(enableOrNot: true)
//        }
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
