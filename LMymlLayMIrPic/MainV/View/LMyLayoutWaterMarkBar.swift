//
//  LMyLayoutWaterMarkBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit


class LMyLayoutWaterMarkBar: UIView {
    
    var backBtnClickBlock: (()->Void)?
    let textEnterBtn = UIButton(type: .custom)
    let horBtn = UIButton(type: .custom)
    let verBtn = UIButton(type: .custom)
    
    var collection: UICollectionView!
    var list: [String] = []
    var currentWaterItemIndex: Int?
    
    var enterWaterMarkClickBlock: (()->Void)?
    
    var selectWaterMarkClickBlock: ((Int, Bool, String)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        list = ["watermark_cancel", "watermark1", "watermark2", "watermark3", "watermark4", "watermark5", "watermark6"]
    }
    
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    @objc func textEnterBtnClick(sender: UIButton) {
        enterWaterMarkClickBlock?()
    }
    
    
    func setupView() {
         
        
        textEnterBtn.addTarget(self, action: #selector(textEnterBtnClick(sender:)), for: .touchUpInside)
        textEnterBtn.titleColor(UIColor.white.withAlphaComponent(0.5))
        textEnterBtn.title("Text here...")
        textEnterBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 12)
        
        textEnterBtn.contentHorizontalAlignment = .left
        textEnterBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(textEnterBtn)
        textEnterBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.bottom.equalTo(snp.centerY).offset(-8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        //
        let bottomLine = UIView()
        bottomLine.backgroundColor(UIColor.white)
        bottomLine
            .adhere(toSuperview: self)
        bottomLine.snp.makeConstraints {
            $0.left.equalTo(textEnterBtn.snp.left)
            $0.right.equalTo(textEnterBtn.snp.right)
            $0.bottom.equalTo(textEnterBtn.snp.bottom)
            $0.height.equalTo(1)
        }
        
        //
        
        
        
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
            $0.top.equalTo(textEnterBtn.snp.bottom).offset(16)
            $0.height.equalTo(48)
            $0.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: LMLayouWatermarkBarCell.self)
        
        
    }
    
    func updateEnterTextStr(textStr: String?) {
        if let text = textStr, text != "" {
            textEnterBtn.titleColor(UIColor.white)
            textEnterBtn.setTitle(text, for: .normal)
        } else {
            textEnterBtn.titleColor(UIColor.white.withAlphaComponent(0.5))
            textEnterBtn.setTitle("Enter Text Here...", for: .normal)
        }
    }
    
}

extension LMyLayoutWaterMarkBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: LMLayouWatermarkBarCell.self, for: indexPath)
        let item = list[indexPath.item]
        cell.contentImgV.image = UIImage(named: item)
        if indexPath.item == 0 {
            cell.selectImgV.isHidden = true
        } else {
            if currentWaterItemIndex == indexPath.item {
                cell.selectImgV.isHidden = false
            } else {
                cell.selectImgV.isHidden = true
            }
        }
        
        if indexPath.item < 3 || LMymContentUnlockManager.default.hasUnlock(itemId: item) {
            cell.vipBgV.isHidden = true
        } else {
            cell.vipBgV.isHidden = false
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

extension LMyLayoutWaterMarkBar: UICollectionViewDelegateFlowLayout {
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

extension LMyLayoutWaterMarkBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        var isPro = true
        
        if indexPath.item < 3 || LMymContentUnlockManager.default.hasUnlock(itemId: item) {
            currentWaterItemIndex = indexPath.item
            isPro = false
        }
        collectionView.reloadData()
        selectWaterMarkClickBlock?(indexPath.item, isPro, item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class LMLayouWatermarkBarCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectImgV = UIImageView()
    let vipImgV = UIImageView()
    let vipBgV = UIView()
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


