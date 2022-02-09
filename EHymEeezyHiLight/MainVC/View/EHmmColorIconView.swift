//
//  EHmmColorIconView.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/24.
//

import UIKit
import MaLiang

class EHmmColorIconView: UIView {
    let titleNameL = UILabel()
    var collection: UICollectionView!
//    EHmmDataManager.default.colorIconItem
    var iconModel: EHmmIconModel
    var isPro: Bool = false
    
    var selectBlock: ((EHmmCyStickerItem, Bool)->Void)?
    init(frame: CGRect, iconModel: EHmmIconModel) {
        self.iconModel = iconModel
        super.init(frame: frame)
        loadData()
        setupView()
//        
//        if iconModel == EHmmDataManager.default.colorIconItem {
//            isPro = false
//        } else {
//            isPro = true
//        }
//        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}

extension EHmmColorIconView {
    func loadData() {
        
    }
    
    func setupView() {
        //
        
        titleNameL.text("\(iconModel.nameStr)")
            .color(.black)
            .fontName(14, "AvenirNext-Regular")
            .adhere(toSuperview: self)
        titleNameL.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        //
        
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
            $0.top.equalToSuperview().offset(25)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: EHmmColorIconCell.self)
        
        //
        
    }
}

extension EHmmColorIconView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EHmmColorIconCell.self, for: indexPath)
        
        let icon = iconModel.stickerList[indexPath.item]
        cell.contentImgV
            .image(icon.thumbName)
            .backgroundColor(.clear)
        
        cell.contentImgV.layer.cornerRadius = 56/2
        cell.contentImgV.layer.masksToBounds = true
        cell.contentImgV.contentMode(.scaleAspectFit)
        if icon.bigName == "color" {
            if let color = EHmmDataManager.default.isSelectColor {
                cell.contentImgV
                    .image("change_color_ic")
                cell.contentImgV.backgroundColor(color)
                cell.contentImgV.contentMode(.center)
            } else {
                cell.contentImgV
                    .image("edit_color_ic")
                cell.contentImgV.backgroundColor(.clear)
            }
        } else {
            if isPro {
                cell.contentImgV.backgroundColor(UIColor.clear)
            } else {
                cell.contentImgV.backgroundColor(UIColor(hexString: "#D8D8D8")!)
            }
            
        }
        
        if isPro {
            cell.vipImgV.isHidden = false
        } else {
            cell.vipImgV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconModel.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EHmmColorIconView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 140
        let padding: CGFloat = (140 - 56 * 2 - 16) / 2
        
        return UIEdgeInsets(top: padding, left: 20, bottom: padding, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension EHmmColorIconView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectBlock?(iconModel.stickerList[indexPath.item], isPro)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class EHmmColorIconCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let vipImgV = UIImageView()
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
        
        //
        vipImgV
            .contentMode(.scaleAspectFit)
            .image("coin_dollar_pic")
            .adhere(toSuperview: contentView)
        vipImgV.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.top.right.equalToSuperview()
        }
        
        
        
    }
}






