//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2018-01-31.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import TableFlow

class ViewController: UITableViewController {

    lazy var manager: TableManager = {
        return TableManager.init(table: self.tableView)
    }()
    
    var dataSource: [Site] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UITableViewHeaderFooterView.init()
        
        self.refresh()
    }

    func refresh() {
        self.manager.removeAll()
        self.manager.add(section: self.generateSection())
        self.manager.reloadData()
    }
    
    func fillData() {
        let image = Image.named("avatar")
        self.dataSource.append(Site.init(name: "Github", url: "https://github.com", icon: image))
        self.dataSource.append(Site.init(name: "Google", url: "https://google.com", icon: image))
        self.dataSource.append(Site.init(name: "Twitter", url: "https://twitter.com", icon: image))
        self.dataSource.append(Site.init(name: "Facebook", url: "https://facebook.com", icon: image))
        self.dataSource.append(Site.init(name: "Youtube", url: "https://youtube.com", icon: image))
    }
    
    let SECTION_ID = "SECTION_ID"
    
    func generateSection() -> Section {
        self.fillData()
        
        var rows: [Row<SiteInfoTableViewCell>] = []
        for s in dataSource {
            let row = Row<SiteInfoTableViewCell>.init(model: s)
            row.onTap = { r in
                self.alert(s.name)
                return RowTapBehaviour.deselect(true)
            }
            rows.append(row)
        }
        let section = Section.init(id: SECTION_ID, rows: rows)
        return section
    }
    
    func alert(_ text: String) {
        let controller = UIAlertController.init(title: "Message", message: text, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "Done", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}

