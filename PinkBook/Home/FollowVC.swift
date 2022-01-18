//
//  FollowVC.swift
//  关注
//
//  Created by 李胜 on 2022/1/16.
//

import UIKit

class FollowVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FollowVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: "关注")
    }
}
