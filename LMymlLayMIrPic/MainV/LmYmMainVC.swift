//
//  LmYmMainVC.swift
//  LMymlLayMIrPic
//
//  Created by JOJO on 2021/9/2.
//

import UIKit
import MessageUI
import Photos
import YPImagePicker


class LmYmMainVC: UIViewController, UINavigationControllerDelegate {
    
    // main
    let settingBtn = UIButton(type: .custom)
    let storeBtn = UIButton(type: .custom)
    let layoutBtn = UIButton(type: .custom)
    let effectBtn = UIButton(type: .custom)
    
    
    // setting
    let settingBgView = UIView()
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    let logoutBtn = UIButton(type: .custom)
    let userNameLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view
            .clipsToBounds()
            .backgroundColor(UIColor(hexString: "#674FFF")!)
        
        setupView()
        setupSettingView()
        
        //
        showLoginVC()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUserAccountStatus()
    }
    

}

extension LmYmMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        updateUserAccountStatus()
        UIView.animate(withDuration: 0.3) {
            self.settingBgView.alpha = 1
        }
    }
    @objc func storeBtnClick(sender: UIButton) {
        let storeVC = LmymStoreVC()
        self.present(storeVC, animated: true, completion: nil)
    }
    @objc func layoutBtnClick(sender: UIButton) {
        let vc = LmYmTypePreviewVC()
        vc.upVC = self
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func mirrorEffBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
}

extension LmYmMainVC {
    func setupView() {

        settingBtn
            .image(UIImage(named: "mainpage_menu"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(32)
            $0.width.height.equalTo(40)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        
        //

        storeBtn
            .image(UIImage(named: "mainpage_store"))
            .adhere(toSuperview: view)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-32)
            $0.width.height.equalTo(40)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        
        //
        let title1 = UILabel()
        title1
            .color(UIColor.white)
            .text("Create Now !")
            .fontName(32, "Inter-Black")
            .adhere(toSuperview: view)
        title1.snp.makeConstraints {
            $0.left.equalTo(32)
            $0.top.equalTo(settingBtn.snp.bottom).offset(40)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let title2 = UILabel()
        title2
            .color(UIColor.white)
            .text("Unique Layout & Fancy Mirror Effect")
            .fontName(16, "Inter-SemiBold")
            .adhere(toSuperview: view)
        title2.snp.makeConstraints {
            $0.left.equalTo(32)
            $0.top.equalTo(title1.snp.bottom).offset(10)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //

        layoutBtn
            .contentMode(.scaleAspectFit)
            .image(UIImage(named: "mainpage_layout"))
            .adhere(toSuperview: view)
        layoutBtn
            .snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(title2.snp.bottom).offset(16)
                $0.width.equalTo(750/2)
                $0.height.equalTo(408/2)
            }
        layoutBtn
            .addTarget(self, action: #selector(layoutBtnClick(sender:)), for: .touchUpInside)
        //
        
        effectBtn
            .contentMode(.scaleAspectFit)
            .image(UIImage(named: "mainpage_mirror"))
            .adhere(toSuperview: view)
        effectBtn
            .snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(layoutBtn.snp.bottom).offset(25)
                $0.width.equalTo(750/2)
                $0.height.equalTo(408/2)
            }
        effectBtn
            .addTarget(self, action: #selector(mirrorEffBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func settingBgBtnClick(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.settingBgView.alpha = 0
        }
    }
    
    func setupSettingView() {

        settingBgView.alpha = 0
        settingBgView
            .backgroundColor(UIColor.black.withAlphaComponent(0.25))
            .adhere(toSuperview: view)
        settingBgView.snp.makeConstraints {
            $0.bottom.top.left.right.equalToSuperview()
        }
        //
        let settingBgBtn = UIButton(type: .custom)
        settingBgBtn
            .adhere(toSuperview: settingBgView)
        settingBgBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        settingBgBtn
            .addTarget(self, action: #selector(settingBgBtnClick(sender:)), for: .touchUpInside)
        
        //

        let settingContentBgView = UIView()
        settingContentBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: settingBgView)
        settingContentBgView.layer.cornerRadius = 16
        settingContentBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(settingBtn.snp.bottom).offset(16)
            $0.left.equalTo(settingBtn.snp.left)
            $0.height.equalTo(244)
        }
        //
        loginBtn
            .backgroundColor(UIColor.clear)
            .title("Log in")
            .titleColor(UIColor.black)
            .font(16, "Inter-SemiBold")
            .adhere(toSuperview: settingContentBgView)
        
        loginBtn.snp.makeConstraints {
            $0.width.equalTo(145)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(settingContentBgView.snp.top).offset(22)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        //
        userNameLabel
            .fontName(16, "Inter-SemiBold")
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: view)
            .color(UIColor.white)
            .adhere(toSuperview: settingBgView)
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(loginBtn)
            $0.left.equalTo(settingBtn.snp.right).offset(10)
            $0.height.equalTo(35)
            $0.centerY.equalTo(settingBtn.snp.centerY)
        }
        //
        feedbackBtn
            .backgroundColor(UIColor.clear)
            .title("Feedback")
            .titleColor(UIColor.black)
            .font(16, "Inter-SemiBold")
            .adhere(toSuperview: settingContentBgView)
        
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(145)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginBtn.snp.bottom).offset(0)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        //
        privacyBtn
            .backgroundColor(UIColor.clear)
            .title("Privacy Policy")
            .titleColor(UIColor.black)
            .font(16, "Inter-SemiBold")
            .adhere(toSuperview: settingContentBgView)
        
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(145)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(0)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        termsBtn
            .backgroundColor(UIColor.clear)
            .title("Terms of use")
            .titleColor(UIColor.black)
            .font(16, "Inter-SemiBold")
            .adhere(toSuperview: settingContentBgView)
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(145)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(0)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
        //
        logoutBtn
            .backgroundColor(UIColor.clear)
            .title("Log Out")
            .titleColor(UIColor.black)
            .font(16, "Inter-SemiBold")
            .adhere(toSuperview: settingContentBgView)
        logoutBtn.snp.makeConstraints {
            $0.width.equalTo(145)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(loginBtn.snp.centerY)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
        
         
    }
     
    
}


extension LmYmMainVC {
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    @objc func logoutBtnClick(sender: UIButton) {
        LoginMNG.shared.logout()
        updateUserAccountStatus()
    }
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginMNG.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Sign in with Apple succeeded"
            userNameLabel.isHidden = false
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
            
        } else {
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
            
//            userNameLabel.text = "Sign in with Apple succeeded"
//            userNameLabel.isHidden = false
//            logoutBtn.isHidden = false
//            loginBtn.isHidden = true
        }
    }
}



extension LmYmMainVC: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}

extension LmYmMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.presentLimitedPhotoPickerController()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    } else if status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    }
                case .denied:
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
                    
                case .restricted:
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
                default: break
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let vc = LMyMirrorEffectEditVC(originalImg: image)
            self.navigationController?.pushViewController(vc)
        }

    }

    
    
}
