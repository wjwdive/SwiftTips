//
//  WJWHomeViewController.swift
//  SwiftTips
//
//  Created by wjw on 2021/4/22.
//

import UIKit
import SnapKit

class WJWHomeViewController: WJWBaseViewController, UITableViewDelegate, UITableViewDataSource {
 
    var menuData : Array<String>?
    var menuSubViewControllerName : Array<String>?
//    var menuTabview: UITableView!
    
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuData = ["11", "22", "GCD", "Whisper"]
        self.menuSubViewControllerName = ["WJWMyViewController", "WJWMyViewController", "WJWGCDViewController", "WJWWhisperViewController"]
        
        self.configUI()
        self.menuTabview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = self.menuData?[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = classFromStr((self.menuSubViewControllerName?[indexPath.row])!)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func configUI() {
        self.view.addSubview(self.menuTabview)
        self.menuTabview.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
    }
    
    lazy var menuTabview : UITableView = {
        let tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    func swap<T>(first:inout T, second: inout T) -> (T, T){
        (second, first) = (first, second)
        return (second, first)
    }
}
