//
//  LMyMirrorPatternBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyMirrorPatternBar: UIView {

    var collection: UICollectionView!
    var currentPatternItem: NEymEditToolItem?
    var clickPatternBlock: ((NEymEditToolItem, Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LMyMirrorPatternBar {
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
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(80)
        }
        collection.register(cellWithClass: LMyMirrorPatternCell.self)
    }
}

extension LMyMirrorPatternBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyMirrorPatternCell.self, for: indexPath)
        
        let item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        cell.iconImgV.image = UIImage(named: item.thumbName)
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipBgV.isHidden = true
        } else {
            cell.vipBgV.isHidden = false
        }
        if currentPatternItem == item {
            cell.selectImgV.isHidden = false
        } else {
            cell.selectImgV.isHidden = true
        }
        cell.iconImgV.layer.cornerRadius = cell.bounds.width / 2
        cell.iconImgV.layer.masksToBounds = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.bgColorImgList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyMirrorPatternBar: UICollectionViewDelegateFlowLayout {
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

extension LMyMirrorPatternBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            currentPatternItem = item
            collectionView.reloadData()
            clickPatternBlock?(item, false)
        } else {
            clickPatternBlock?(item, true)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class LMyMirrorPatternCell: UICollectionViewCell {
    
    var iconImgV = UIImageView()
    var selectImgV = UIImageView()
    var vipImgV = UIImageView()
    let vipBgV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconImgV.contentMode = .scaleAspectFit
        contentView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        selectImgV.backgroundColor(UIColor.black.withAlphaComponent(0.5))
        selectImgV.isHidden = true
        selectImgV.contentMode = .center
        selectImgV.image = UIImage(named: "editor_select")
        selectImgV.clipsToBounds = true
        contentView.addSubview(selectImgV)
        selectImgV.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.center.equalToSuperview()
        }
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


