//
//  EHmmEditVC.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/20.
//

import UIKit
import DeviceKit
import Photos
import YPImagePicker
import ZKProgressHUD

class EHmmEditVC: UIViewController, UINavigationControllerDelegate {

    let topBanner = UIView()
    let contentBgV = UIView()
    let contentBgColorImgV = UIImageView()
    let contentImgV = UIImageView()
    let overlayerImgV = UIImageView()
    let toolBgV = UIView()
    let bottomBar = EHmmBottomBar()
    
    let randomBtn = UIButton()
    var toolBgImgBar: EHmmEditBackgroundView!
    var toolIconBar: EHmmEditIconView!
    var toolOverlyerBar: EHmmEditOverlayerView!
    
    
    var originalImg: UIImage?
    var viewWillAppearOnce = Once()
    var iconItemModel: EHmmIconModel
    
    
    let colorPickerV = EHmmColorPickerView()
//    var isPro: Bool = false
    var isSelectColorIcon: Bool = false
    
    
    
    init(originalImg: UIImage?, iconItemModel: EHmmIconModel) {
        self.originalImg = originalImg
        self.iconItemModel = iconItemModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewWillAppearOnce.run {
            var topOffset: CGFloat = 0
            var leftOffset: CGFloat = 18
            if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            
            }
            
            let width: CGFloat = UIScreen.main.bounds.width - (leftOffset * 2)
            let height: CGFloat = width
            
            topOffset = ((toolBgV.frame.minY - topBanner.frame.maxY) - height) / 2
            topOffset = topOffset/2 + topBanner.frame.maxY
            
            contentBgV.adhere(toSuperview: view)
            contentBgV.layer.masksToBounds = true
            contentBgV.frame = CGRect(x: leftOffset, y: topOffset, width: width, height: height)
            contentBgV.layer.cornerRadius = 16
            //
            contentBgV.layer.masksToBounds = true
//            contentBgColorImgV.layer.cornerRadius = 16
            contentBgColorImgV.image = originalImg
            contentBgColorImgV.adhere(toSuperview: contentBgV)
                .contentMode(.scaleAspectFill)
                .clipsToBounds()
            contentBgColorImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            //
            overlayerImgV.contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            overlayerImgV.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo((width / 3) + 210)
            }
            
            //
            contentImgV
                .contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            contentImgV.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(width / 2 + 100)
            }
            
            //
            view.bringSubviewToFront(randomBtn)
            randomBtn.snp.makeConstraints {
                $0.right.equalTo(contentBgV.snp.right).offset(-8)
                $0.bottom.equalTo(contentBgV.snp.bottom).offset(-8)
                $0.width.height.equalTo(40)
            }
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        setupView()
        setupColorPickerView()
        setupDefaultStatus()
    }
    
    
    func setupDefaultStatus() {
        bottomBar.currentItem = bottomBar.list.first
        bottomBar.collection.reloadData()
        
        if let item = bottomBar.currentItem {
            showToolBar(item: item)
        }
        contentBgV.backgroundColor(UIColor(hexString: iconItemModel.bgColorStr) ?? UIColor.white)
    }
    
   
    
    func setupView() {
        topBanner.backgroundColor(.clear)
            .adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        //
        let backBtn = UIButton()
        backBtn
            .backgroundImage(UIImage(named: "back_bg_ic"))
            .text("Back")
            .titleColor(.white)
            .font(12, "AvenirNext-Regular")
            .adhere(toSuperview: topBanner)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(56)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let saveBtn = UIButton()
        saveBtn
            .backgroundImage(UIImage(named: "back_bg_ic"))
            .text("Download")
            .titleColor(.white)
            .font(12, "AvenirNext-Regular")
            .adhere(toSuperview: topBanner)
        saveBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(72)
            $0.height.equalTo(24)
        }
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
     
        //
        let titleNameL = UILabel()
        titleNameL.text("Highlight Edit")
            .color(.black)
            .fontName(14, "AvenirNext-Regular")
            .adhere(toSuperview: topBanner)
        titleNameL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //

        bottomBar.adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
        bottomBar.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showToolBar(item: item)
            
        }
        //
        
        toolBgV.adhere(toSuperview: view)
            .backgroundColor(.clear)
        toolBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(180)
        }
        
        //
        
        randomBtn.image(UIImage(named: "suiji_icon"))
            .adhere(toSuperview: view)
        randomBtn.addTarget(self, action: #selector(randomBtnClick(sender: )), for: .touchUpInside)
 
        //
        
        
        toolBgImgBar = EHmmEditBackgroundView(frame: .zero)
        toolBgImgBar.adhere(toSuperview: toolBgV)
        toolBgImgBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(140)
        }
        toolBgImgBar.selectBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            if item.bigName == "custom" {
                self.checkAlbumAuthorization()
            } else {
//                self.contentBgColorImgV.image(item.bigName ?? "")
                self.contentBgColorImgV.image = nil
                self.contentBgColorImgV.backgroundColor(UIColor(hexString: item.bigName ?? "#FFFFFF") ?? UIColor.white)
//                EHmmDataManager.default.isSelectColor = nil
//                self.toolIconBar.colorBar?.collection.reloadData()
            }
            
        }
        //
        
        toolIconBar = EHmmEditIconView(frame: .zero, paidIconModel: iconItemModel)
        toolIconBar.adhere(toSuperview: toolBgV)
        toolIconBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(180)
        }
        toolIconBar.selectBlock = {
            [weak self] item, isColorIcon in
            guard let `self` = self else {return}
            if item.bigName == "color" {
                // show color pick
                self.showColorPickerView()
            } else {
                // change icon
                
                self.isSelectColorIcon = isColorIcon
                if isColorIcon == true {
                    let img = UIImage(named: item.bigName ?? "")
                    if let imgcg = img?.cgImage {
                        let img = UIImage(cgImage: imgcg)
                        self.contentImgV.image = img.withRenderingMode(.alwaysTemplate)
                        self.contentImgV.tintColor(EHmmDataManager.default.isSelectColor ?? UIColor.white)
                    }
                } else {
                    ZKProgressHUD.showMessage("It's a paid element.", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
                    self.contentImgV.image(item.bigName ?? "")
                }
                
            }
        }
        //
        
        toolOverlyerBar = EHmmEditOverlayerView(frame: .zero)
        toolOverlyerBar.adhere(toSuperview: toolBgV)
        toolOverlyerBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(140)
        }
        toolOverlyerBar.selectBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.overlayerImgV.image(item.bigName ?? "")
        }
        
        
        
    }
    
    
    func showToolBar(item: BottomBarItem) {
        for v in toolBgV.subviews {
            v.isHidden = true
        }
        if item.normalImgName == "editor_bg" {
            toolBgImgBar.isHidden = false
        } else if item.normalImgName == "editor_icon" {
            toolIconBar.isHidden = false
        } else if item.normalImgName == "editor_overlayer" {
            toolOverlyerBar.isHidden = false
        }
        
    }
    
}

extension EHmmEditVC {

    func setupColorPickerView() {
        
        colorPickerV.alpha = 0
        view.addSubview(colorPickerV)
        colorPickerV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showColorPickerView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.colorPickerV.alpha = 1
        }
        
        view.bringSubviewToFront(colorPickerV)
        colorPickerV.okBtnClickBlock = {
            [weak self] currentColor in
            guard let `self` = self else {return}

            EHmmDataManager.default.isSelectColor = currentColor
            self.toolIconBar.colorBar?.collection.reloadData()
            
            
            if self.contentImgV.image == nil {
                ZKProgressHUD.showMessage("Please select a pattern first.", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
            } else {
                
                if self.isSelectColorIcon == true {
                    if let imgcg = self.contentImgV.image?.cgImage {
                        let img = UIImage(cgImage: imgcg)
                        self.contentImgV.image = img.withRenderingMode(.alwaysTemplate)
                        self.contentImgV.tintColor(currentColor)
                    }
                } else {
                    ZKProgressHUD.showMessage("Modifying colors is not supported for multicolor patterns.", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
                }
            }
            
            
            
            
            
            
            
//            self.contentBgColorImgV.image = nil
//            self.contentBgColorImgV.backgroundColor(currentColor)
            UIView.animate(withDuration: 0.25) {
                self.colorPickerV.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        
        colorPickerV.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.colorPickerV.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
    }
    
}

extension EHmmEditVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        contentBgV.layer.cornerRadius = 0
        if let img = contentBgV.screenshot {
            contentBgV.layer.cornerRadius = 16
            var isPro: Bool = !isSelectColorIcon
            
            let vc = EHmmSavePVC(originalImg: img, isPro: isPro)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func randomBtnClick(sender: UIButton) {
        let item = EHmmDataManager.default.colorIconItem?.stickerList.randomElement()
        var nameStr = item?.bigName
        
        if item?.bigName == "color" {
            let item1 = EHmmDataManager.default.colorIconItem?.stickerList.first
            nameStr = item1?.bigName
        }
        
        if let imgcg = UIImage(named: nameStr ?? "")?.cgImage {
            let img = UIImage(cgImage: imgcg)
            self.contentImgV.image = img.withRenderingMode(.alwaysTemplate)
            self.contentImgV.tintColor(EHmmDataManager.default.isSelectColor ?? UIColor.white)
        }
        
        isSelectColorIcon = true
        
    }
    
    
}

extension EHmmEditVC {
    
}



extension EHmmEditVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
//                            self.presentPhotoPickerController()
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
//                                self.presentPhotoPickerController()
                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor(UIColor.white)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            
            self.contentBgColorImgV.image = image
            self.contentBgColorImgV.backgroundColor(.clear)
            EHmmDataManager.default.isSelectColor = nil
            self.toolIconBar.colorBar?.collection.reloadData()
            
//            let vc = GPyyEditVC(originalImg: image)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
