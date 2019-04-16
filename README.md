<p align="center">
  <img src="./Assets/TableFlow.jpg" alt="TableFlow"><br/>
  <br/><a href="https://cocoapods.org/pods/TableFlow">
  <img alt="Version" src="https://img.shields.io/badge/version-1.1.0-brightgreen.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Meniny-blue.svg">
  <img alt="Build Passing" src="https://img.shields.io/badge/build-passing-brightgreen.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-5.0%2B-orange.svg">
  <br/>
  <img alt="Platforms" src="https://img.shields.io/badge/platform-iOS-lightgrey.svg">
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <br/>
  <img alt="Cocoapods" src="https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg">
  <img alt="Carthage" src="https://img.shields.io/badge/carthage-working%20on-red.svg">
  <img alt="SPM" src="https://img.shields.io/badge/swift%20package%20manager-working%20on-red.svg">
  </a>
</p>

***

## What's this?

`TableFlow` is a `UITableView` manager.

## Requirements

* iOS 8.0+
* Xcode 9 with Swift 5

## Installation

#### CocoaPods

```ruby
pod 'TableFlow'
```

## Contribution

You are welcome to fork and submit pull requests.

## License

`TableFlow` is open-sourced software, licensed under the `MIT` license.

## Usage

Define a cell:

```swift
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
```

and models:

```swift
import Foundation
import UIKit

public enum Image {
    case named(String)
    case none
    
    public var image: UIImage? {
        switch self {
        case let .named(name):
            return UIImage.init(named: name)
        default:
            return nil
        }
    }
}

public struct Site {
    public let name: String
    public let url: String
    public let icon: Image
}
```

now go:

```swift
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
```
