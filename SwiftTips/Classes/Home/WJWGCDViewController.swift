//
//  WJWGCDViewController.swift
//  SwiftTips
//
//  Created by wjw on 2021/4/22.
//

/**
 为什么要用多线程？
 GCD可用于多核的并行运算
 GCD会自动利用更多的CPU内核（比如双核、四核）
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 */

/**
  多线程优先级？
 OC中的：
 DISPATCH_QUEUE_PRIORITY_HIGHT
 DISPATCH_QUEUE_PRIORITY_DEFAULT
 DISPATCH_QUEUE_PRIORITY_LOW
 DISPATCH_QUEUE_PRIORITY_BACKGROUND
 
 对应swift中的：
 User Interactive 和用户交互相关，比如动画等等优先级最高。比如用户连续拖拽的计算
 User Initiated 需要立刻的结果，比如push一个ViewController之前的数据计算
 Utility 可以执行很长时间，再通知用户结果。比如下载一个文件，给用户下载进度
 Background 用户不可见，比如在后台存储大量数据
 */

import UIKit
import Whisper


class WJWGCDViewController: WJWBaseViewController {

    var btnArr: [UIButton]?
    var btnNameArr: [String]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GCD"
        self.btnNameArr = ["串行队列+同步任务", "串行队列+异步任务", "并发队列+同步任务", "并发队列+异步任务", "最大并发数", "GCD 栅栏", "GCD group", "信号量处理线程同步", "信号量处理最大并发量", "信号量枷锁"]
        self.btnArr = Array<UIButton>()
        self.configUI()
        self.bindAction()
    }
    
    func bindAction() {
        self.toggleThreadBtn.addTarget(self, action: #selector(changeThread), for: .touchUpInside)
        self.qosTestBtn.addTarget(self, action: #selector(gcdQosFunc), for: .touchUpInside)
        
        let btn = self.btnArr![0] as UIButton
        btn.addTarget(self, action: #selector(serialQueueSyncExecute), for: .touchUpInside)
        
        let btn1 = self.btnArr![1] as UIButton
        btn1.addTarget(self, action: #selector(serialQueueAsyncExecute), for: .touchUpInside)
        
        let btn2 = self.btnArr![2] as UIButton
        btn2.addTarget(self, action: #selector(concurrentQueueSyncExecute), for: .touchUpInside)
        
        let btn3 = self.btnArr![3] as UIButton
        btn3.addTarget(self, action: #selector(concurrentQueueAsyncExecute), for: .touchUpInside)
        
        let btn4 = self.btnArr![4] as UIButton
        btn4.addTarget(self, action: #selector(maxConcurrentQueue), for: .touchUpInside)
        
        let btn5 = self.btnArr![5] as UIButton
        btn5.addTarget(self, action: #selector(gcdBarrier), for: .touchUpInside)
        
        let btn6 = self.btnArr![6] as UIButton
        btn6.addTarget(self, action: #selector(gcdGroup), for: .touchUpInside)
        
        let btn7 = self.btnArr![7] as UIButton
        btn7.addTarget(self, action: #selector(semaphoreSync), for: .touchUpInside)
        
        let btn8 = self.btnArr![8] as UIButton
        btn8.addTarget(self, action: #selector(semaphoreMaxConcurrent), for: .touchUpInside)
        
        let btn9 = self.btnArr![9] as UIButton
        btn9.addTarget(self, action: #selector(gcdGroup), for: .touchUpInside)
        
    }
    
    //MARK: - 自定义事件
    //子线程切换到主线程
    @objc func changeThread() {
        DispatchQueue.global().async {
            //模拟耗时任务
            sleep(2)
            DispatchQueue.main.async {
                print("切换到主线程")
                let murmur = Murmur(title: "耗时任务完成，切换回主线程！")
                // Show and hide a message after delay
                Whisper.show(whistle: murmur, action: .show(1.5))
            }
        }
    }
    
    //指定线程优先级
    @objc func gcdQosFunc() {
        let queue = DispatchQueue(label: "默认先级queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            print("default 优先级的 queue 执行任务！")
        }
        
        let queue1 = DispatchQueue(label: "默认先级queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue1.async {
            print("userInteractive 优先级的 queue 执行任务！")
        }
        
        //在提交任务时，设置queue 的优先级
        queue.async(group: nil, qos: .background, flags: .inheritQoS) {
            print("重新设置优先级")
        }
    }
    
    //串行队列 同步执行
    @objc func serialQueueSyncExecute() {
        print("串行队列+同步任务——依次执行")
        let serialQueue = DispatchQueue.init(label: "串行队列1", qos: .default, attributes: .init(rawValue: 0), autoreleaseFrequency: .inherit, target: nil)
        for i in 0..<10 {
            serialQueue.async {
                sleep(arc4random()%3)
                print(i)
            }
        }
    }
    
    //串行队列， 异步执行
    @objc func serialQueueAsyncExecute() {
        print("串行队列+异步任务——开启一个新线程依次执行")
        //串行队列
        let serial = DispatchQueue(label: "串行队列2",attributes: .init(rawValue:0))
        print(Thread.current)//主线程
        for i in 0...10 {
            serial.async {
                sleep(arc4random()%3)//休眠时间随机
                print(i,Thread.current)//子线程
            }
        }
    }
    
    //并发队列+同步任务
    @objc func concurrentQueueSyncExecute() {
        print("并发队列+同步任务——依次执行")
        //以下代码输出顺序始终为0...10,且线程始终为主线程
        for i in 0...10 {
            DispatchQueue.global().sync {
                sleep(arc4random()%3)//休眠时间随机
                print(i,Thread.current)
            }
        }
    }
    
    //并发队列+异步任务
    @objc func concurrentQueueAsyncExecute() {
        print("并发队列+异步任务——开启多个线程并发执行")
        for i in 0...10 {
            DispatchQueue.global().async {
                sleep(arc4random()%3)//休眠时间随机
                print(i,Thread.current)
            }
        }
    }
    
    //并发队列最大并发数
    @objc func maxConcurrentQueue() {
        print("并发队列最大并发数, 最多64个")
        for i in 1..<1000 {
            DispatchQueue.global().async {
//                sleep(arc4random()%3)
                print(i, Thread.current)
                sleep(10000)
            }
        }
    }
    
    //在swift中栅栏不再是一个单独的方法。而是DispatchWorkItemFlags结构体中的一个属性。sync/async方法的其中一个参数类型即为DispatchWorkItemFlags，所以使用代码如下。这样的调用方式可以更好的理解栅栏，其实它就是一个分隔任务，将其添加到需要栅栏的队列中，以分隔添加前后的其他任务。以下代码栅栏前后均为并发执行。如果将添加栅栏修改为sync则会阻塞当前线程。
    @objc func gcdBarrier() {
        print("barrier 对全局队列无效，全局队列自己有优化")
        let queue = DispatchQueue.init(label: "concurrent queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        for i in 0...10 {
            queue.async {
                print("first " , i)
            }
        }
        queue.async(flags: .barrier) {
            print("this is barrier")
        }
        for i in 11...20 {
            queue.async {
                print("second " , i)
            }
        }
    }
    //GCD 组
    @objc func gcdGroup() {
        print("gcdGroup")
        let group = DispatchGroup()
        group.enter()
        for i in 0..<1000 {
            DispatchQueue.global().async(group: group) {
                sleep(arc4random()%10)
                print(i, Thread.current)
            }
        }
        //notify 无法设置超时时间
//        group.notify(queue: .main, work: DispatchWorkItem{
//            print("group 执行完成")
//        })
        
        switch group.wait(timeout: DispatchTime.now() + 5) {
            case .success:
                print("group 执行完成")
                group.leave()
            break
            
            case .timedOut:
                print("group 执行超时")
                group.leave()
            break
        }
    }
    
    //信号量处理同步
    @objc func semaphoreSync() {
        //创建信号量为0
        let semaphore = DispatchSemaphore.init(value: 0)
        DispatchQueue.global().async {
            print(Thread.current)
            sleep(arc4random()%3)
            //信号量+1
            semaphore.signal()
        }
        
        //等待，信号量大于0，可以继续执行并将信号量-1，信号量=0,阻塞
        switch semaphore.wait(timeout: DispatchTime.now() + 5) {
        case .success:
            print("信号量控制的同步任务完成")
            break
        case .timedOut:
            print("信号量控制的同步任务超时")
            break
        }
    }
    
    //信号量控制最大并发量
    @objc func semaphoreMaxConcurrent() {
        print("信号量控制最大并发量")
        let semaphore = DispatchSemaphore.init(value: 5)
        for i in 0..<100 {
            semaphore.wait()
            DispatchQueue.global().async {
                sleep(arc4random() % 3)
                print(i, Thread.current)
                semaphore.signal()
            }
        }
    }
    
    
    //信号量枷锁
    @objc func semaphoreAsLock() {
        print("信号量枷锁")
        let semaphore = DispatchSemaphore.init(value: 1)
        semaphore.wait()
        DispatchQueue.global().async {
            print("模拟任务", Thread.current)
            semaphore
        }
        
    }
    
    
    
    
    //MARK: - 控件布局
    func configUI() {
        self.view.addSubview(self.toggleThreadBtn)
        self.view.addSubview(self.qosTestBtn)

        self.toggleThreadBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50 + 94)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        
        self.qosTestBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.toggleThreadBtn.snp_bottomMargin).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        
        
        for item in self.btnNameArr {
            let btn = UIButton.init(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.setTitleColor(.blue, for: .highlighted)
            self.btnArr!.append(btn)
            self.view.addSubview(btn)
        }
        
        let height = 30
        let width = 180
        let spaceVertical = 10
        let spaceHorizon = 20
        for index in 0..<self.btnArr!.count {
            let btn = self.btnArr![index] as UIButton
            btn.backgroundColor = .green
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = true
            btn.snp.makeConstraints { (make) in
                make.top.equalTo(self.view).offset((index / 2) * (height + spaceVertical)  + 250 )
                make.left.equalToSuperview().offset((index%2) * (width + spaceHorizon) + 20)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
        }
    }

    //MARK: - 懒加载控件
    lazy var toggleThreadBtn: UIButton = {
        var btn = UIButton.init(type: .custom)
        btn.setTitle("子线程切换到主线程", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var qosTestBtn: UIButton = {
        var btn = UIButton.init(type: .custom)
        btn.setTitle("优先级测试", for: .normal)
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
