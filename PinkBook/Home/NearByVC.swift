//
//  NearByVC.swift
//  附近
//
//  Created by 李胜 on 2022/1/16.
//

import UIKit

class NearByVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NearByVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: "附近")
    }
}
