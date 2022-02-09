//
//  EHmmMainVC.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/20.
//

import UIKit
import SnapKit
import Photos
import YPImagePicker
import ISPageControl

class EHmmMainVC: UIViewController, UINavigationControllerDelegate {

    var scrollView: EHyAutoScrollView = EHyAutoScrollView.init(frame: CGRect.zero, viewsList: [])
    var viewWillAppearOnce = Once()
    var pageControl: ISPageControl!
    let scrollBgV = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AFlyerLibManage.event_LaunchApp()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewWillAppearOnce.run {
//            pointControl.adhere(toSuperview: view)
            pageControl.frame = CGRect(x: 0, y: scrollBgV.frame.maxY, width: 80, height: 25)
        }
        
    }
    
    func setupView() {
        view.backgroundColor(.white)
        //
        let storeBtn = UIButton()
        storeBtn.backgroundImage(UIImage(named: "home_store_ic"))
            .adhere(toSuperview: view)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender: )), for: .touchUpInside)
        
        //
        let settingBtn = UIButton()
        settingBtn.backgroundImage(UIImage(named: "home_setting_ic"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel.fontName(14, "Avenir-Medium")
            .color(.black)
            .text("Eeezy Highlight & Cover")
            .adhere(toSuperview: view)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(settingBtn.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        //
        let scrollWidth: CGFloat = UIScreen.width
        let scrollHieght: CGFloat = 160
        
        
        scrollBgV.backgroundColor(.white)
            .adhere(toSuperview: view)
        scrollBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(scrollHieght)
            $0.top.equalTo(settingBtn.snp.bottom).offset(10)
        }
        //
        
        
        
       //
        let img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 40, height: 160))
        img1.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .image("home_banner_1")
        let img2 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 40, height: 160))
        img2.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .image("home_banner_2")
        let img3 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 40, height: 160))
        img3.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .image("home_banner_3")
        let img4 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 40, height: 160))
        img4.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .image("home_banner_4")
         
        
        
        let scrollFrame = CGRect.init(x: 0, y: 0, width: scrollWidth, height: scrollHieght)
        scrollView = EHyAutoScrollView.init(frame: scrollFrame, viewsList: [img1, img2, img3, img4])
        scrollBgV.addSubview(scrollView)
        scrollView.cellClickViewActionBlock = {
            [weak self] itemIndex in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                let item = EHmmDataManager.default.paidIconList[itemIndex]
                self.showEditVC(image: nil, item)
            }
        }
        scrollView.currentCenterChangeBlock = {
            [weak self] index in
            guard let `self` = self else {return}
            self.pageControl.currentPage = index
        }
        //
        
        let previewScroll = UIScrollView()
        previewScroll.backgroundColor(.white)
            .adhere(toSuperview: view)
        previewScroll.contentSize = CGSize(width: UIScreen.width, height: 650)
        previewScroll.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(scrollBgV.snp.bottom).offset(25)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.width)
            $0.height.equalTo(1250)
        }
        
        let item1 = EHmmDataManager.default.paidIconList[0]
        let preview1 = EHmmMainPreview(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 130), iconModel: item1)
        preview1.adhere(toSuperview: previewScroll)
        preview1.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showEditVC(image: nil, item)
        }
        
        let item2 = EHmmDataManager.default.paidIconList[1]
        let preview2 = EHmmMainPreview(frame: CGRect(x: 0, y: 130 + 10, width: UIScreen.width, height: 130), iconModel: item2)
        preview2.adhere(toSuperview: previewScroll)
        preview2.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showEditVC(image: nil, item)
        }
        
        let item3 = EHmmDataManager.default.paidIconList[2]
        let preview3 = EHmmMainPreview(frame: CGRect(x: 0, y: (130 + 10) * 2, width: UIScreen.width, height: 130), iconModel: item3)
        preview3.adhere(toSuperview: previewScroll)
        preview3.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showEditVC(image: nil, item)
        }
        
        let item4 = EHmmDataManager.default.paidIconList[3]
        let preview4 = EHmmMainPreview(frame: CGRect(x: 0, y: (130 + 10) * 3, width: UIScreen.width, height: 130), iconModel: item4)
        preview4.adhere(toSuperview: previewScroll)
        preview4.clickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.showEditVC(image: nil, item)
        }
        
        //
        
        let cameraBtn = UIButton()
        cameraBtn.backgroundImage(UIImage(named: "home_add_ic"))
            .adhere(toSuperview: view)
        cameraBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        cameraBtn.addTarget(self, action: #selector(cameraBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        
        let frame = CGRect(x: 0, y: 500, width: UIScreen.main.bounds.width, height: 25)
        pageControl = ISPageControl(frame: frame, numberOfPages: 4)
        pageControl.radius = 4
        pageControl.padding = 10
        pageControl.inactiveTintColor = UIColor.lightGray
//        pageControl.borderWidth = 3
        pageControl.currentPage = 0
        pageControl.borderColor = UIColor.red
        pageControl.currentPageTintColor = .black
        view.addSubview(pageControl)
        
//        pointControl.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(scrollBgV.snp.bottom)
//            $0.width.equalTo(100)
//            $0.height.equalTo(30)
//        }
    }
    

}

extension EHmmMainVC {
    
    @objc func cameraBtnClick(sender: UIButton) {
        checkCameraAuthorized()
    }
    @objc func settingBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(EHmmSEttingVC(), animated: true)
    }
    @objc func storeBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(EHmmStoreeVC(), animated: true)
        
    }
    
     
}



extension EHmmMainVC {
    func presentCameraPickerController () {
        
        let  cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        //在需要的地方present出来
        self.present(cameraPicker, animated: true, completion: nil)
        
    }


    
    func checkCameraAuthorized() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
          
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentCameraPickerController()
                    }
                    
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentCameraPickerController()
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Camera.", preferredStyle: .alert)
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
extension EHmmMainVC: UIImagePickerControllerDelegate {
    
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
    
    func showEditVC(image: UIImage?, _ iconItemModel: EHmmIconModel = EHmmDataManager.default.paidIconList.first!) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let vc = EHmmEditVC(originalImg: image, iconItemModel: iconItemModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
