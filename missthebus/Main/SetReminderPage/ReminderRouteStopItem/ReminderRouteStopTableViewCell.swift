//
//  ReminderRouteStopTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 10/8/2021.
//

import UIKit

class ReminderRouteStopTableViewCell: UITableViewCell {

    @IBOutlet weak var stopImg: UIImageView!
    @IBOutlet weak var stopLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.SoftUI.major
        self.stopImg.addShadow()
    }
    
    func setInfo(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
