//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
//    private let apiURL = "https://jsonplaceholder.typicode.com/users"
//    private let dataModelName = "UserDataModel"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}

