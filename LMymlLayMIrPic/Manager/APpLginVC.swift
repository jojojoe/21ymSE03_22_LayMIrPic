//
//  APpLginVC.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//


import Foundation
import FirebaseAuth
import FirebaseUI
import Firebase
import AuthenticationServices
import DeviceKit
import SnapKit
import SwifterSwift

class APLoginVC: FUIAuthPickerViewController, FUIAuthDelegate {
    
    let def_fontName = ""
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var buttons: [UIButton] = []
    var collection: UICollectionView!
    let bgImageView = UIImageView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findButtons(subView: self.view)
        setupView()
        
    }
    
    func findButtons(subView: UIView) {
        
        if subView.isKind(of: UIButton.classForCoder()) {
            if let button = subView as? UIButton {
                buttons.append(button)
            }
            return
        } else {
            subView.backgroundColor = .clear
        }
        
        for sv in subView.subviews {
            findButtons(subView: sv)
        }
    }
    
    @objc func closebuttonClick(button: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    @objc func appleButtonClick(button: UIButton) {
        let requestID = ASAuthorizationAppleIDProvider().createRequest()
                // 这里请求了用户的姓名和email
                requestID.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [requestID])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
    }
    
    func customFont(fontName: String, size: CGFloat) -> UIFont {
        let stringArray: Array = fontName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: stringArray[0], ofType: stringArray[1])
        let fontData = NSData.init(contentsOfFile: path ?? "")
        
        let fontdataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
        let fontRef = CGFont.init(fontdataProvider!)!
        
        var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
        CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
        
        let fontName: String =  fontRef.postScriptName as String? ?? ""
        let font = UIFont(name: fontName, size: size)
        
        fontError?.release()
        
        return font ?? UIFont(name: def_fontName, size: size)!
    }
    
    @objc func buttonClick(button: UIButton) {
        
        switch button.tag {
            
        case 1001:
            let url = URL(string: PrivacyPolicyURLStr)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
            
        case 1002:
            let url = URL(string: TermsofuseURLStr)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break

        default:
            break
        }
    }
 
}

extension APLoginVC {
    func setupView() {
        view.backgroundColor = .white
        let topBgImgV = UIImageView(image: UIImage(named: "bg"))
        topBgImgV.contentMode = .scaleAspectFill
        view.addSubview(topBgImgV)
        topBgImgV.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.top.right.equalToSuperview()
        }
//        let bgOvermaskView = UIView()
//        view.addSubview(bgOvermaskView)
        
        //
        let closebutton = UIButton()
        closebutton.alpha = 1
        closebutton.setImage(UIImage(named: "popup_close_white"), for: .normal)
        closebutton.addTarget(self, action: #selector(closebuttonClick(button:)), for: .touchUpInside)
        view.addSubview(closebutton)
        closebutton.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.left.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        //
        
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        
        let topInfoLabel = UILabel()
        topInfoLabel.font = UIFont(name: "Inter-SemiBold", size: 24)
        topInfoLabel.textColor = .white
        topInfoLabel.textAlignment = .center
        topInfoLabel.adjustsFontSizeToFitWidth = true
        topInfoLabel.numberOfLines = 2
        topInfoLabel.text = AppName
        view.addSubview(topInfoLabel)
        topInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        let userInfoImgV = UIImageView(image: UIImage(named: "signin_logo"))
        view.addSubview(userInfoImgV)
        userInfoImgV.contentMode = .scaleAspectFit
        userInfoImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(82)
            $0.height.equalTo(82)
            $0.bottom.equalTo(topInfoLabel.snp.top).offset(-16)
             
        }
        
        //
        let googleButton = buttons[0]
        googleButton.layer.cornerRadius = 12
        googleButton.layer.masksToBounds = true
        googleButton.setTitle("  Sign in with Google   ", for: .normal)
        googleButton.setTitleColor(.black, for: .normal)
        googleButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 18)
        googleButton.frame = CGRect.zero
        googleButton.backgroundColor = .white
        googleButton.contentHorizontalAlignment = .center
        bgBottomView.addSubview(googleButton)
        googleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
        }
        //
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        appleButton.layer.cornerRadius = 12
        appleButton.layer.masksToBounds = true
        appleButton.addTarget(self, action: #selector(appleButtonClick(button:)), for: .touchUpInside)
        bgBottomView.addSubview(appleButton)
        appleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(googleButton.snp.top).offset(-20)
        }
        
        
        // Do any additional setup after loading the view.
        
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.centerX.equalTo(self.view)
        }
        
        let ppButton = UIButton()
        let str = NSMutableAttributedString(string: "Privacy Policy &")
        let strRange = NSRange.init(location: 0, length: str.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: strRange)
        ppButton.setAttributedTitle(str, for: UIControl.State.normal)
        ppButton.contentHorizontalAlignment = .right
        ppButton.tag = 1001
        ppButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(ppButton)
        ppButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.left.equalTo(0)
        }
        
        let tou = UIButton()
        let toustr = NSMutableAttributedString(string: " Terms of Use")
        let toustrRange = NSRange.init(location: 0, length: toustr.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let tounumber = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        toustr.addAttributes([NSAttributedString.Key.underlineStyle: tounumber,
                              NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: toustrRange)
        tou.setAttributedTitle(toustr, for: UIControl.State.normal)
        tou.contentHorizontalAlignment = .left
        tou.tag = 1002
        tou.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(tou)
        tou.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.right.equalTo(-2)
        }
        
        //
//        let topTitleLabe = UILabel()
//        topTitleLabe
//            .fontName(40, "Copperplate-Bold")
//            .adjustsFontSizeToFitWidth()
//            .color(UIColor(hexString: "#0F0F0F")!)
//            .text("GRID POSTS EDITOR")
//            .adhere(toSuperview: view)
//        
//        topTitleLabe.snp.makeConstraints {
//            $0.left.equalTo(25)
//            $0.top.equalTo(closebutton.snp.bottom).offset(10)
//            $0.right.equalTo(-35)
//            $0.height.greaterThanOrEqualTo(40)
//        }
//        //
//        let topTitleLabe2 = UILabel()
//        topTitleLabe2
//            .fontName(28, "Copperplate-Bold")
//            .color(UIColor(hexString: "#0F0F0F")!)
//            .numberOfLines(0)
//            .text("Make Amazing Instagram Grid Posts")
//            .adhere(toSuperview: view)
//        
//        topTitleLabe2.snp.makeConstraints {
//            $0.left.equalTo(topTitleLabe)
//            $0.top.equalTo(topTitleLabe.snp.bottom).offset(15)
//            $0.width.equalTo(240)
//            $0.height.greaterThanOrEqualTo(20)
//        }
//        //
//        let topTitleLabe3 = UILabel()
//        topTitleLabe3
//            .fontName(14, "Copperplate-Light")
//            .color(UIColor(hexString: "#0F0F0F")!.withAlphaComponent(0.5))
//            .numberOfLines(0)
//            .textAlignment(.left)
//            .text("")
//            .adhere(toSuperview: view)
//        
//        topTitleLabe3.snp.makeConstraints {
//            $0.left.equalTo(topTitleLabe)
//            $0.top.equalTo(topTitleLabe2.snp.bottom).offset(10)
//            $0.width.equalTo(220)
//            $0.height.greaterThanOrEqualTo(20)
//        }
        //
        
        
//        bgOvermaskView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        bgOvermaskView.layer.borderWidth = 1
//        bgOvermaskView.layer.borderColor = UIColor.white.cgColor
//        bgOvermaskView.layer.cornerRadius = 20
//        bgOvermaskView.snp.makeConstraints {
//            $0.left.equalTo(googleButton.snp.left).offset(-25)
//            $0.right.equalTo(googleButton.snp.right).offset(25)
//            $0.top.equalTo(appleButton.snp.top).offset(-200)
//            $0.bottom.equalTo(ppButton.snp.bottom).offset(10)
//        }
        
    }
}

extension APLoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 请求完成，但是有错误
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 请求完成， 用户通过验证
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 拿到用户的验证信息，这里可以跟自己服务器所存储的信息进行校验，比如用户名是否存在等。
            //                let detailVC = DetailVC(cred: credential)
            //                self.present(detailVC, animated: true, completion: nil)
            debugPrint("$$$ credential = \(credential)")
            print(credential)
            LoginMNG.saveAppleUserIDAndUserName(userID: credential.user, userName: credential.email ?? "")
            self.dismiss(animated: true) {
            }
            
        } else {
            
        }
    }
}

extension APLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }
}

  

 
