//
//  TabBarC.swift
//  自定义标签控制器
//
//  Created by 李胜 on 2022/1/18.
//

import UIKit

class TabBarC: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    /// 返回true,代表是常规展示,如点击标签控制器的子按钮,就会显示对应的控制器, 如果返回false,那就可以自定义展示
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostVC {
            // 待做(判断是否登录)
            
            var config = YPImagePickerConfiguration()
            
            // MARK: 通用配置

            // 取消滑动切换，防止和编辑相册图片时的手势冲突
            config.isScrollToChangeModesEnabled = false
            // 是否只让拍摄正方形照片
            config.onlySquareImagesFromCamera = false
            // 存图片进相册App的'我的相簿'里的文件夹名称
            config.albumName = Bundle.main.appName
            // 一打开就展示相册
            config.startOnScreen = .library
            // 依次展示相册，拍视频，拍照页面
            config.screens = [.library, .video, .photo]
            // 最大多少倍变焦
            config.maxCameraZoomFactor = kMaxCameraZoomFactor
            
            // 小红书的照片和视频逻辑:
            // 1.照片和视频不可混排,且在相册中多选的视频最后会帮我们合成一个视频(即最终只能有一个视频)
            // 2.无论是相册照片还是现拍照片,之后在编辑页面皆可追加
            // 总结:允许一个笔记发布单个视频或多张照片
            
            // MARK: 相册配置

            // 是否可多选
            config.library.defaultMultipleSelection = true
            // 最大选取照片或视频数
            config.library.maxNumberOfItems = kMaxPhotoCount
            // 照片缩略图之间的间距
            config.library.spacingBetweenItems = kSpacingBetweenItems
            
            // MARK: 视频配置(参照文档,此处全部默认)
            
            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊

            // 每个照片或视频右上方是否有删除按钮
            config.gallery.hidesRemoveButton = false
            
            let picker = YPImagePicker(configuration: config)
            
            // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）

            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    // print("用户按了左上角的取消按钮")
                }
                
                for item in items {
                    switch item {
                    case let .photo(photo):
                        print(photo)
                    case let .video(video):
                        print(video)
                    }
                }
                
                picker.dismiss(animated: true)
            }
            
            present(picker, animated: true)
            
            return false
        }
        
        return true
    }
}
