//
//  PushSelectionTableViewCell.swift
//  Pods-Sample
//
//  Created by 李二狗 on 2018/2/1.
//

import UIKit

public typealias SelectionData = (title: String, selections: [String], `default`: String?)

public enum SelectionAppearMode {
    case push
    case present
}

open class SelectionTableViewCell: UITableViewCell, DeclarativeCell {
    public typealias T = SelectionData
    
    public var _onChange: ((SelectionData) -> Void)?
    
    internal var selections: [String] = []
    
//    pri var selectionAppearMode: SelectionAppearMode = .present

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    public var model: SelectionData?
    
    public func configure(_ i: SelectionData, path: IndexPath) {
        self.model = i
        self.selections.removeAll()
        self.selections.append(contentsOf: i.selections)
        self.titleLabel.text = self.model?.title
        self.currentLabel.text = self.model?.default
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
}

public typealias SelectionRow = Row<SelectionTableViewCell>

public extension Row where Cell == SelectionTableViewCell {
    public convenience init(mode: SelectionAppearMode = .present, title: String, select d: String?, in selections: String...) {
        let m: SelectionData = (title: title, selections: selections, default: d)
        self.init(model: m)
        
        let new: ((RowProtocol) -> (RowTapBehaviour?)) = { row in
            let window = UIWindow.init(frame: .zero)
            if let w = UIApplication.shared.keyWindow {
                window.frame = w.frame
            } else {
                window.frame = UIScreen.main.bounds
            }
            window.windowLevel = UIWindowLevelAlert
            window.backgroundColor = UIColor.clear
            
            let next = SelectionTableViewController.init(selections: self.cell?.selections ?? [])
            next.title = self.cell?.titleLabel.text
            next.default = self.cell?.currentLabel.text
            next.onChange = { selected in
                self.cell?.currentLabel.text = selected
                let change: SelectionData = (next.title ?? "", self.cell?.selections ?? [], selected)
                self.cell?._onChange?(change)
                window.rootViewController = nil
                window.hide(animated: true)
            }
            next.onCancel = {
                window.rootViewController = nil
                window.hide(animated: true)
            }
            next.mode = mode
            
            let root = RootViewController.init(next: next)
            
            window.isHidden = false
            window.rootViewController = UINavigationController.init(rootViewController: root)
            
            return RowTapBehaviour.deselect(true)
        }
        self._onTap = new
    }
}

extension UIWindow {
    func hide(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { (f) in
                if f {
                    self.isHidden = true
                    self.alpha = 1
                }
            })
        } else {
            self.isHidden = true
        }
    }
}

class RootViewController: UIViewController {
    let nextController: SelectionTableViewController
    
    init(next nc: SelectionTableViewController) {
        self.nextController = nc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var presented: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !presented {
            if nextController.mode == .present {
                let navi = UINavigationController.init(rootViewController: nextController)
                self.present(navi, animated: true) {
                    self.presented = true
                }
            } else {
                self.navigationController?.pushViewController(nextController, animated: true)
                self.presented = true
            }
        }
    }
}

class SelectionTableViewController: UITableViewController {
    var selections: [String] = []
    var `default`: String?
    
    var onChange: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    var mode: SelectionAppearMode = .present
    
    lazy var manager: TableManager = {
        let m = TableManager.init(table: self.tableView)
        return m
    }()
    
    init(selections: [String]) {
        self.selections.append(contentsOf: selections)
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tableView.tableFooterView = UITableViewHeaderFooterView.init()
        self.loadSelections()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: " ", style: .done, target: nil, action: nil)
    }
    
    @objc
    func cancel() {
        self.onCancel?()
        if self.mode == .present {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func loadSelections() {
        let section = Section.init(id: "\(type(of: self))", rows: [])
        for s in selections {
            let row = TextRow.init(text: s)
            row.onTap({ (r) -> (RowTapBehaviour?) in
                self.onChange?(s)
                self.dismiss(animated: true, completion: nil)
                return RowTapBehaviour.deselect(true)
            })
            if let d = self.default {
                row.accessoryType = (d == s) ? .checkmark : .none
            } else {
                row.accessoryType = .none
            }
            
            section.add(row)
        }
        self.manager.add(section: section)
        self.manager.reloadData()
    }
}
