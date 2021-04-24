//
//  WJWBaseTabBarViewController.swift
//  SwiftTips
//
//  Created by wjw on 2021/4/22.
//

import UIKit

class WJWBaseTabBarViewController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChildViewController()
    }
    
    func setupChildVC(viewcontrollerName: String, title: String, imageName: String, selectedImageName: String) {
        
        
    }
    
//    func stepSubs(){
//    let titleArr = ["首页","消息", "喜欢", "发现", "我的"]
//    let imageName = ["home-normal", "message-normal", "favorite-normal", "discover-normal", "my-normal"]
//    let selectedImageName = ["home-highlight", "message-highlight", "favorite-highlight", "discover-highlight", "my-highlight"]
//    let vcArr = ["WJWHomeViewController", "WJWMessageViewController", "WJWFavoriteViewController", "WJWDiscoverViewController", "WJWMyViewController"]
    
//             self.tabBar.barTintColor = .white
//             var viewControllers = [UINavigationController]()
//             for (idx, item) in vcs.enumerated() {
//                 
//                 let vc = classFromStr(item)
//                 let nav = UINavigationController.init(rootViewController: vc)
//                 nav.tabBarItem.image = UIImage(named:"image"+String((idx+1)*10+idx+1))
//                 nav.tabBarItem.selectedImage = UIImage(named:"image"+String(idx+1))!.withRenderingMode(.alwaysOriginal)
//                 nav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//                 viewControllers.append(nav)
//             }
//             self.viewControllers = viewControllers
//         }
    
    
    func addChildViewController() {
        setChildViewController(WJWHomeViewController(), title: "首页", imageName: "home-normal", selectImageName: "home-highlight")
        setChildViewController(WJWMessageViewController(), title: "消息", imageName: "message-normal", selectImageName: "message-highlight")
        setChildViewController(WJWFavoriteViewController(), title: "喜欢", imageName: "favorite-normal", selectImageName: "favorite-highlight")
        setChildViewController(WJWDiscoverViewController(), title: "发现", imageName: "discover-normal", selectImageName: "discover-highlight")
        setChildViewController(WJWMyViewController(), title: "我的", imageName: "my-normal", selectImageName: "my-highlight")
    }
    
    func setChildViewController(_ childViewController: UIViewController, title: String, imageName: String, selectImageName: String) {
        // 设置 tabbar 文字和图片
        childViewController.tabBarItem.image = UIImage(named: imageName)
        childViewController.tabBarItem.selectedImage = UIImage(named: selectImageName)
        childViewController.title = title
        // 添加导航控制器为 TabBarController 的子控制器
        let navVc = UINavigationController(rootViewController: childViewController)

        addChild(navVc)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
