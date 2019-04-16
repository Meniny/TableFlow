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
    public var model: Site?
    
    public typealias T = Site
    
    public var _onChange: ((Site) -> Void)?
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    public func configure(_ site: Site, path: IndexPath) {
        self.model = site
        self.titleLabel.text = self.model?.name
        self.urlLabel.text = self.model?.url
        self.iconView.image = self.model?.icon.image
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
    
}

public typealias SiteRow = Row<SiteInfoTableViewCell>

public extension Row where Cell == SiteInfoTableViewCell {
    convenience init(name: String, url: String, icon: Image) {
        self.init(model: Site.init(name: name, url: url, icon: icon))
    }
}
