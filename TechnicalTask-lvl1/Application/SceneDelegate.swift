//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private var connectivityObserver: ConnectivityObserver = NetworkStatusMonitor()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController, connectivityObserver: self.connectivityObserver)
        appCoordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        self.connectivityObserver.startObserving()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        self.connectivityObserver.stopObserving()
    }
}

