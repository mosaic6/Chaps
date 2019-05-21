//
//  AppDelegate.swift
//  Chaps
//
//  Created by Joshua Walsh on 4/28/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    IQKeyboardManager.shared.enable = true

    FirebaseApp.configure()

		Messaging.messaging().delegate = self

		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self

			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}

		application.registerForRemoteNotifications()

    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(UIBackgroundFetchResult.noData)
      return
    }

    // This notification is not auth related, developer should handle it.
  }

}

// MARK: Messaging

extension AppDelegate: MessagingDelegate {

	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		print("Firebase registration token: \(fcmToken)")

		let dataDict:[String: String] = ["token": fcmToken]
		NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
		// TODO: If necessary send token to application server.
		// Note: This callback is fired at each app startup and whenever a new token is generated.
	}

	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print("Received data message: \(remoteMessage.appData)")
	}

}
