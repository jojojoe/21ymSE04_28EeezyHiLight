//
//  EHyAutoScrollCell.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/21.
//

import UIKit

class EHyAutoScrollCell: UICollectionViewCell {
    var contentBgView: UIView!
    
    
    override init(frame: CGRect) {
        contentBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        contentBgView.backgroundColor = UIColor.clear
        addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
    }
    
    
}
