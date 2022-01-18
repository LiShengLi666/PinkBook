//
//  WaterfallVC.swift
//  瀑布流UICollectionViewController
//
//  Created by 刘军 on 2020/11/8.
//

import UIKit

class WaterfallVC: UICollectionViewController {
    var channel = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Layout布局
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding // 左右
        layout.minimumInteritemSpacing = kWaterfallPadding // 上下
        layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        13
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
        cell.imageview.image = UIImage(named: "\(indexPath.item + 1)")
        return cell
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout {
    /// 返回图片的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UIImage(named: "\(indexPath.item + 1)")!.size
    }
}

extension WaterfallVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
