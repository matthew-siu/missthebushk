//
//  NoItemTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 5/8/2021.
//

import UIKit

class NoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var noItemImg: UIImageView!
    @IBOutlet weak var noItemLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.noItemImg.setImageColor(color: UIColor.MTB.darkGray)
        self.noItemLabel.textColor = UIColor.MTB.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(_ img: UIImage?, _ label: String?){
        if let img = img{
            self.noItemImg.image = img
            self.noItemImg.setImageColor(color: UIColor.MTB.darkGray)
        }
        if let label = label{
            self.noItemLabel.text = label
        }
        
    }
    
}
