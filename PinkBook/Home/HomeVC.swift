//
//  HomeVC.swift
//  首页
//
//  Created by 李胜 on 2022/1/16.
//

import UIKit
class HomeVC: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        // MARK: 设置上方的bar,按钮,条的UI
        
        // 1.整体bar--在sb上设
        
        // 2.selectedBar--按钮下方的条
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.selectedBarHeight = 3
        
        // 3.buttonBarItem--文本或图片的按钮
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .label
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        
        // 必须写在settings布局后面
        super.viewDidLoad()
        
        // 第一个不能右滑
        containerView.bounces = false
        // 选中黑色, 未选中灰色
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, changeCurrentIndex: Bool, _: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let discoveryVC = storyboard!.instantiateViewController(withIdentifier: kDisCoveryVCID)
        let followVC = storyboard!.instantiateViewController(withIdentifier: kFollowVCID)
        let nearbyVC = storyboard!.instantiateViewController(withIdentifier: kNearByVCID)
        return [discoveryVC, followVC, nearbyVC]
    }
}
