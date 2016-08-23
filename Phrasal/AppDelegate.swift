import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver {

  var window: UIWindow?

  var templates = [Template]()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions:  [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

    SKPaymentQueue.default().add(self)

    let d = storiesDirectory()
    let fm = FileManager.default
    
    do {
      try fm.createDirectory(at: d, withIntermediateDirectories: true,
                       attributes: nil)
    } catch let error as NSError {
      print("couldn't create directory \(d): \(error.domain)")
    }

    loadTemplates()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
  {
  }

  func loadTemplates() {
    let bundle = Bundle.main

    if let urls = bundle.urls(forResourcesWithExtension: "tmpl",
                              subdirectory: "Templates") {
      for u in urls {
        templates.append(Template(contentsOf: u))
      }
    }
  }

}

