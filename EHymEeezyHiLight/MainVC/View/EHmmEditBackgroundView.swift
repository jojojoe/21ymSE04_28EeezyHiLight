//
//  EHmmEditBackgroundView.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/21.
//

import UIKit

class EHmmEditBackgroundView: UIView {

    var collection: UICollectionView!
    var list: [EHmmCyStickerItem] = []
    
    var selectBlock: ((EHmmCyStickerItem)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    

}

extension EHmmEditBackgroundView {
    func loadData() {
        
        list = EHmmDataManager.default.bgImgList
        
        
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
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: EHmmBgImgCell.self)
    }
    
    
}

extension EHmmEditBackgroundView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: EHmmBgImgCell.self, for: indexPath)
        let item = list[indexPath.item]
//
        
        cell.layer.borderWidth = 0
        if item.thumbName?.contains("#") == true {
            cell.contentImgV.image = nil
            cell.contentImgV.backgroundColor = UIColor(hexString: item.thumbName ?? "#FFFFFF")
            if item.thumbName?.contains("FFFFFF") == true {
                cell.contentImgV.layer.borderColor = UIColor.lightGray.cgColor
                cell.contentImgV.layer.borderWidth = 0.5
            }
        } else {
            cell.contentImgV.image(item.thumbName)
            cell.contentImgV.backgroundColor = UIColor.clear
        }
        
        cell.contentImgV.layer.cornerRadius = (cell.bounds.width/2)
        cell.contentImgV.layer.masksToBounds = true
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EHmmEditBackgroundView: UICollectionViewDelegateFlowLayout {
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

extension EHmmEditBackgroundView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        selectBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


//
//class EHmmBgImgCell: UICollectionViewCell {
//    let contentImgV = UIImageView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupView() {
//        contentImgV.contentMode = .scaleAspectFill
//        contentImgV.clipsToBounds = true
//        contentView.addSubview(contentImgV)
//        contentImgV.snp.makeConstraints {
//            $0.top.right.bottom.left.equalToSuperview()
//        }
//        
//        
//    }
//}
//



