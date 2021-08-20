//
//  SimpleStopReminderTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 18/8/2021.
//

import UIKit

protocol StopReminderCellDelegate: class {
    func onSelectStopReminderCell(_ index: Int)
}

class SimpleStopReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var softUIView: SoftUIView!
    @IBOutlet weak var reminderImg: UIImageView!
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var reminderPeriodLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MainPage.ReminderItem?
    var index = -1
    var delegate: StopReminderCellDelegate?
    
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
        self.bgView.backgroundColor = UIColor.SoftUI.major

        self.softUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softUIView.cornerRadius = 10
        self.softUIView.shadowOffset = .init(width: 2, height: 2)
        self.softUIView.shadowOpacity = 1
        
        self.reminderName.useTextStyle(.label)
        self.reminderPeriodLabel.useTextStyle(.label_sub_mini)
        self.reminderTimeLabel.useTextStyle(.title2_bold)
        
        self.collectionView.backgroundColor = UIColor.SoftUI.major
        
        self.softUIView.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
        let onClicker = UITapGestureRecognizer(target: self, action: #selector(onSelected))
        self.collectionView.addGestureRecognizer(onClicker)
    }
    
    func setInfo(index: Int, viewModel: MainPage.ReminderItem){
        self.index = index
        self.viewModel = viewModel
        if let tagViewModel = StopReminder.getTagViewModel(viewModel.type){
            self.reminderImg.image = UIImage(named: tagViewModel.img)
            self.reminderImg.addShadow()
        }
        self.reminderName.text = viewModel.name
        self.reminderPeriodLabel.text = viewModel.period
        self.reminderPeriodLabel.sizeToFit()
        self.reminderTimeLabel.text = viewModel.startTime
        self.collectionView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func onSelected(){
        print("onSelected")
        self.delegate?.onSelectStopReminderCell(self.index)
    }
    
}

extension SimpleStopReminderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.routes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.itemCell.reuseId, for: indexPath) as! SimpleStopReminderRouteCollectionViewCell
        if let item = self.viewModel?.routes[indexPath.row]{
            cell.setInfo(viewModel: item)
        }
        
        return cell
    }
    
    
}
