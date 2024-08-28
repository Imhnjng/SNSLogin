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
import GoogleSignIn
import NaverThirdPartyLogin

enum Logintype {
    case none
    case kakaotalk
    case google
    case naver
}

class ViewController: UIViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    var currentLoginType: Logintype = .none
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        nicknameLabel.textColor = .black
        naverLoginInstance?.delegate = self
    }
    
    func setUserNickname() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            } else {
                print("nickname: \(user?.kakaoAccount?.profile?.nickname ?? "no nickname")")
                self.nicknameLabel.text = " \(user?.kakaoAccount?.profile?.nickname ?? "no nickname")"
            }
        }
    }
    
    @IBAction func kakaoLoginButton(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        print("로그인 클릭")
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    //                    self.nicknameLabel.text = "로그인 완료"
                    self.setUserNickname()
                    self.currentLoginType = .kakaotalk
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        switch currentLoginType {
        case .none:
            print("로그인을 하지 않았습니다")
        case .kakaotalk:
            UserApi.shared.logout { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("kakao logout success")
                    self.handleLogoutSuccess()
                }
            }
        case .google:
            GIDSignIn.sharedInstance.signOut()
            self.handleLogoutSuccess()
            
        case .naver:
            print("네이버 로그아웃")
            self.handleLogoutSuccess()
        }
    }
    
    @IBAction func googleLoginButton(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print(error)
            }
            else {
                print("구글 로그인 성공")
                self.nicknameLabel.text = "구글 로그인"
                self.currentLoginType = .google
            }
        }
    }
    
    @IBAction func naverLoginButton(_ sender: Any) {
        naverLoginInstance?.requestThirdPartyLogin()
        self.nicknameLabel.text = "네이버 로그인 성공"
        self.currentLoginType = .naver
    }
    
    func handleLogoutSuccess() {
        print("Logout success")
        self.nicknameLabel.text = "Nickname"
        currentLoginType = .none  // 로그인 상태 초기화
    }
    
}

extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성공
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.nicknameLabel.text = "네이버 로그인 성공"
    }
    
    //refresh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        naverLoginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        self.naverLoginInstance?.requestDeleteToken()
        print("error \(error.localizedDescription)")
    }
}

