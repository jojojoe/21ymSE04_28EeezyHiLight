//
//  EHmmBottomBar.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/20.
//

import UIKit


struct BottomBarItem {
    var normalImgName: String
    var selectImgName: String
}



class EHmmBottomBar: UIView {

    var clickBlock: ((BottomBarItem)->Void)?
    
    var list: [BottomBarItem] = []
    var currentItem: BottomBarItem?
    var collection: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func loadData() {
        let item1 = BottomBarItem(normalImgName: "editor_bg", selectImgName: "edit_background_s")
        let item2 = BottomBarItem(normalImgName: "editor_icon", selectImgName: "edit_icon_s")
        let item3 = BottomBarItem(normalImgName: "editor_overlayer", selectImgName: "edit_frame_s")
        
        list = [item1, item2, item3]
    }
    
    
}

extension EHmmBottomBar {
    func setupView() {
        backgroundColor(UIColor(hexString: "#FFFFFF")!)
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
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: GPyyBottomCell.self)
        
        
    }
    
    
    
}

extension EHmmBottomBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GPyyBottomCell.self, for: indexPath)
        let item = list[indexPath.item]
        if currentItem?.normalImgName == item.normalImgName {
            cell.contentImgV.image(item.selectImgName)
            cell.contentImgV.backgroundColor(.clear)
        } else {
            cell.contentImgV.image(item.normalImgName)
            cell.contentImgV.backgroundColor(.clear)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EHmmBottomBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = (UIScreen.width - 56 * 3) / 4
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.width - 56 * 3) / 4
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.width - 56 * 3) / 4
        return padding
    }
    
}

extension EHmmBottomBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        currentItem = item
        collectionView.reloadData()
        clickBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GPyyBottomCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalToSuperview()
        }
        
        
    }
}
