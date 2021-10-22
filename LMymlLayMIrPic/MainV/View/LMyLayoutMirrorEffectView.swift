//
//  LMyLayoutMirrorEffectView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit


class LMyLayoutMirrorEffectView: UIView {
    
    var backBtnClickBlock: (()->Void)?
    
    var horClickStatusBlock: ((Bool)->Void)?
    var verClickStatusBlock: ((Bool)->Void)?
    
    let horBtn = UIButton(type: .custom)
    let verBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    @objc func hornerBtnClick(sender: UIButton) {
        self.horBtn.isSelected = !self.horBtn.isSelected
        horClickStatusBlock?(self.horBtn.isSelected)
    }
    
    @objc func verBtnClick(sender: UIButton) {
        self.verBtn.isSelected = !self.verBtn.isSelected
        verClickStatusBlock?(self.verBtn.isSelected)
    }
    
    func setupView() {
         
        //
        horBtn.layer.cornerRadius = 8
        horBtn
            .backgroundColor(UIColor.white.withAlphaComponent(0.2))
            .image(UIImage(named: "editor_effect_select_1"), .normal)
            .image(UIImage(named: "editor_effect_select_2"), .selected)
            .adhere(toSuperview: self)
        horBtn.addTarget(self, action: #selector(hornerBtnClick(sender:)), for: .touchUpInside)
        
        horBtn.snp.makeConstraints {
            $0.right.equalTo(snp.centerX).offset(-5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(75)
            $0.width.equalTo(160)
        }
        //
        verBtn.layer.cornerRadius = 8
        verBtn
            .backgroundColor(UIColor.white.withAlphaComponent(0.2))
            .image(UIImage(named: "editor_effect_select_3"), .normal)
            .image(UIImage(named: "editor_effect_select_4"), .selected)
            .adhere(toSuperview: self)
        verBtn.addTarget(self, action: #selector(verBtnClick(sender:)), for: .touchUpInside)
        
        
        verBtn.snp.makeConstraints {
            $0.left.equalTo(snp.centerX).offset(5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(75)
            $0.width.equalTo(160)
        }
        
    }
    
}
