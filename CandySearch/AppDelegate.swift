/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController

        // 获取第二个导航栏，既detail界面的导航栏
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as! UINavigationController

        // 添加detail界面左上角的展开按钮，点击后全屏显示detail界面
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

        // 设置splitview的delegate为自己
        splitViewController.delegate = self

        // 设置全局样式
        UISearchBar.appearance().barTintColor = .candyGreen
        UISearchBar.appearance().tintColor = .white

        // 设置UITextField被包含在container类中的样式，主要影响的是搜索框中的输入光标，否则他会是白色，无法辨识
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .candyGreen

        return true
    }

    // MARK: - Split view
    // 调整主vc，以适应次vc的收起状态
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        // 判断次vc是否是导航vc
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {
            return false
        }

        // 次vc是否是DetailVC
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else {
            return false
        }

        // 如果detailcandy为空，则返回
        if topAsDetailController.detailCandy == nil {
            // 直接返回true，意味着已经处理detail收起事件，什么也没做；次vc会被忽略。
            return true
        }

        return false
    }
}

