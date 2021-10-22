//
//  LMyLayoutBorderView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit



class LMyLayoutBorderView: UIView {
    
    var currentBorder: CGFloat = 0
    var currentCorner: CGFloat = 0
    
    var borderSlider: UISlider = UISlider()
    var cornerSlider: UISlider = UISlider()
    
    var borderSliderValueChangeBlock: ((CGFloat)->Void)?
    var cornerSliderValueChangeBlock: ((CGFloat)->Void)?
    
    let cornerValueLabel = UILabel()
    let borderValueLabel = UILabel()
    
//    var didSelectBorderIntmBlock: ((Int)->Void)?
//    var didSelectCornerIntBlock: ((Int)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData() {
         
    }
}


extension LMyLayoutBorderView {
    func setupView() {
        backgroundColor(.black)
        //
        let borderLabel = UILabel()
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .text("Border")
            .adhere(toSuperview: self)
            .textAlignment(.left)
        borderLabel.adjustsFontSizeToFitWidth = true
        borderLabel.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY).offset(-22)
            $0.left.equalTo(24)
            $0.width.equalTo(60)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let cornerLabel = UILabel()
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .text("Corner")
            .adhere(toSuperview: self)
            .textAlignment(.left)
        cornerLabel.adjustsFontSizeToFitWidth = true
        cornerLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(22)
            $0.left.equalTo(24)
            $0.width.equalTo(60)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        borderSlider.minimumValue = 0
        borderSlider.maximumValue = 1
        borderSlider.value = 0
        borderSlider.thumbTintColor = UIColor.white
        borderSlider.minimumTrackTintColor = UIColor(hexString: "#674FFF")
        borderSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        borderSlider.adhere(toSuperview: self)
        borderSlider
            .snp.makeConstraints {
                $0.centerY.equalTo(borderLabel)
                $0.left.equalTo(90)
                $0.right.equalTo(-70)
                $0.height.greaterThanOrEqualTo(1)
            }
        borderSlider.addTarget(self, action: #selector(borderSliderChange(sender:)), for: .valueChanged)
        //

        cornerSlider.minimumValue = 0
        cornerSlider.maximumValue = 1
        cornerSlider.value = 0
        cornerSlider.thumbTintColor = UIColor.white
        cornerSlider.minimumTrackTintColor = UIColor(hexString: "#674FFF")
        cornerSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        cornerSlider.adhere(toSuperview: self)
        cornerSlider
            .snp.makeConstraints {
                $0.centerY.equalTo(cornerLabel)
                $0.left.equalTo(90)
                $0.right.equalTo(-70)
                $0.height.greaterThanOrEqualTo(1)
            }
        cornerSlider.addTarget(self, action: #selector(cornerSliderChange(sender:)), for: .valueChanged)
        //

        borderValueLabel
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .text("0")
            .adhere(toSuperview: self)
            .textAlignment(.right)
        borderValueLabel.adjustsFontSizeToFitWidth = true
        borderValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(borderLabel.snp.centerY)
            $0.right.equalTo(-24)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        
        cornerValueLabel
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .text("0")
            .adhere(toSuperview: self)
            .textAlignment(.right)
        cornerValueLabel.adjustsFontSizeToFitWidth = true
        cornerValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(cornerLabel.snp.centerY)
            $0.right.equalTo(-24)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        
        
    }
    
    
    @objc func borderSliderChange(sender: UISlider) {
        borderValueLabel
            .text("\(Int(sender.value * 100))")
        borderSliderValueChangeBlock?(CGFloat(sender.value))
    }
    
    @objc func cornerSliderChange(sender: UISlider) {
        cornerValueLabel
            .text("\(Int(sender.value * 100))")
        cornerSliderValueChangeBlock?(CGFloat(sender.value))
    }

}

 
