Initialize a Clean Swift Project:

1. Delete SceneDelegate
2. Info.plist: 
	- Delete: "Application Scene Manifest"
	- Edit: "Main storyboard file base name" - set value to your inital view controller name
3. AppDelegate.swift:
	- Delete function:
		- application(... configurationForConnecting)
		- application(... didDiscardSceneSessions)
	- Add line: `var window: UIWindow?`
	- Add codes inside `application(... didFinishLaunchingWithOptions: ...){}`:
		`let request = {XXXBuilder}.BuildRequest()
        let vc = {XXXBuilder}.createScene(request: request)
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()`
4. Go to your inital view controller storyboard, tick "iIs Initial View Controller"