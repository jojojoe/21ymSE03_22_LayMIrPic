//
//  LmymStoreVC.swift
//  LMymlLayMIrPic
//
//  Created by JOJO on 2021/9/2.
//

import UIKit
import NoticeObserveKit

class LmymStoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    
    let storeTopMoveV = UIView()
    var collection: UICollectionView!
    let topCoinLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(UIColor.white)
        setupStoreView()
        addNotificationObserver()
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
    }
    
    func setupStoreView() {
        
 

        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "popup_close_black"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.right.equalToSuperview().offset(-12)
            $0.width.height.equalTo(40)
        }
        //
        //
        let title1 = UILabel()
        title1
            .color(UIColor.black)
            .text("My Wallet")
            .fontName(32, "Inter-Black")
            .adhere(toSuperview: view)
        title1.snp.makeConstraints {
            $0.left.equalTo(32)
            $0.top.equalTo(backBtn.snp.bottom).offset(-20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let title2 = UILabel()
        title2
            .color(UIColor.black)
            .text("Account balance")
            .fontName(16, "Inter-SemiBold")
            .adhere(toSuperview: view)
        title2.snp.makeConstraints {
            $0.left.equalTo(32)
            $0.top.equalTo(title1.snp.bottom).offset(10)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        //
        topCoinLabel
            .textAlignment(.center)
            .text("\(LMymBCartCoinManager.default.coinCount)")
            .color(UIColor(hexString: "#FFAA40")!)
            .fontName(16, "Inter-SemiBold")
            .adhere(toSuperview: view)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(title2.snp.centerY)
            $0.right.equalTo(-35)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let coinImageV = UIImageView()
        coinImageV
            .image("popup_diamond")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        coinImageV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-5)
            $0.width.height.equalTo(24)
        }
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(title2.snp.bottom).offset(35)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LyMymStoreCell.self)
        
    }

    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
    
}

extension LmymStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LyMymStoreCell.self, for: indexPath)
        let item = LMymBCartCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin)"
        cell.priceLabel.text = item.price
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMymBCartCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LmymStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth: CGFloat = 93
        let cellHeight: CGFloat = 120
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 32
        let cellwidth: CGFloat = 93
        let padding: CGFloat = (UIScreen.width - 32 * 2 - cellwidth * 3 - 1) / 2
        
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = 32
        let cellwidth: CGFloat = 93
        let padding: CGFloat = (UIScreen.width - 32 * 2 - cellwidth * 3 - 1) / 2
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = 32
        let cellwidth: CGFloat = 93
        let padding: CGFloat = (UIScreen.width - 32 * 2 - cellwidth * 3 - 1) / 2
        return padding
    }
    
}

extension LmymStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = LMymBCartCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func selectCoinItem(item: StoreItem) {
        LMymBCartCoinManager.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
}

class LyMymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.white //UIColor(hexString: "#149CF5")?.withAlphaComponent(0.2)
        bgView.backgroundColor = UIColor(hexString: "#FF9533")?.withAlphaComponent(0.1)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.top.equalTo(28)
            $0.bottom.left.right.equalToSuperview()
        }
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
 
        
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "popup_diamonds")
        contentView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140/2)
            $0.height.equalTo(92/2)
            
        }
         
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel
            .color(UIColor(hexString: "#FF9533")!)
            .numberOfLines(1)
            .fontName(16, "Inter-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: bgView)

        coinCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(14)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        bgView.addSubview(priceBgImgV)
        priceBgImgV
            .backgroundColor(UIColor.white)
            .image("")
        priceBgImgV.layer.cornerRadius = 8
        priceBgImgV.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        priceBgImgV.layer.shadowOffset = CGSize(width: 0, height: 2)
        priceBgImgV.layer.shadowRadius = 2
        priceBgImgV.layer.shadowOpacity = 0.8
        
        
        priceBgImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-16)
            $0.width.equalTo(76)
            $0.height.equalTo(36)
        }
        priceBgImgV.contentMode = .scaleAspectFill
        //
        priceLabel.textColor = UIColor.black
        priceLabel.font = UIFont(name: "Inter-SemiBold", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.center.equalTo(priceBgImgV)
            $0.height.greaterThanOrEqualTo(36)
            $0.left.equalTo(priceBgImgV.snp.left).offset(4)
        }
        
    }
     
}


