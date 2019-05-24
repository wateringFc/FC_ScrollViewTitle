//
//  ViewController.swift
//  ScrollViewTitle
//
//  Created by 方存 on 2019/5/24.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

let kScreenW : CGFloat = UIScreen.main.bounds.size.width
let kScreenH : CGFloat = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    /// 当前选择按钮
    fileprivate var selectedButton: UIButton?
    
    /// 背景指示器
    fileprivate lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = .red
        indicatorView.tag = -1
        return indicatorView
    }()
    
    /// 顶部的背景视图
    fileprivate lazy var titlesView: UIView = {
        let titlesView = UIView(frame: CGRect(x: 0, y: 88, width: kScreenW, height: 42))
        titlesView.backgroundColor = UIColor.white
        return titlesView
    }()
    
    /// 底部滑动视图
    fileprivate lazy var contenView: UIScrollView = {
        let contenView = UIScrollView()
        contenView.backgroundColor = UIColor.lightGray
        contenView.frame = view.bounds
        contenView.delegate = self
        contenView.isPagingEnabled = true
        contenView.contentSize = CGSize(width: contenView.width * CGFloat(childViewControllers.count), height: 0)
        return contenView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 模拟iphoneX的Nav
        let nav = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 88))
        nav.backgroundColor = UIColor.lightGray
        view.addSubview(nav)
        
        setUpChinldVces()
        setUptitlesView()
        setUpContenView()
    }
}

extension ViewController {
    
    /// 初始化子控制器
    fileprivate func setUpChinldVces() {
        let highestVc = FC_LevelViewController()
        highestVc.title = "高危"
        highestVc.type = .LeveType_highest
        addChildViewController(highestVc)
        
        let highVc = FC_LevelViewController()
        highVc.title = "危险"
        highVc.type = .LeveType_high
        addChildViewController(highVc)
        
        let generalVc = FC_LevelViewController()
        generalVc.title = "一般"
        generalVc.type = .LeveType_general
        addChildViewController(generalVc)
    }
    
    /// 设置顶部的标签栏
    fileprivate func setUptitlesView() {
        view.addSubview(titlesView)
        // 创建按钮
        let item_w: CGFloat = titlesView.width/CGFloat(self.childViewControllers.count)
        let item_h: CGFloat = titlesView.height
        for i in 0..<childViewControllers.count {
            let but = UIButton(type: .custom)
            let but_x = CGFloat(i) * item_w
            but.frame = CGRect(x: but_x, y: 0, width: item_w, height: item_h)
            let vc = childViewControllers[i]
            but.setTitle(vc.title, for: .normal)
            but.setTitleColor(.gray, for: .normal)
            but.setTitleColor(.red, for: .disabled)
            but.tag = i
            but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            but.addTarget(self, action: #selector(titlesClick(but:)), for: .touchUpInside)
            titlesView.addSubview(but)
            
            if i == 0 {
                but.isEnabled = false
                selectedButton = but
                but.titleLabel?.sizeToFit()
                indicatorView.width = but.titleLabel!.width*2.5
                indicatorView.centerX = but.centerX
            }
        }
        // 创建指示器
        titlesView.addSubview(indicatorView)
        indicatorView.height = 2
        indicatorView.y = 40
    }
    
    /// 底部的scrollView
    fileprivate func setUpContenView() {
        view.insertSubview(contenView, at: 0)
        // 默认添加第一个控制器
        scrollViewDidEndScrollingAnimation(contenView)
    }
    
    @objc func titlesClick(but: UIButton) {
        // 修改标签状态
        selectedButton?.isEnabled = true
        but.isEnabled = false
        selectedButton = but
        
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.width = self.selectedButton!.titleLabel!.width * 2.5
            self.indicatorView.centerX = self.selectedButton!.centerX
        }
        
        // 滚动子控制器
        var offset = contenView.contentOffset
        offset.x = CGFloat(but.tag) * contenView.width
        contenView.setContentOffset(offset, animated: true)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let vc = childViewControllers[index]
        vc.view.x = scrollView.contentOffset.x
        vc.view.y = 0
        vc.view.height = scrollView.height
        scrollView.addSubview(vc.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        titlesClick(but: titlesView.subviews[index] as! UIButton)
    }
}
