import Foundation
import Sniffer

protocol AppInterface {
    func start(withWindow window: UIWindow)
}

class App {
    
    unowned let application: UIApplication
    unowned let window: UIWindow
    let environment: Environment
    let rootRouter: RootRouterInterface
    
    init(application: UIApplication = UIApplication.shared,
         window: UIWindow,
         rootBuilder: RootBuilderInterface = RootBuilder(),
         environment: Environment = Environment()) {
    
        self.application = application
        self.window = window
        self.rootRouter = rootBuilder.build(withWindow: window)
        self.environment = environment
    }
    
    func start() {
        
        if environment.isRunningUITests {
            application.keyWindow?.layer.speed = 100
        }
        
        if environment.enableRequestLogs {
            Sniffer.register()
        }
        
        rootRouter.start()
    }
}
