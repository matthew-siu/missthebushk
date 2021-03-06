//
//  StopETAItemCollectionViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 23/7/2021.
//

import UIKit

class StopETAItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var etaDisplayLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var busIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension StopETAItemCollectionViewCell{
    func setInfo(viewModel: StopListPage.ETA?){
        if let viewModel = viewModel{
            self.etaDisplayLabel.text = viewModel.display
            self.minuteLabel.text = "stop_mins".localized()
            
            if (viewModel.company == .KMB){
                self.busIcon.image = UIImage(named: "kmbBus")
            }else if (viewModel.company == .CTB){
                self.busIcon.image = UIImage(named: "ctbBus")
            }else if (viewModel.company == .NWFB){
                self.busIcon.image = UIImage(named: "nwfbBus")
            }else if (viewModel.company == .NLB){
                self.busIcon.image = UIImage(named: "nlbBus")
            }
        }
    }
}
