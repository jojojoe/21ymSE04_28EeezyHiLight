//
//  EHyAutoScrollView.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/21.
//

import UIKit
import SnapKit
import SwifterSwift


enum EHyAutoScrollDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
}

struct EHyAutoScrollConfig {

    var scrollDirection: EHyAutoScrollDirection = .toLeft
    var padding: CGFloat = 10
    var cellCornerRadius: CGFloat = 10
    var timeInterval: TimeInterval = 0.01 ///滚动的时间间隔,是每次滚动的距离需要的时间，设置越小，移动越快。默认是0.05秒
     
    
    /// 固定
    var scrollStep: CGFloat = 0.5 ///每次滚动的距离 默认为1个像素
    var repeatCount: Int = 100
    var maxTimeInterval: TimeInterval = 0.2
    var minTimeInterval: TimeInterval = 0.0005
     
}

class EHyAutoScrollView: UIView {

    var contentViewList: [UIView] = []
    var contentRect: CGRect = .zero
    var scrollConfig: EHyAutoScrollConfig = EHyAutoScrollConfig()
    var contentBgView: UIView = UIView.init()
    var contentCollection = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var currentCenterIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var scrollTimer: Timer?
    var timer: Timer?
    
    var tapClickViewActionBlock:(()->Void)?
    var cellClickViewActionBlock:((Int)->Void)?
 
    
    var currentCenterChangeBlock:((Int)->Void)?
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        invalidateTimer()
    }
    
    init(frame: CGRect, viewsList: [UIView]) {

        contentRect = frame
        contentViewList = viewsList

        super.init(frame: frame)
        if viewsList.count != 0 {
            setupView()
            setupCollectoin()
            setupTimer()
            setupTapGesture()
        }
        
        //
//        addScaleAnimal(isAdd: true)
//        addShakeAnimal(isAdd: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // view
        self.backgroundColor = .clear
        contentBgView.frame = CGRect.init(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        contentBgView.backgroundColor = .clear
        addSubview(contentBgView)
        
        
    }
    
    func setupCollectoin() {
    // collection view
        contentCollection.backgroundColor = .clear
        contentCollection.dataSource = self
        contentCollection.delegate = self
        contentCollection.showsVerticalScrollIndicator = false
        contentCollection.showsHorizontalScrollIndicator = false
        contentCollection.frame = CGRect.init(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        
        contentBgView.addSubview(contentCollection)
 
        updateScrollDirection(direction: scrollConfig.scrollDirection)
        contentCollection.register(cellWithClass: EHyAutoScrollCell.self)
    }
    
    func setupTimer() {
        if let scrollTimer_m = scrollTimer {
            scrollTimer_m.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: scrollConfig.timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//        stopScroll()
    }
 
    @objc
    func timerAction() {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        switch scrollConfig.scrollDirection {
        case .toLeft:
            offsetX = contentCollection.contentOffset.x + scrollConfig.scrollStep
            offsetY = contentCollection.contentOffset.y
            if offsetX >= contentCollection.contentSize.width - contentRect.size.width {
                offsetX = 0
            }
        case .toRight:
            offsetX = contentCollection.contentOffset.x - scrollConfig.scrollStep
            offsetY = contentCollection.contentOffset.y
            if offsetX <= 0 {
                offsetX = contentCollection.contentSize.width - contentRect.size.width
            }
        case .toTop:
            offsetX = contentCollection.contentOffset.x
            offsetY = contentCollection.contentOffset.y + scrollConfig.scrollStep
            if offsetY >= contentCollection.contentSize.height - contentRect.size.height {
                offsetY = 0
            }
            
        case .toBottom:
            offsetX = contentCollection.contentOffset.x
            offsetY = contentCollection.contentOffset.y + scrollConfig.scrollStep
            if offsetY <= 0 {
                offsetY = contentCollection.contentSize.height - contentRect.size.height
            }
            
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else {return}
            self.contentCollection.setContentOffset(CGPoint.init(x: offsetX, y: offsetY), animated: false)
            
            if let indexP = self.contentCollection.indexPathForItem(at: CGPoint(x: offsetX + self.contentCollection.bounds.width / 2, y: self.contentCollection.bounds.height / 2)) {
                
                if self.currentCenterIndexPath.item == indexP.item {
                    
                } else {
                    let realCount = indexP.item % self.contentViewList.count
                    self.currentCenterChangeBlock?(realCount)
                }
                self.currentCenterIndexPath = indexP
            }
           
        }
    }
    
    func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
//        self.contentCollection.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func tapAction() {
        debugPrint("tap collection")
        tapClickViewActionBlock?()
    }
    
}

// public
extension EHyAutoScrollView {
    
    func startScroll() {
        scrollTimer?.fireDate = Date.init(timeIntervalSinceNow: 0.5) //.5秒后开启
    }
    
    func stopScroll() {
        scrollTimer?.fireDate = Date.distantFuture    // 暂停
    }
    
    func invalidateTimer() {
        scrollTimer?.invalidate()
    }
    
    // 更新滚动方向
    func updateScrollDirection(direction: EHyAutoScrollDirection) {
        
        scrollConfig.scrollDirection = direction
        
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        var direction: UICollectionView.ScrollDirection = .horizontal
        switch scrollConfig.scrollDirection {
        case .toLeft:
            direction = .horizontal
            offsetX = 0
            offsetY = 0
        case .toRight:
            direction = .horizontal
            offsetX = contentCollection.contentSize.width - contentRect.size.width
            offsetY = 0
        case .toTop:
            direction = .vertical
            offsetX = 0
            offsetY = 0
        case .toBottom:
            direction = .vertical
            offsetX = 0
            offsetY = contentCollection.contentSize.height - contentRect.size.height
        
        }
        
        let collectionLayout = contentCollection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionLayout?.scrollDirection = direction
        
        contentCollection.setContentOffset(CGPoint.init(x: offsetX, y: offsetY), animated: false)
        
    }
    
    // 滚动速度
    func undateScrollSpeed(speed: CGFloat) {
        if speed == 0 {
            stopScroll()
        } else {
            var currentInterval: TimeInterval = (scrollConfig.maxTimeInterval - TimeInterval(speed))
            if currentInterval <= scrollConfig.minTimeInterval {
                currentInterval = scrollConfig.minTimeInterval
            }
            scrollConfig.timeInterval = currentInterval
            setupTimer()
            startScroll()
        }
    }
     
    // 缩放动画
    func addScaleAnimal(isAdd: Bool) {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "transform.scale")
            // rotation 旋转，需要添加弧度值
            animati.values = [1.2,0.5,1.2]
            animati.calculationMode = .cubic
            animati.rotationMode = .rotateAutoReverse
            animati.duration = 1
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "transform.scale.key")
        } else {
            contentBgView.layer.removeAnimation(forKey: "transform.scale.key")
        }
    }
    
    // 旋转动画
    func addShakeAnimal(isAdd: Bool)  {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "transform.rotation")
            // rotation 旋转，需要添加弧度值
            animati.values = [angle2Radion(angle: -50), angle2Radion(angle: 50), angle2Radion(angle: -50)]
            animati.duration = 1
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "transform.rotation.key")
        } else {
            
            contentBgView.layer.removeAnimation(forKey: "transform.rotation.key")
        }
        
    }
    
    // 透明度动画
    func addContentAlphaAnimation(isAdd: Bool) {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "opacity")
            // rotation 旋转，需要添加弧度值
            animati.values = [0,1]
            animati.duration = 1
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "content.opacity.key")
        } else {
            
            contentBgView.layer.removeAnimation(forKey: "content.opacity.key")
        }
    }
    
    // 更新文字内容
    func updateContentString(viewsList: [UIView]) {
        contentViewList = viewsList
        contentCollection.reloadData()
    }
    
}

extension EHyAutoScrollView {
    
    func angle2Radion(angle: Float) -> Float {
        return angle / Float(180.0 * Double.pi)
    }
}


extension EHyAutoScrollView {
    func cellSize(indexPath: IndexPath) -> CGSize {
        
        let realCount = indexPath.item % contentViewList.count
        
        let contentView = contentViewList[realCount]
        
        var cellWidth: CGFloat = 0
        var cellHeight: CGFloat = 0
        
        if scrollConfig.scrollDirection == .toLeft || scrollConfig.scrollDirection == .toRight {
            cellWidth = (contentView.size.width / contentView.size.height) * contentRect.size.height
            cellHeight = contentRect.size.height
        } else {
            cellHeight = (contentView.size.height / contentView.size.width) * contentRect.size.width
            cellWidth = contentRect.size.width
        }
        
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
}

extension EHyAutoScrollView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollection.dequeueReusableCell(withClass: EHyAutoScrollCell.self, for: indexPath)
 
        let realCount = indexPath.item % contentViewList.count
        let contentView = contentViewList[realCount]
        if let subView = cell.contentBgView.subviews.last {
            subView.removeFromSuperview()
        }
        if let screenShot = contentView.screenshot {
            let imageView = UIImageView.init(frame: contentView.bounds)
            imageView.image = screenShot
            cell.contentBgView.addSubview(imageView)
        }
        
        cell.contentBgView.clipsToBounds = false
        cell.contentBgView.cornerRadius = scrollConfig.cellCornerRadius
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contentViewList.count * scrollConfig.repeatCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
 
extension EHyAutoScrollView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return scrollConfig.padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return scrollConfig.padding
    }

}

extension EHyAutoScrollView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let realCount = indexPath.item % contentViewList.count
        cellClickViewActionBlock?(realCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}










