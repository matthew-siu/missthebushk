//
//  StopItemTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 21/7/2021.
//

import UIKit


protocol StopItemCellDelegate: class {
    func setReminder(stop: KmbStop)
    func readReminder()
}

class StopItemTableViewCell: UITableViewCell {

    @IBOutlet weak var softBgView: SoftUIView!
    @IBOutlet weak var touchArea: UIView! // allow touch happen when has SoftUIView
    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    @IBOutlet weak var routePoint: UIView!
    @IBOutlet weak var missBusIcon: UILabel!
    @IBOutlet weak var upperRouteLine: UIView!
    @IBOutlet weak var lowerRouteLine: UIView!
    
    @IBOutlet weak var etaCollectionView: UICollectionView!
    
    enum CollectionViewCell: String, CollectionViewCellConfiguration {
        case itemCell = "StopETAItemCollectionViewCell"
    }
    
    var delegate: StopItemCellDelegate?
    var stop: KmbStop?
    var isBookmarked = false
    var etaList: StopListPage.DisplayItem.ViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initUI()
        self.etaCollectionView.register(CollectionViewCell.itemCell.nib, forCellWithReuseIdentifier: CollectionViewCell.itemCell.reuseId)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension StopItemTableViewCell{
    
    func initUI(){
        self.missBusIcon.text = "👋🏻"
        self.bookmarkBtn.tintColor = #colorLiteral(red: 0.4678121805, green: 0.4678237438, blue: 0.4678175449, alpha: 1)
        
        self.layer.shadowRadius = self.frame.width / 2 // already type in storyboard.
        self.addShadow(self.routePoint)
        self.addShadow(self.missBusIcon)
        self.addShadow(self.bookmarkBtn, opacity: 0.5)
        
        
        self.bookmarkBtn.addTarget(self, action: #selector(onClickBookmark), for: .touchUpInside)
    }
    
    @objc func onClickBookmark(){
//        self.setIsBookMark(!self.isBookmarked)
        if let stop = self.stop {
            if (!isBookmarked){
                self.delegate?.setReminder(stop: stop)
            }else{
                self.delegate?.readReminder()
            }
            
        }
        
    }
    
    private func setIsBookMark(_ bookmark: Bool){
        self.isBookmarked = bookmark
        let imgName = (self.isBookmarked) ? "bell2" : "bell"
        self.bookmarkBtn.setImage(UIImage(named: imgName)!.withRenderingMode((self.isBookmarked) ? .alwaysOriginal : .alwaysTemplate), for: .normal)
        self.missBusIcon.isHidden = !self.isBookmarked
        
    }
    
    private func addShadow(_ obj: UIView, opacity: Float? = 0.7, offset: CGSize? = CGSize(width: 1, height: 1), color: CGColor? = UIColor.darkGray.cgColor){
        if let opacity = opacity, let offset = offset, let color = color {
            obj.layer.shadowOpacity = opacity
            obj.layer.shadowOffset = offset
            obj.layer.shadowColor = color
        }
    }
    
    func setInfo(index: Int, stop: KmbStop, isSelected: Bool, count: Int, isBookmarked: Bool){
        
        self.etaCollectionView.delegate = self
        self.etaCollectionView.dataSource = self
        
        self.stop = stop
        self.indexLabel.text = "\(index)."
        self.indexLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        
        self.stopNameLabel.text = "\(self.stop?.name ?? "---")"
        self.stopNameLabel.useTextStyle(.label)
        self.stopNameLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        self.softBgView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softBgView.cornerRadius = 10
        self.softBgView.shadowOffset = .init(width: 1, height: 1.5)
        self.softBgView.shadowOpacity = 1
        
        // route indicator
        self.upperRouteLine.alpha = (index == 1) ? 0 : 1
        self.lowerRouteLine.alpha = (index == count) ? 0 : 1
        
        self.softBgView.isSelected = isSelected
        
        self.setIsBookMark(isBookmarked)
        
        if (isSelected){ // expanded view
            self.stopNameLabel.numberOfLines = 0
            self.etaCollectionView.reloadData()
            self.etaCollectionView.isHidden = false
//            self.etaCollectionView.backgroundColor = UIColor.SoftUI.major
        }else{ // default view
            self.stopNameLabel.numberOfLines = 1
            self.etaCollectionView.isHidden = true
        }
        
    }
    
    func setETA(etaList: StopListPage.DisplayItem.ViewModel?){
        self.etaList = etaList
        if let _ = etaList {
            print("etaCollectionView: setETA")
            self.etaCollectionView.reloadData()
        }
    }
}

extension StopItemTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.etaList?.etaViews.count ?? 0
    }
    
    // UICollectionViewDelegateFlowLayout: change size of view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.stopNameLabel.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.itemCell.reuseId, for: indexPath) as! StopETAItemCollectionViewCell
        cell.setInfo(viewModel: self.etaList?.etaViews[indexPath.row])
        
        return cell
    }
    
    
    
}
