//
//  WJWWhisperViewController.swift
//  SwiftTips
//
//  Created by wjw on 2021/4/22.
//

import UIKit
import Whisper

class WJWWhisperViewController: WJWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "各种弹窗"

        self.configUI()
        self.bindAction()
    }
    
    // MARK: - 绑定事件
    func bindAction() {
        self.showAnnouncementBtn.addTarget(self, action: #selector(announceAction), for: .touchUpInside)
        self.showWhistalBtn.addTarget(self, action: #selector(WhistalAction), for: .touchUpInside)
        self.showWhisperBtn.addTarget(self, action: #selector(WhisperAction), for: .touchUpInside)
    }
    
    @objc func announceAction() {
        let announcement = Announcement(title: "强提醒弹窗", subtitle: "详细信息", image: UIImage(named: "AppIcon"))
        Whisper.show(shout: announcement, to: self.navigationController!, completion: {
            print("The shout was silent.")
            Whisper.hide(whisperFrom: self.navigationController!)
        })
}
    
    @objc func WhistalAction() {
        let murmur = Murmur(title: "Whistal 弱提醒")

        // Show and hide a message after delay
        Whisper.show(whistle: murmur, action: .show(1.5))

//        // Present a permanent status bar message
//        Whisper.show(whistle: murmur, action: .present)
//        // Hide a message
//        Whisper.hide(whistleAfter: 3)
    }
    
    @objc func WhisperAction() {
        let message = Message(title: "Some Error Appeared. With red color!", backgroundColor: .red)

        // Show and hide a message after delay
        Whisper.show(whisper: message, to: self.navigationController!, action: .show)

//        // Present a permanent message
//        Whisper.show(whisper: message, to: self.navigationController!, action: .present)
//
//        // Hide a message
//        Whisper.hide(whisperFrom: self.navigationController!)
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        self.view.addSubview(self.showAnnouncementBtn)
        self.view.addSubview(self.showWhistalBtn)
        self.view.addSubview(self.showWhisperBtn)
        
        self.showAnnouncementBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50 + 94)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        
        self.showWhistalBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.showAnnouncementBtn.snp_bottomMargin).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }

        self.showWhisperBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.showWhistalBtn.snp_bottomMargin).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }

    }
    
    
    lazy var showAnnouncementBtn: UIButton = {
        var btn = UIButton.init(type: .custom)
        btn.setTitle("Announcement btn", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var showWhistalBtn: UIButton = {
        var btn = UIButton.init(type: .custom)
        btn.setTitle("Whistal btn", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var showWhisperBtn: UIButton = {
        var btn = UIButton.init(type: .custom)
        btn.setTitle("Whisper btn", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = true
        return btn
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
