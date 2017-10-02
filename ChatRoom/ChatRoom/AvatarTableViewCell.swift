//
//  AvatarTableViewCell.swift
//  ChatRoom
//
//  Created by Mutian on 4/21/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.
//

import UIKit
import Firebase
class AvatarTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var chatIDLabel: UILabel!
    
    
    // fetch User object from NewMessageController and pass to chatlogcontroller
    var user: User?
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.user?.setValuesForKeys(dictionary)
            }
        }, withCancel: nil)
    }
    
    /**
        Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
     
        @param None
     
        @return None
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2/180 * 30
        self.avatarImageView.layer.borderWidth = 0.5
        self.avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.chatIDLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        fetchUserAndSetupNavBarTitle()
//        
//        if let profileImageUrl = self.user?.profileImageUrl {
//            self.avatarImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//        }
//        self.nicknameLabel.text = user?.name
//        self.chatIDLabel.text = user?.email
        
    }
    /**
        Configure the view for the selected state
     
        @param None
     
        @return None
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
