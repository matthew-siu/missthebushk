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
        print("StopETAItemCollectionViewCell: setInfo")
        if let viewModel = viewModel{
            print("display: \(viewModel.display)")
            self.etaDisplayLabel.text = viewModel.display
            self.minuteLabel.text = "min(s)"
            if (viewModel.company == .KMB){
                
            }
        }
    }
}
