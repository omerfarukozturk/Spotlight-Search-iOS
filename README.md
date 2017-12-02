# Spotlight Search

Core Spotlight is a popular feature in iOS 9.0 that lets your app contents to appear on iOS Spotlight Search result, so that users can find content of your apps alongside other applications.

Core Spotlight is integrated in this sapmle app via a manager file named SpotlightManager.


### Integration Steps

Add **SpotlightManager.swift** file to your project.

Add this delegate function in **AppDelegate.swift** to handle Spotlight Item tap action. 

```
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

    // Called when Spotlight item tapped. Do anything with specified data.
    SpotlightManager.sharedInstance.spotlightItemTapAction(userActivity)
        
  return true
}
```

There is a sample function in SpotlightManager that you can simply call. In this project it is called on application launch in **didFinishLaunchingWithOptions** delegate in AppDelegate.swift.

```
SpotlightManager.sharedInstance.reloadInitialItems()
```

When user tap to an item in Spotlight Search results, **spotlightItemTapAction** function is called. You can edit this function to do any action you want.

That is all.

![Sample Gif](appvideo_sample2.gif)

