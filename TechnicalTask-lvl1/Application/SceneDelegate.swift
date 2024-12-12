//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let apiURL = "https://jsonplaceholder.typicode.com/users"
    private let dataModelName = "UserDataModel"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let requester = UsersRequester(apiURL)
        let dataStorage = CoreDataStack(name: dataModelName)
        
        let dataService = UsersDataServiceImplementation(requester: requester, dataStorage: dataStorage)
        let usersViewModel = UsersViewModel(dataService: dataService)
        
        window?.rootViewController = UserViewController(usersViewModel: usersViewModel)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
}

