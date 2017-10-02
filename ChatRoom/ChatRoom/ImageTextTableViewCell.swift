//
//  ImageTextTableViewCell.swift
//  ChatRoom
//
//  Created by Mutian on 4/21/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.
//


import UIKit

class ImageTextTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    /**
        Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
     
        @param None
     
        @return None
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        // Initialization code
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
