//
//  ReminderRouteTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 10/8/2021.
//

import UIKit

class ReminderRouteTableViewCell: UITableViewCell {

    @IBOutlet weak var softUIView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var destNumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var route: SetReminderPage.RouteAndStop?
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "ReminderRouteStopTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
        self.softUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softUIView.cornerRadius = 10
        self.softUIView.shadowOffset = .init(width: 2, height: 2)
        self.softUIView.shadowOpacity = UIColor.SoftUI.opacity
        self.backgroundColor = UIColor.SoftUI.major
        self.tableView.backgroundColor = UIColor.SoftUI.major
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        
        self.destNumLabel.textColor = UIColor.MTB.darkGray
    }
    
    func setInfo(_ route: SetReminderPage.RouteAndStop){
        self.route = route
        if let route = self.route{
            self.routeNumLabel.text = route.routeNum
            self.destNumLabel.text = "\("route_to".localized()) \(route.destStop)"
            self.tableView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ReminderRouteTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.route?.targetStops.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! ReminderRouteStopTableViewCell
        if let route = self.route{
            
            cell.setInfo(stop: route.targetStops[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
}
