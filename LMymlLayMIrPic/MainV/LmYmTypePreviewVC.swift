//
//  LmYmTypePreviewVC.swift
//  LMymlLayMIrPic
//
//  Created by JOJO on 2021/9/2.
//

import UIKit


class LmYmTypePreviewVC: UIViewController {
    
    var upVC: UIViewController?
    var collection: UICollectionView!
    let coinAlertView = LmYmUNlockView()
    var currentUnlockItemStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUnlockAlertView()
    }
    
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }
    

}

extension LmYmTypePreviewVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        let topTitleLabel = UILabel()
        topTitleLabel
            .fontName(24, "Verdana-Bold")
            .color(.black)
            .text("Layouts")
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "popup_close_black"))
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-20)
            $0.width.height.equalTo(44)
        }
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: LMyLayoutTypeSelectCell.self)
        
    }
    
    func showUnlockCoinAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if LMymBCartCoinManager.default.coinCount >= LMymBCartCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    if let unlockStr = self.currentUnlockItemStr {
                        LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
                        LMymContentUnlockManager.default.unlock(itemId: unlockStr) {
                            DispatchQueue.main.async {
                                [weak self] in
                                guard let `self` = self else {return}
                                self.collection.reloadData()
                            }
                        }
                    }
                }
            } else {
                //
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "There are not enough coins available, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            
                            let storeVC = LmymStoreVC()
                            self.present(storeVC, animated: true, completion: nil)
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
    }
}

extension LmYmTypePreviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyLayoutTypeSelectCell.self, for: indexPath)
        let item = LMynARTDataManager.default.layoutTypeList[indexPath.item]
        cell.contentImgV.image = UIImage(named: item.thumbName)
        if item.isPro == true && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipBgV.isHidden = false
        } else {
            cell.vipBgV.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.layoutTypeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LmYmTypePreviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let left: CGFloat = 30
        let padding: CGFloat = 17
        let width: CGFloat = (UIScreen.width - left * 2 - padding * 2) / 3
        
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 30
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

extension LmYmTypePreviewVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = LMynARTDataManager.default.layoutTypeList[indexPath.item]
        if item.isPro == true && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            currentUnlockItemStr = item.thumbName
            showUnlockCoinAlertView()
        } else {
            self.dismiss(animated: true) {
                DispatchQueue.main.async {
                    let type = LMynARTDataManager.default.layoutTypeList[indexPath.item]
                     
                    let vc = LMyLayoutEditVC(layoutType: type.bigName)
                    self.upVC?.navigationController?.pushViewController(vc)
                }
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class LMyLayoutTypeSelectCell: UICollectionViewCell {
    let contentImgV = UIImageView()
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
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        //
        vipBgV.layer.cornerRadius = 10
        vipBgV
            .backgroundColor(UIColor(hexString: "#674FFF")!)
            .adhere(toSuperview: contentView)
        vipBgV
            .snp.makeConstraints {
                $0.right.bottom.equalToSuperview().offset(-4)
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
