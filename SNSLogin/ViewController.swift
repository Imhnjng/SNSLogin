//
//  ViewController.swift
//  SNSLogin
//
//  Created by IMHYEONJEONG on 8/19/24.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class ViewController: UIViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
  
    @IBAction func kakaoLoginButton(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        print("클릭")
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    self.nicknameLabel.text = "로그인 완료"
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

