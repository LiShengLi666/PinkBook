//
//  NoteEditVC.swift
//  编辑笔记页面
//
//  Created by 李胜 on 2022/1/20.
//

import UIKit

class NoteEditVC: UIViewController {
    @IBOutlet var photoCollectionview: UICollectionView!
    var photos = [UIImage(named: "1")!, UIImage(named: "2")!]
    var photoCount: Int { photos.count }
    var videoURL: URL?
    var isVideo: Bool { videoURL != nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 开启拖放交互
        photoCollectionview.dragInteractionEnabled = true
    }

    /// 添加照片
    @objc private func addPhoto() {
        if photoCount < kMaxPhotoCount {
            var config = YPImagePickerConfiguration()

            // MARK: 通用配置

            config.albumName = Bundle.main.appName // 存图片进相册App的'我的相簿'里的文件夹名称
            config.screens = [.library] // 依次展示相册，拍视频，拍照页面

            // MARK: 相册配置

            config.library.defaultMultipleSelection = true // 是否可多选
            config.library.maxNumberOfItems = kMaxPhotoCount - photoCount // 最大选取照片或视频数
            config.library.spacingBetweenItems = kSpacingBetweenItems // 照片缩略图之间的间距

            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊

            config.gallery.hidesRemoveButton = false // 每个照片或视频右上方是否有删除按钮

            let picker = YPImagePicker(configuration: config)

            // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）

            picker.didFinishPicking { [unowned picker] items, _ in

                for item in items {
                    if case let .photo(photo) = item {
                        self.photos.append(photo.image)
                    }
                }
                self.photoCollectionview.reloadData()

                picker.dismiss(animated: true)
            }

            present(picker, animated: true)
        } else {
            showTextHUD("最多只能选择\(kMaxPhotoCount)张照片哦")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NoteEditVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 若只有header和footer其中一个也可这样，但不推荐
        // let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
        // return photoFooter

        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            return photoFooter
        default:
            fatalError("collectionView的footer出问题了")
            // 或 return UICollectionReusableView()
        }
    }
}
