//
//  NoteEditVC.swift
//  编辑笔记页面
//
//  Created by 李胜 on 2022/1/20.
//

import UIKit

class NoteEditVC: UIViewController {
    // MARK: - Property

    /// 照片UICollectionView
    @IBOutlet var photoCollectionview: UICollectionView!
    /// 标题UITextField
    @IBOutlet var titleTextField: UITextField!
    /// 标题限制文本
    @IBOutlet var titleCountLabel: UILabel!
    /// 内容UITextView
    @IBOutlet var textView: UITextView!
    /// 默认照片
    var photos = [UIImage(named: "1")!, UIImage(named: "2")!]
    /// 照片长度,多用计算属性表示
    var photoCount: Int { photos.count }
    /// 选中视频的URL
    var videoURL: URL?
    /// 区分选中的是否是视频
    var isVideo: Bool { videoURL != nil }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
    }

    // MARK: - UI

    func config() {
        hideKeyboardWhenTappedAround()

        // 开启拖放交互
        photoCollectionview.dragInteractionEnabled = true

        // 修改最大文本数量
        titleCountLabel.text = "\(kMaxNoteTitleCount)"

        // MARK: textView

        // 去除文本和placeholder的上下左右边距
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -lineFragmentPadding, bottom: 0, right: -lineFragmentPadding)
        
        // 行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        
        // 光标颜色
        textView.tintColorDidChange()
        
        // 软键盘上面的view
//        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
//        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
//        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"

        // 请求定位权限
//        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Override

    /// 第3种收起键盘的方法,  第1种是滑动收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Network

    // MARK: - Notification

    // MARK: - Action

    /// 获取焦点
    @IBAction func TFEditBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }

    /// 失去焦点
    @IBAction func TFEditEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }

    /// 编辑中
    @IBAction func TFEditChanged(_ sender: Any) {
        // 当前有高亮文本时(拼音键盘)return
        guard titleTextField.markedTextRange == nil else { return }

        // 用户粘贴或者联想输入完字符后进行判断, 若大于最大字符数, 则截取前面的文本(if里面第一行)
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount {
            // 截取最大显示的字符串
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))

            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦")

            // 用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改成末尾, 固定写法, 改变光标需要在主线程
            DispatchQueue.main.async {
                // 获取文档尾部的位置
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }

        // 剩余字数
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
    }

    /// 添加照片
    @objc private func addPhoto() {
        if photoCount < kMaxPhotoCount {
            var config = YPImagePickerConfiguration()

            // MARK: 通用配置

            // 存图片进相册App的'我的相簿'里的文件夹名称
            config.albumName = Bundle.main.appName
            // 依次展示相册，拍视频，拍照页面
            config.screens = [.library]

            // MARK: 相册配置

            // 是否可多选
            config.library.defaultMultipleSelection = true
            // 最大选取照片或视频数
            config.library.maxNumberOfItems = kMaxPhotoCount - photoCount
            // 照片缩略图之间的间距
            config.library.spacingBetweenItems = kSpacingBetweenItems

            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊

            // 每个照片或视频右上方是否有删除按钮
            config.gallery.hidesRemoveButton = false

            let picker = YPImagePicker(configuration: config)

            // 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
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

    // MARK: - Public

    // MARK: - Private
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

// MARK: - UITextFieldDelegate

extension NoteEditVC: UITextFieldDelegate {
    /// 第2种收起键盘的方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//// MARK: - 因系统自带拼音键盘把拼音也当做字符,故需在输入完之后判断,故全部移到TFEditChanged方法中进行处理
//
// extension NoteEditVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
//        //string--当前输入的字符或粘贴的文本
//
//        //限制字串长度为20，以下情况返回false（即不让输入）：
//        //1-输入的字符或粘贴的文本在整体内容的索引是20的时候（第21个字符不让输）
//        //2-当前输入的字符的长度+粘贴文本的长度超过20时--防止从一开始一下子粘贴超过20个字符的文本
//        let isExceed = range.location >= kMaxNoteTitleCount || (textField.unwrappedText.count + string.count > kMaxNoteTitleCount)
//
//        if isExceed{ showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦") }
//
//        return !isExceed
//    }
// }
