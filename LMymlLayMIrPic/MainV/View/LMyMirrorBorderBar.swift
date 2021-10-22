//
//  LMyMirrorBorderBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift

class LMyMirrorBorderBar: UIView {

    let disposeBag = DisposeBag()
    
    let colorSlider = UISlider()
    let borderSlider = UISlider()
    let cornerSlider = UISlider()
    
    var clearBorderBlock: (()->Void)?
    var addBorderBlock: ((UIColor?, Float, Float)->Void)?
    
    let colorSliderImage = UIImage(named: "editor_color")
    let colorLabelCount = UILabel()
    let borderLabelCount = UILabel()
    let cornerLabelCount = UILabel()
    
    var isOpenBorder: Bool = true {
        didSet {
            if isOpenBorder == true {
                colorSlider.value = currentColorValue
                borderSlider.value = currentBorderValue
                cornerSlider.value = currentCornerValue
                colorSlider.isUserInteractionEnabled = true
                borderSlider.isUserInteractionEnabled = true
                cornerSlider.isUserInteractionEnabled = true
                
                addBorderBlock?(currentColor, currentBorderValue, currentCornerValue)
            } else {
                colorSlider.isUserInteractionEnabled = false
                borderSlider.isUserInteractionEnabled = false
                cornerSlider.isUserInteractionEnabled = false
                colorSlider.value = 0
                borderSlider.value = 0
                cornerSlider.value = 0
                
                clearBorderBlock?()
                
            }
        }
    }
//    let borderClearBtn = UIButton(type: .custom)
//    let borderAddBtn = UIButton(type: .custom)
    
    var currentColorValue: Float = 0
    var currentBorderValue: Float = 0.2
    var currentCornerValue: Float = 0
    var currentColor: UIColor = .white
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LMyMirrorBorderBar {
    func setupView() {
        
//        borderClearBtn
//            .image(UIImage(named: "mirror_border_ic_no"), .normal)
//            .rx.tap
//            .subscribe(onNext:  {
//                [weak self] in
//                guard let `self` = self else {return}
//                self.borderAddBtn.isSelected = false
//                self.currentColor = UIColor.white
//                self.currentColorValue = 0
//                self.currentBorderValue = 0
//                self.currentCornerValue = 0
//                self.isOpenBorder = false
//            })
//            .disposed(by: disposeBag)
//
//        addSubview(borderClearBtn)
//        borderClearBtn.snp.makeConstraints {
//            $0.top.equalTo(0)
//            $0.right.equalTo(snp.centerX).offset(-10)
//            $0.width.height.equalTo(54)
//        }
//        //
//
//        borderAddBtn
//            .image(UIImage(named: "mirror_border_unselect"), .normal)
//            .image(UIImage(named: "mirror_border_select"), .selected)
//            .rx.tap
//            .subscribe(onNext:  {
//                [weak self] in
//                guard let `self` = self else {return}
//                self.currentColorValue = 0.0
//                self.currentBorderValue = 0.2
//                self.currentCornerValue = 0.0
//                self.borderAddBtn.isSelected = true
//                self.isOpenBorder = true
//            })
//            .disposed(by: disposeBag)
//
//        borderAddBtn.isSelected = true
//        addSubview(borderAddBtn)
//        borderAddBtn.snp.makeConstraints {
//            $0.top.equalTo(0)
//            $0.left.equalTo(snp.centerX).offset(10)
//            $0.width.height.equalTo(54)
//        }
        
        //
        
        colorSlider
            .rx.value
            .subscribe(onNext:  {
                [weak self] value in
                guard let `self` = self else {return}
                self.updateColorAction(value: value)
            })
            .disposed(by: disposeBag)
        addSubview(colorSlider)
//
        borderSlider
            .rx.value
            .subscribe(onNext:  {
                [weak self] value in
                guard let `self` = self else {return}
                
                self.updateBorderAction(value: value)
            })
            .disposed(by: disposeBag)
        addSubview(borderSlider)
//
        cornerSlider
            .rx.value
            .subscribe(onNext:  {
                [weak self] value in
                guard let `self` = self else {return}
                self.updateCornerAction(value: value)
            })
            .disposed(by: disposeBag)
        addSubview(cornerSlider)
        //
        colorSlider.setThumbImage(UIImage(named: ""), for: .normal)
        colorSlider.setMaximumTrackImage(colorSliderImage, for: .normal)
        colorSlider.setMinimumTrackImage(colorSliderImage, for: .normal)
        colorSlider.minimumValue = 0
        colorSlider.maximumValue = 1
        //
        borderSlider.setThumbImage(UIImage(named: ""), for: .normal)
        borderSlider.minimumTrackTintColor = UIColor(hexString: "#674FFF")
        borderSlider.maximumTrackTintColor = UIColor(hexString: "#FFFFFF")?.withAlphaComponent(0.35)
        borderSlider.minimumValue = 0
        borderSlider.maximumValue = 1
        
        //
        cornerSlider.setThumbImage(UIImage(named: "mirror_border_slider_ball"), for: .normal)
        cornerSlider.minimumTrackTintColor = UIColor(hexString: "#674FFF")
        cornerSlider.maximumTrackTintColor = UIColor(hexString: "#FFFFFF")?.withAlphaComponent(0.35)
        cornerSlider.minimumValue = 0
        cornerSlider.maximumValue = 1

        //
        borderSlider.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY).offset(0)
            $0.left.equalTo(85)
            $0.right.equalTo(-70)
            $0.height.equalTo(30)
        }
        
        colorSlider.snp.makeConstraints {
            $0.bottom.equalTo(borderSlider.snp.top).offset(-15)
            $0.left.equalTo(85)
            $0.right.equalTo(-70)
            $0.height.equalTo(30)
        }
        
        cornerSlider.snp.makeConstraints {
            $0.top.equalTo(borderSlider.snp.bottom).offset(15)
            $0.left.equalTo(85)
            $0.right.equalTo(-70)
            $0.height.equalTo(30)
        }
        //
        let colorLabel = UILabel()
            .text("Colour")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        let borderLabel = UILabel()
            .text("Border")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        let cornerLabel = UILabel()
            .text("Corner")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        
        colorLabel.adjustsFontSizeToFitWidth = true
        cornerLabel.adjustsFontSizeToFitWidth = true
        borderLabel.adjustsFontSizeToFitWidth = true
        
        colorLabel.snp.makeConstraints {
            $0.centerY.equalTo(colorSlider.snp.centerY)
            $0.right.equalTo(colorSlider.snp.left).offset(-4)
            $0.left.equalTo(30)
            $0.height.greaterThanOrEqualTo(1)
        }
        borderLabel.snp.makeConstraints {
            $0.centerY.equalTo(borderSlider.snp.centerY)
            $0.right.equalTo(borderSlider.snp.left).offset(-4)
            $0.left.equalTo(30)
            $0.height.greaterThanOrEqualTo(1)
        }
        cornerLabel.snp.makeConstraints {
            $0.centerY.equalTo(cornerSlider.snp.centerY)
            $0.right.equalTo(cornerSlider.snp.left).offset(-4)
            $0.left.equalTo(30)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        //

        colorLabelCount
            .text("0")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)

        borderLabelCount
            .text("0")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        
        cornerLabelCount
            .text("0")
            .fontName(12, "Inter-SemiBold")
            .color(UIColor.white)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        
        colorLabelCount.adjustsFontSizeToFitWidth = true
        cornerLabelCount.adjustsFontSizeToFitWidth = true
        borderLabelCount.adjustsFontSizeToFitWidth = true
        
        colorLabelCount.snp.makeConstraints {
            $0.centerY.equalTo(colorSlider.snp.centerY)
            $0.width.greaterThanOrEqualTo(1)
            $0.right.equalTo(-24)
            $0.height.greaterThanOrEqualTo(1)
        }
        borderLabelCount.snp.makeConstraints {
            $0.centerY.equalTo(borderSlider.snp.centerY)
            $0.width.greaterThanOrEqualTo(1)
            $0.right.equalTo(-24)
            $0.height.greaterThanOrEqualTo(1)
        }
        cornerLabelCount.snp.makeConstraints {
            $0.centerY.equalTo(cornerSlider.snp.centerY)
            $0.width.greaterThanOrEqualTo(1)
            $0.right.equalTo(-24)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        self.currentColorValue = 0.0
        self.currentBorderValue = 0.2
        self.currentCornerValue = 0.0
        self.borderSlider.value = 0.2
        
        colorLabelCount.text("\(Int(currentColorValue * 100))")
        cornerLabelCount.text("\(Int(currentCornerValue * 100))")
        borderLabelCount.text("\(Int(currentBorderValue * 100))")
        
    }
    
    func updateColorAction(value: Float) {
        currentColorValue = value
        colorLabelCount.text("\(Int(value * 100))")
        
        
        let x = (602/2) * CGFloat(value)
        let point = CGPoint(x: x, y: 3)
        if let imgColor = cxg_getPointColor(withImage: colorSliderImage!, point: point) {
            currentColor = imgColor
        }
        
        addBorderBlock?(currentColor, currentBorderValue, currentCornerValue)
    }
    
    func updateBorderAction(value: Float) {
        borderLabelCount.text("\(Int(value * 100))")
        currentBorderValue = value
        addBorderBlock?(nil, currentBorderValue, currentCornerValue)
    }
    
    func updateCornerAction(value: Float) {
        cornerLabelCount.text("\(Int(value * 100))")
        currentCornerValue = value
        addBorderBlock?(nil, currentBorderValue, currentCornerValue)
    }
    
    
    
    func cxg_getPointColor(withImage image: UIImage, point: CGPoint) -> UIColor? {
        
        guard CGRect(origin: CGPoint(x: 0, y: 0), size: image.size).contains(point) else {
            return nil
        }
        
        if point.x == 0 {
            return UIColor.white
        }
        
        let pointX = trunc(point.x);
        let pointY = trunc(point.y);
        
        let width = image.size.width;
        let height = image.size.height;
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = image.cgImage {
                context.setBlendMode(.copy)
                context.translateBy(x: -pointX, y: pointY - height)
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return UIColor(r: red, g: green, b: blue, a: alpha)
        }
    }
    
}




