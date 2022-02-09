//
//  EHmmEditIconView.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/21.
//

import UIKit


class EHmmEditIconView: UIView {
    var paidIconModel: EHmmIconModel
    var selectBlock: ((EHmmCyStickerItem, Bool)->Void)?
    
    var colorBar: EHmmColorIconView?
    
    init(frame: CGRect, paidIconModel: EHmmIconModel) {
        self.paidIconModel = paidIconModel
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    

}

extension EHmmEditIconView {
    func loadData() {
        
    }
    
    func setupView() {
        if let colorIcon = EHmmDataManager.default.colorIconItem {
            colorBar = EHmmColorIconView(frame: .zero, iconModel: colorIcon)
            colorBar?.isPro = false
            colorBar?.adhere(toSuperview: self)
            colorBar?.snp.makeConstraints {
                $0.right.left.equalToSuperview()
                $0.top.equalToSuperview()
                $0.bottom.equalTo(self.snp.centerY)
            }
            colorBar?.selectBlock = {
                [weak self] item, _ in
                guard let `self` = self else {return}
                self.selectBlock?(item, true)
                
            }
        }
       
        let paidIconBar = EHmmColorIconView(frame: .zero, iconModel: paidIconModel)
        paidIconBar.isPro = true
        paidIconBar.adhere(toSuperview: self)
        paidIconBar.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.snp.centerY)
        }
        paidIconBar.selectBlock = {
            [weak self] item, _ in
            guard let `self` = self else {return}
            self.selectBlock?(item, false)
            
        }
        
    }
    
    
}
