//
//  SiteInfoTableViewCell.swift
//  Sample
//
//  Created by Meniny on 2018-01-31.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit

public struct SwitchCellConfig {
    public var title: String?
    public var isOn: Bool
    
    public init(title: String?, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
}

open class SwitchTableViewCell: UITableViewCell, DeclarativeCell {
    public typealias T = SwitchCellConfig
    
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var _onChange: ((SwitchCellConfig) -> Void)?
    
    public var model: SwitchCellConfig?
    
    public func configure(_ i: SwitchCellConfig, path: IndexPath) {
        self.model = i
        self.switchControl.isOn = self.model?.isOn ?? false
        self.titleLabel.text = self.model?.title
    }
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        self._onChange?(SwitchCellConfig.init(title: self.titleLabel.text, isOn: sender.isOn))
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
    
}

public typealias SwitchRow = Row<SwitchTableViewCell>

public extension Row where Cell == SwitchTableViewCell {
    public convenience init(title: String?, isOn: Bool) {
        self.init(model: SwitchCellConfig.init(title: title, isOn: isOn))
    }
}
