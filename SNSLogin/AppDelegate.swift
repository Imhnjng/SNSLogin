//
//  AppDelegate.swift
//  SNSLogin
//
//  Created by IMHYEONJEONG on 8/19/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import GoogleSignIn
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 카카오 로그인 셋팅
        KakaoSDK.initSDK(appKey: "dbe82ca8e4341736f7310a50617b414a")
//        GIDSignIn.sharedInstance.clientID = "485271827723-2nim5arjg4c058v0irutkgnnav2j7kpn.apps.googleusercontent.com"
        
        // 네이버 로그인 셋팅
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        //네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = true
        //SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        //인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // kakaoTalk 로그인
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        //Goolgle 로그인
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        
        return false
    }
    
    
}

