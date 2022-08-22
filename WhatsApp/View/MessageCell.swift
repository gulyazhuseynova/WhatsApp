//
//  MessageCell.swift
//  WhatsApp
//
//  Created by Gulyaz Huseynova on 21.08.22.
//

import UIKit

class MessageCell: UITableViewCell {
    

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        rightImageView.layer.cornerRadius = rightImageView.frame.size.height / 2
        leftImageView.layer.cornerRadius = leftImageView.frame.size.height / 2
        
        messageBubble.layer.borderWidth = 0.2
        rightImageView.layer.borderWidth = 0.2
        leftImageView.layer.borderWidth = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
