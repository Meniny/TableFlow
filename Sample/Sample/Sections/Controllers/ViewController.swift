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
        self.tableView.rowHeight = UITableView.automaticDimension
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
        
        let section = Section.init(id: SECTION_ID, rows: [])
        
        for s in dataSource {
            // Or use the typealias: `SiteRow`
            let row = Row<SiteInfoTableViewCell>.init(model: s)
            row.onTap({ (r) -> (RowTapBehaviour?) in
                self.alert(s.name)
                return RowTapBehaviour.deselect(true)
            })
            section.add(row)
        }
        
        // Or use `Row<SwitchTableViewCell>`
        let switchRow = SwitchRow.init(title: "Require PC version", isOn: true)
        switchRow.onChange { (config) in
            self.alert("\(config.title ?? ""): \(config.isOn)")
        }
        section.add(switchRow)
        
        let selectionRow = SelectionRow.init(mode: .present, title: "Your age", select: "19", in: "18", "19", "20", "21", "22", "23")
        selectionRow.accessoryType = .disclosureIndicator
        selectionRow.onChange { (r) in
            self.alert(r.default ?? "")
        }
        section.add(selectionRow)
        
        return section
    }
    
    func alert(_ text: String) {
        let controller = UIAlertController.init(title: "Message", message: text, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "Done", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}

