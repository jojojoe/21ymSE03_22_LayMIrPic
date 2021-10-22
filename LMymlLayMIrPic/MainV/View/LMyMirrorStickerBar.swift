//
//  LMyMirrorStickerBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyMirrorStickerBar: UIView {

    var collection: UICollectionView!
    var currentStickerItem: NEymEditToolItem?
    var clickStickerBlock: ((NEymEditToolItem, Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LMyMirrorStickerBar {
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
            $0.right.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(80)
        }
        collection.register(cellWithClass: LMyMirrorStickerCell.self)
    }
}

extension LMyMirrorStickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyMirrorStickerCell.self, for: indexPath)
        cell.iconImgV.layer.cornerRadius = cell.bounds.width / 2
        cell.iconImgV.layer.masksToBounds = true
        let item = LMynARTDataManager.default.stickerItemList[indexPath.item]
        cell.iconImgV.image = UIImage(named: item.thumbName)
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipBgV.isHidden = true
        } else {
            cell.vipBgV.isHidden = false
        }
//        if currentStickerItem == item {
//            cell.selectImgV.isHidden = false
//        } else {
//            cell.selectImgV.isHidden = true
//        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.stickerItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyMirrorStickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension LMyMirrorStickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = LMynARTDataManager.default.stickerItemList[indexPath.item]
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            currentStickerItem = item
            collectionView.reloadData()
            clickStickerBlock?(item, false)
        } else {
            clickStickerBlock?(item, true)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}







class LMyMirrorStickerCell: UICollectionViewCell {
    
    var iconImgV = UIImageView()
//    var selectImgV = UIImageView()
    var vipImgV = UIImageView()
    var vipBgV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        let bgView = UIView()
        bgView
            .backgroundColor(UIColor.white.withAlphaComponent(0.2))
            .adhere(toSuperview: contentView)
        bgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        bgView.layer.cornerRadius = 24
        
        iconImgV.contentMode = .scaleAspectFit
        contentView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
//        selectImgV.contentMode = .scaleAspectFit
//        selectImgV.image = UIImage(named: "edit_ic_choose")
//        addSubview(selectImgV)
//        selectImgV.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.height.equalTo(24)
//        }
        //
        //
        vipBgV.layer.cornerRadius = 10
        vipBgV
            .backgroundColor(UIColor(hexString: "#674FFF")!)
            .adhere(toSuperview: contentView)
        vipBgV
            .snp.makeConstraints {
                $0.right.bottom.equalToSuperview()
                $0.width.height.equalTo(20)
            }
        //
        vipImgV.image = UIImage(named: "popup_diamond")
        vipImgV.contentMode = .scaleAspectFit
        vipImgV.clipsToBounds = true
        vipBgV.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(10)
            $0.height.equalTo(10)
            
        }
        
        
    }
    
    
    
}


