//
//  LmYmUNlockView.swift
//  LMymlLayMIrPic
//
//  Created by JOJO on 2021/9/2.
//

import UIKit

 

class LmYmUNlockView: UIView {

    
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor(hexString: "#674FFF")!)
            .adhere(toSuperview: self)
        contentV.layer.cornerRadius = 16
        contentV.layer.masksToBounds = true
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(327)
        }
        //
        let bgImgV = UIImageView()
            .image("popup_diamonds_big-1")
            .contentMode(.center)
            .adhere(toSuperview: contentV)
        bgImgV.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "popup_close_white"))
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        contentV.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(10)
            $0.right.equalTo(contentV.snp.right).offset(-10)
            $0.width.height.equalTo(44)
        }
        //
        
        let titLab = UILabel()
        
            .text("It costs \(LMymBCartCoinManager.default.coinCostCount) coins to unlock paid items.")
            .textAlignment(.center)
            .numberOfLines(0)
            .fontName(24, "Inter-Black")
            .color(.white)
        
        contentV.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(-10)
            $0.left.equalTo(25)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let okBtn = UIButton(type: .custom)
        okBtn.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        okBtn.layer.cornerRadius = 16
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn
            .backgroundColor(UIColor(hexString: "#FF9533")!)
        okBtn
            .backgroundImage(UIImage(named: "costcoin_button_background"))
            .title("Continue")
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        
        contentV.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(279)
            $0.height.equalTo(54)
        }
        
//
        
    }
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
}
