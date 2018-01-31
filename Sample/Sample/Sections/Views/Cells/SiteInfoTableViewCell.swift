//
//  SiteInfoTableViewCell.swift
//  Sample
//
//  Created by Meniny on 2018-01-31.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import TableFlow

open class SiteInfoTableViewCell: UITableViewCell, DeclarativeCell {

    public typealias T = Site
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    public func configure(_ site: Site, path: IndexPath) {
        self.titleLabel.text = site.name
        self.urlLabel.text = site.url
        self.iconView.image = site.icon.image
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
    
}
