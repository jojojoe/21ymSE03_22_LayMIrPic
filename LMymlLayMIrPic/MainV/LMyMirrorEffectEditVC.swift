//
//  LMyMirrorEffectEditVC.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import Photos
import DeviceKit


class LMyMirrorEffectEditVC: UIViewController, UINavigationControllerDelegate {

    var originalImg: UIImage
    let backBtn = UIButton(type: .custom)
    let bottonToolBar = UIView()
    let effectBtn = LMyMirrorEffectToolBtn(frame: CGRect.zero, iconStr: "editor_effect_select_3", iconStr_sel: "editor_effect_select", name: "Effect", color_sel: "#674FFF")
    let borderBtn = LMyMirrorEffectToolBtn(frame: CGRect.zero, iconStr: "editor_border", iconStr_sel: "editor_border_select", name: "Border", color_sel: "#674FFF")
    let patternBtn = LMyMirrorEffectToolBtn(frame: CGRect.zero, iconStr: "editor_pattern", iconStr_sel: "editor_pattern_select", name: "Pattern", color_sel: "#674FFF")
    let stickerBtn = LMyMirrorEffectToolBtn(frame: CGRect.zero, iconStr: "editor_sitcker", iconStr_sel: "editor_sitcker_select", name: "Sticker", color_sel: "#674FFF")
    
    let toolContentBgView = UIView()
    let canvasBgView = UIView()
    
    let mirrorEffectBar = LMyMirrorEffectBar()
    let mirrorBorderBar = LMyMirrorBorderBar()
    let mirrorPatterBar = LMyMirrorPatternBar()
    let mirrorStickerBar = LMyMirrorStickerBar()
    
    var mirrorEditCanvas: LMyMirrorEditCanvasView!
    let coinAlertView = LmYmUNlockView()
    var currentUnlockItemStr: String?
    
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToolContentBgView()
        setupUnlockAlertView()
        setupDefaultStatus()
    }
    
    func setupDefaultStatus() {
        effectBtn.updateSeleStatus(isSelect: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            [weak self] in
            guard let `self` = self else {return}
            
        }
        
        
    }
 
}

extension LMyMirrorEffectEditVC {
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
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
                                self.mirrorPatterBar.collection.reloadData()
                                self.mirrorStickerBar.collection.reloadData()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "There are not enough coins available, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.present(LmymStoreVC(), animated: true, completion: nil)
                            
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

extension LMyMirrorEffectEditVC {
    
    @objc func saveBtnClick(sender: UIButton) {
        self.saveAction()
    }
    
    @objc func backBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        TMTouchAddonManager.default.clearAddonManagerDefaultStatus()
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        view.backgroundColor = UIColor.black
        //
        
        backBtn
            .image(UIImage(named: "editor_back"))
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .image(UIImage(named: "editor_download"))
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        //
        
        view.addSubview(bottonToolBar)
        bottonToolBar.backgroundColor = UIColor(hexString: "#FFFFFF")?.withAlphaComponent(0.05)
        bottonToolBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        //
        let btnWidth: CGFloat = 70
        let btnH: CGFloat = 55
        let padding: CGFloat = (UIScreen.width - (4 * btnWidth)) / 5
        
        //
        
        bottonToolBar.addSubview(effectBtn)
        effectBtn.snp.makeConstraints {
            $0.left.equalTo(padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnH)
        }
        effectBtn.clickblock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.selectBtnTool(toolbtn: self.effectBtn, toolBar: self.mirrorEffectBar)
            }
        }
        //
        
        bottonToolBar.addSubview(borderBtn)
        borderBtn.snp.makeConstraints {
            $0.left.equalTo(effectBtn.snp.right).offset(padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnH)
        }
        borderBtn.clickblock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.selectBtnTool(toolbtn: self.borderBtn, toolBar: self.mirrorBorderBar)
            }
        }
        //
        
        bottonToolBar.addSubview(patternBtn)
        patternBtn.snp.makeConstraints {
            $0.left.equalTo(borderBtn.snp.right).offset(padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnH)
        }
        patternBtn.clickblock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.selectBtnTool(toolbtn: self.patternBtn, toolBar: self.mirrorPatterBar)
            }
        }
        //
        
        bottonToolBar.addSubview(stickerBtn)
        stickerBtn.snp.makeConstraints {
            $0.left.equalTo(patternBtn.snp.right).offset(padding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnH)
        }
        stickerBtn.clickblock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.selectBtnTool(toolbtn: self.stickerBtn, toolBar: self.mirrorStickerBar)
            }
        }
        
    }
    
    func setupToolContentBgView() {
        toolContentBgView.backgroundColor = .clear
        view.addSubview(toolContentBgView)
        toolContentBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottonToolBar.snp.top)
            $0.height.equalTo(202)
        }
        //
        //mirrorEffectBar
        toolContentBgView.addSubview(mirrorEffectBar)
        mirrorEffectBar.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        mirrorEffectBar.clickMirrorTypeBlock = {
            [weak self] typeInt in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updatePhotoCanvasMirrorEffect(type: typeInt)
            }
            
        }
        
        //
        //
        toolContentBgView.addSubview(mirrorBorderBar)
        mirrorBorderBar.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(190)
        }
        mirrorBorderBar.clearBorderBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updatePhotoCanvasMirrorBorder(color: UIColor.white, border: 0, corner: 0)
            }
        }
        mirrorBorderBar.addBorderBlock = {
            [weak self] color, border, corner in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updatePhotoCanvasMirrorBorder(color: color, border: border, corner: corner)
            }
        }
        //
        toolContentBgView.addSubview(mirrorPatterBar)
        mirrorPatterBar.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
         
        mirrorPatterBar.clickPatternBlock = {
            [weak self] patternItem, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
                if isPro {
                    self.currentUnlockItemStr = patternItem.thumbName
                    self.showUnlockCoinAlertView()
                } else {
                    self.updatePhotoCanvasPatternItem(item: patternItem)
                }
            }
            
        }
        //
        //
        toolContentBgView.addSubview(mirrorStickerBar)
        mirrorStickerBar.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
         
        mirrorStickerBar.clickStickerBlock = {
            [weak self] stickerItem, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if isPro {
                    self.currentUnlockItemStr = stickerItem.thumbName
                    self.showUnlockCoinAlertView()
                } else {
                    self.addPhotoCanvasStickerItem(item: stickerItem)
                }
            }
        }
        
        
        //
        let topContentView = UIView()
        view.addSubview(topContentView)
        topContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(toolContentBgView.snp.top)
        }
        
        //
        
        var canvasWidth: CGFloat = UIScreen.width - 30 * 2
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 7.9 {
            canvasWidth = UIScreen.width - 50 * 2
        }
        
        
        topContentView.addSubview(canvasBgView)
        canvasBgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(canvasWidth)
        }
        canvasBgView.clipsToBounds = true
        //
        mirrorEditCanvas = LMyMirrorEditCanvasView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: canvasWidth), originImg: originalImg)
        canvasBgView.addSubview(mirrorEditCanvas)
        mirrorEditCanvas.clipsToBounds = true
        
        //
        
//        default status

        selectBtnTool(toolbtn: effectBtn, toolBar: mirrorEffectBar)
    }
    
    func selectBtnTool(toolbtn: UIButton, toolBar: UIView) {
        
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        
        for bar in self.toolContentBgView.subviews {
            bar.isHidden = true
        }
        toolBar.isHidden = false
        
        for btn in self.bottonToolBar.subviews  {
            if let btnmir = btn as? LMyMirrorEffectToolBtn {
                if btnmir == toolbtn {
                    btnmir.updateSeleStatus(isSelect: true)
                } else {
                    btnmir.updateSeleStatus(isSelect: false)
                }
            }
        }
    }
    
}

extension LMyMirrorEffectEditVC {
    func saveAction() {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        
        if let img = canvasBgView.screenshot {
            saveToAlbumPhotoAction(images: [img])
        }
    }
}

extension LMyMirrorEffectEditVC {
    func updatePhotoCanvasMirrorEffect(type: Int) {
        mirrorEditCanvas.updateCanvasImgVLayout(layoutType: type)
    }
    
    func updatePhotoCanvasMirrorBorder(color: UIColor?, border: Float, corner: Float) {
        mirrorEditCanvas.updateBgColor(bgColor: color, bgPatternImgName: nil)
        mirrorEditCanvas.updateBorder(borderPersent: border)
        mirrorEditCanvas.updateCorner(cornerPersent: corner)
    }
    
    func updatePhotoCanvasPatternItem(item: NEymEditToolItem) {
        mirrorEditCanvas.updateBgColor(bgColor: nil, bgPatternImgName: item.bigName)
    }
    
    func addPhotoCanvasStickerItem(item: NEymEditToolItem) {
        
        if let stickerImg = UIImage(named: item.bigName) {
            TMTouchAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImg, stickerItem: item, atView: canvasBgView)
        }
    }
    
}

extension LMyMirrorEffectEditVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
//                        if self.shouldCostCoin {
//                            LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
//                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo saved successful.")
    }
    
    func showDenideAlert() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                DispatchQueue.main.async {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
}



class LMyMirrorEffectToolBtn: UIButton {
    var iconStr: String
    var iconStr_sel: String
    var name: String
    var color_sel: String
    var clickblock: (()->Void)?
    let tiopIconImgV = UIImageView()
    let nameLabel = UILabel()
    
    init(frame: CGRect, iconStr: String, iconStr_sel: String, name: String, color_sel: String) {
        self.iconStr = iconStr
        self.iconStr_sel = iconStr_sel
        self.name = name
        self.color_sel = color_sel
        super.init(frame: frame)
        setupview()
        addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(sender: UIButton)  {
        updateSeleStatus(isSelect: !isSelected)
        clickblock?()
    }
    func updateSeleStatus(isSelect: Bool)  {
        isSelected = isSelect
        if isSelected {
            tiopIconImgV.isHighlighted = true
            nameLabel.isHighlighted = true
        } else {
            tiopIconImgV.isHighlighted = false
            nameLabel.isHighlighted = false
        }
    }
    
    func setupview() {
        tiopIconImgV.image = UIImage(named: iconStr)
        tiopIconImgV.highlightedImage = UIImage(named: iconStr_sel)
        addSubview(tiopIconImgV)
        tiopIconImgV.contentMode = .scaleAspectFit
        tiopIconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(26)
        }
        //
        nameLabel
            .text(name)
            .color(UIColor.white.withAlphaComponent(0.5))
            .fontName(12, "Verdana-Bold")
            .textAlignment(.center)
        nameLabel.highlightedTextColor = UIColor(hexString: color_sel)
        addSubview(nameLabel)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(4)
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
        }
        
    }
    
}


