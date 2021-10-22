//
//  LmYmLayoutBgColorView.swift
//  LMymlLayMIrPic
//
//  Created by JOJO on 2021/9/2.
//

import UIKit
 
class LmYmLayoutBgColorView: UIView {
    
    
    var collectionColor: UICollectionView!
    var collectionBgImg: UICollectionView!
    var currentSelectItem: NEymEditToolItem?
    var didSelectBgItemBlock:((NEymEditToolItem, _ isPro: Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LmYmLayoutBgColorView {
    
    
    func setupView() {
         
        
        //
        let layout_c = UICollectionViewFlowLayout()
        layout_c.scrollDirection = .horizontal
        collectionColor = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_c)
        collectionColor.showsVerticalScrollIndicator = false
        collectionColor.showsHorizontalScrollIndicator = false
        collectionColor.backgroundColor = .clear
        collectionColor.delegate = self
        collectionColor.dataSource = self
        addSubview(collectionColor)
        collectionColor.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(snp.centerY).offset(-4)
            $0.height.equalTo(48)
        }
        collectionColor.register(cellWithClass: LMLayouBgColorImgCell.self)
        
        
        let layout_i = UICollectionViewFlowLayout()
        layout_i.scrollDirection = .horizontal
        collectionBgImg = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_i)
        collectionBgImg.showsVerticalScrollIndicator = false
        collectionBgImg.showsHorizontalScrollIndicator = false
        collectionBgImg.backgroundColor = .clear
        collectionBgImg.delegate = self
        collectionBgImg.dataSource = self
        addSubview(collectionBgImg)
        collectionBgImg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(snp.centerY).offset(4)
            $0.height.equalTo(48)
        }
        collectionBgImg.register(cellWithClass: LMLayouBgColorImgCell.self)
    }
}


extension LmYmLayoutBgColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        
        if collectionView == collectionColor {
            item = LMynARTDataManager.default.bgColorList[indexPath.item]
        }
        let cell = collectionView.dequeueReusableCell(withClass: LMLayouBgColorImgCell.self, for: indexPath)
        
        cell.contentImgV.layer.cornerRadius = 24
        cell.contentImgV.layer.masksToBounds = true
        if item.thumbName.contains("#") {
            cell.contentImgV.backgroundColor(UIColor(hexString: item.thumbName) ?? UIColor.white)
            cell.contentImgV.image = nil
        } else {
            cell.contentImgV.backgroundColor(UIColor.white)
            cell.contentImgV.image = UIImage(named: item.thumbName)
        }
        
        
        if currentSelectItem?.thumbName == item.thumbName {
            cell.selectImgV.isHidden = false
        } else {
            cell.selectImgV.isHidden = true
        }
        if item.isPro && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipBgV.isHidden = false
        } else {
            cell.vipBgV.isHidden = true
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionColor {
            return LMynARTDataManager.default.bgColorList.count
        } else {
            return             LMynARTDataManager.default.bgColorImgList.count
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LmYmLayoutBgColorView: UICollectionViewDelegateFlowLayout {
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

extension LmYmLayoutBgColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        
        if collectionView == collectionColor {
            item = LMynARTDataManager.default.bgColorList[indexPath.item]
        }
        
        var isPro = false
        
        if item.isPro && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            isPro = true
        } else {
            currentSelectItem = item
            collectionColor.reloadData()
            collectionBgImg.reloadData()
        }
        didSelectBgItemBlock?(item, isPro)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}








class LMLayouBgColorImgCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectImgV = UIImageView()
    let vipBgV = UIView()
    let vipImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
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

