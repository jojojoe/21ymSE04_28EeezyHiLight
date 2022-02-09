//
//  EHmmSavePVC.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/20.
//

import UIKit
import Photos
import DeviceKit

class EHmmSavePVC: UIViewController {
    let originalImg: UIImage
    let unlockAlertView = EHmmCoinAlertView()
    var isPro: Bool
    let topBanner = UIView()
    let contentBgV = UIView()
    let contentBgColorImgV = UIImageView()
    let saveBtn = UIButton()
    var viewWillAppearOnce = Once()
    let toolBgV = UIView()
    init(originalImg: UIImage, isPro: Bool) {
        self.originalImg = originalImg
        self.isPro = isPro
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        setupView()
        setupUnlockAlertView()
        
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
            
            //
            
            
            
            topOffset = ((toolBgV.frame.minY - topBanner.frame.maxY) - height) / 2
            topOffset = topOffset/2 + topBanner.frame.maxY
            
            contentBgV.adhere(toSuperview: view)
            contentBgV.layer.masksToBounds = true
            contentBgV.frame = CGRect(x: leftOffset, y: topOffset, width: width, height: height)
            contentBgV.layer.cornerRadius = 16
            //
            contentBgV.layer.masksToBounds = true
            contentBgColorImgV.layer.cornerRadius = 16
            contentBgColorImgV.image = originalImg
            contentBgColorImgV.adhere(toSuperview: contentBgV)
                .contentMode(.scaleAspectFill)
                .clipsToBounds()
            contentBgColorImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            //
            saveBtn.snp.makeConstraints {
                $0.top.equalTo(contentBgV.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(56)
                $0.width.equalTo(248)
            }
            
        }
        
    }

     

}


extension EHmmSavePVC {
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
        
        
        toolBgV.adhere(toSuperview: view)
        toolBgV.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(1)
            $0.height.equalTo(235)
        }
        
        //
        let homeBtn = UIButton()
        homeBtn
            .image(UIImage(named: "save_home_ic"))
            .adhere(toSuperview: topBanner)
        homeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
            $0.height.equalTo(44)
        }
        homeBtn.addTarget(self, action: #selector(homeBtnClick(sender: )), for: .touchUpInside)
     
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
        //
        
        saveBtn
            .backgroundImage(UIImage(named: "save_btn_bg"))
            .text("Download")
            .titleColor(.white)
            .font(16, "AvenirNext-Regular")
            .adhere(toSuperview: view)
        
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        
        
         
        
    }
    
    @objc func homeBtnClick(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
     
    
}

extension EHmmSavePVC {
    
    func setupUnlockAlertView() {
        
        unlockAlertView.alpha = 0
        view.addSubview(unlockAlertView)
        unlockAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showUnlockunlockAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.unlockAlertView.alpha = 1
        }
        self.view.bringSubviewToFront(self.unlockAlertView)
        unlockAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if GPyymCoinManagr.default.coinCount >= GPyymCoinManagr.default.coinCostCount {
                DispatchQueue.main.async {
                     
                    GPyymCoinManagr.default.costCoin(coin: GPyymCoinManagr.default.coinCostCount)
                    DispatchQueue.main.async {
                        self.saveAction()
                        
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "The balance of coins is insufficient, please purchase first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(EHmmStoreeVC(), animated: true)
//                            self.present(EHmmStoreeVC(), animated: true, completion: nil)
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        
        unlockAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
    }
    
}

extension EHmmSavePVC {
    
    @objc func saveBtnClick(sender: UIButton) {
        
        if isPro {
            self.showUnlockunlockAlertView()
        } else {
            saveAction()
        }
        
    }
    
    func saveAction() {
        self.saveImgsToAlbum(imgs: [originalImg])
        
    }
}

extension EHmmSavePVC {
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        
        
        DispatchQueue.main.async {
            let title = ""
            let message = "Photo saved successfully!"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}
