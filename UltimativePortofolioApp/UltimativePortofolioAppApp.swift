//
//  UltimativePortofolioAppApp.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 22.10.20.
//

import SwiftUI

@main
struct UltimativePortofolioAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var unlockManager: UnlockManager
    @StateObject var dataController: DataController
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                // Automatically save when we detect that we are
                // no longer the foreground app. Use this rather than
                // scene phase so we can port to macOS, where scene
                // phase won't detect our app losing focus.
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
    
    
}


class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    @Environment(\.openURL) var openURL
    
    func windowScene(_ windowScene: UIWindowScene,performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let url = URL(string: shortcutItem.type) else {
            completionHandler(false)
            return
        }

        openURL(url, completion: completionHandler)
    }
    
    func scene(_ scene: UIScene,willConnectTo session: UISceneSession,options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            guard let url = URL(string: shortcutItem.type) else { return }
            openURL(url)
        }
    }
    
}
