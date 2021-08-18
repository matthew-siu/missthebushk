//
//  SimpleStopReminderTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 18/8/2021.
//

import UIKit

class SimpleStopReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var softUIView: SoftUIView!
    @IBOutlet weak var reminderImg: UIImageView!
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var reminderPeriodLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MainPage.ReminderItem?
    
    enum CollectionViewCell: String, CollectionViewCellConfiguration {
        case itemCell = "SimpleStopReminderRouteCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CollectionViewCell.itemCell.nib, forCellWithReuseIdentifier: CollectionViewCell.itemCell.reuseId)
    }
    
    func initUI(){
        self.softUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softUIView.cornerRadius = 10
        self.softUIView.shadowOffset = .init(width: 2, height: 2)
        self.softUIView.shadowOpacity = 0.5
        
        self.collectionView.backgroundColor = UIColor.SoftUI.major
    }
    
    func setInfo(viewModel: MainPage.ReminderItem){
        self.viewModel = viewModel
        if let tagViewModel = StopReminder.getTagViewModel(viewModel.type){
            self.reminderImg.image = UIImage(named: tagViewModel.img)
        }
        self.reminderName.text = viewModel.name
        self.reminderPeriodLabel.text = viewModel.period
        self.reminderTimeLabel.text = viewModel.startTime
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SimpleStopReminderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.routes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.itemCell.reuseId, for: indexPath) as! SimpleStopReminderRouteCollectionViewCell
        
        return cell
    }
    
    
}
