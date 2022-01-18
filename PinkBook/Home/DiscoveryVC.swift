//
//  DiscoveryVC.swift
//  发现
//
//  Created by 李胜 on 2022/1/16.
//

import UIKit
class DiscoveryVC: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)

        super.viewDidLoad()

        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, changeCurrentIndex: Bool, _: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs: [UIViewController] = []
        for channel in kChannels {
            let vc = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
            vc.channel = channel
            vcs.append(vc)
        }
        return vcs
    }
}

extension DiscoveryVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("Discovery", comment: "首页发现标签"))
    }
}
