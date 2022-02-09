//
//  EHmmMainPreview.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/21.
//

import UIKit

class EHmmMainPreview: UIView {

    let nameLabel = UILabel()
    
    let contentBgV = UIView()
    
    var collection: UICollectionView!
    
    var iconModel: EHmmIconModel
    
    var clickBlock: ((EHmmIconModel)->Void)?
    
    init(frame: CGRect, iconModel: EHmmIconModel) {
        self.iconModel = iconModel
        
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    

}

extension EHmmMainPreview {
    func loadData() {
        
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(72)
        }
        collection.register(cellWithClass: EHmmMainPreviewCell.self)
        collection.layer.cornerRadius = 12
        collection.layer.masksToBounds = true
        
        collection.backgroundColor(UIColor(hexString: iconModel.bgColorStr) ?? UIColor.black)
        
        //
        let nameBgImgV = UIImageView()
        nameBgImgV.image("home_title_bg")
            .adhere(toSuperview: self)
        nameBgImgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(13)
        }
        //
        
        nameLabel.adhere(toSuperview: self)
            .fontName(13, "Avenir-Medium")
            .color(.black)
            .text(iconModel.nameStr)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(collection.snp.left).offset(22)
            $0.bottom.equalTo(collection.snp.top).offset(-12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        nameBgImgV.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top).offset(-4)
            $0.left.equalTo(nameLabel.snp.left).offset(-4)
            $0.width.height.equalTo(24)
        }
        
        //
//        let overlayerBtn = UIButton()
//        overlayerBtn.adhere(toSuperview: self)
//        overlayerBtn.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
//        overlayerBtn.addTarget(self, action: #selector(overlayerBtnClick(sender: )), for: .touchUpInside)
        
        
    }
    
    @objc func overlayerBtnClick(sender: UIButton) {
        
        clickBlock?(iconModel)
        
    }
    
}


extension EHmmMainPreview: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: EHmmMainPreviewCell.self, for: indexPath)
        
        let icon = iconModel.stickerList[indexPath.item]
        cell.contentImgV.image(icon.thumbName)
//        cell.contentImgV.image("textIon")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconModel.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EHmmMainPreview: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension EHmmMainPreview: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickBlock?(iconModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class EHmmMainPreviewCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}



