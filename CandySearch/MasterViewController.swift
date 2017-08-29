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

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!

    var detailViewController: DetailViewController? = nil
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self

        // 把搜索框放在表头中
        tableView.tableHeaderView = searchController.searchBar

        // 如果这个参数设置成false，点击搜索结果进入detail界面后，搜索栏不会消失，cancel搜索之后，主vc会有空白行，而且反复几次后，空白行越来越多。
        // 按照文档，这个属性设置为true之后，当前vc的view会显示，否则使用root view controller的。
        // 字面理解，可以理解为把当前vc作为显示上下文，否则会使用root view的。

        definesPresentationContext = true

        /* 该参数如果设置为true，搜索结果界面颜色为黑色，并且点击结果一个条目之后会取消搜索，无法显示detail界面
           和obscuresBackgroundDuringPresentation效果相同
           字面理解为：显示的期间把背景变暗。由于当前vc就是搜索结果，变暗后就无法交互了。
           如果使用了searchResultsController，则这个参数必须为true，因为使用了另外一个vc展示搜索结果，原始背景必须变暗。
        */
        searchController.dimsBackgroundDuringPresentation = false

        // 设置搜索范围栏
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self

        // Setup the search footer
        tableView.tableFooterView = searchFooter

        candies = [
            Candy(category: "Chocolate", name: "Chocolate Bar"),
            Candy(category: "Chocolate", name: "Chocolate Chip"),
            Candy(category: "Chocolate", name: "Dark Chocolate"),
            Candy(category: "Hard", name: "Lollipop"),
            Candy(category: "Hard", name: "Candy Cane"),
            Candy(category: "Hard", name: "Jaw Breaker"),
            Candy(category: "Other", name: "Caramel"),
            Candy(category: "Other", name: "Sour Chew"),
            Candy(category: "Other", name: "Gummi Bear"),
            Candy(category: "Other", name: "Candy Floss"),
            Candy(category: "Chocolate", name: "Chocolate Coin"),
            Candy(category: "Chocolate", name: "Chocolate Egg"),
            Candy(category: "Other", name: "Jelly Beans"),
            Candy(category: "Other", name: "Liquorice"),
            Candy(category: "Hard", name: "Toffee Apple")]

        // 如果当前vc有一个父vc是splitViewController，则返回这个vc
        if let splitViewController = splitViewController {
            // 获取这个split下全部的vc
            let controllers = splitViewController.viewControllers

            // 获取detail vc：先获取第二个vc，转为导航vc，再获取detail vc
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    // UIViewController对象的视图即将加入窗口时调用，在这里做一些UI方面的特效，如动画等
    override func viewWillAppear(_ animated: Bool) {
        // 如果是收起来的（既只有主vc，合二为一），取消table的选择，并伴随动画
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            // 显示footer，返回过滤后的数量
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        }

        // 没有查询或者过滤，不显示footer，返回全部数量
        searchFooter.setNotFiltering()
        return candies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let candy: Candy

        // 根据过滤状态，从不同的数组中返回数值
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }

        cell.textLabel!.text = candy.name
        cell.detailTextLabel!.text = candy.category
        return cell
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // storyboard定义的identifier，根据这个id区分不同的seque
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy: Candy

                // 根据不同的过滤状态从不同的数组中取值
                if isFiltering() {
                    candy = filteredCandies[indexPath.row]
                } else {
                    candy = candies[indexPath.row]
                }

                // 获取目标controller，先获取导航vc，再获取实际vc
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController

                // 设置目标controller的数据
                controller.detailCandy = candy

                // 设置导航栏的左按钮，并显示返回按钮
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Private instance methods

    // 按照scope和搜索条件搜索
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({ ( candy: Candy) -> Bool in
            // 首先按照scope过滤
            let doesCategoryMatch = (scope == "All") || (candy.category == scope)

            // 然后按照搜索关键字过滤
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })

        // table重新加载数据
        tableView.reloadData()
    }

    // 判断搜索栏的是否为空
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    // 判断是否进行了本地过滤（可以不输入搜索条件）
    func isFiltering() -> Bool {
        //  获取选择的过滤条件
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0

        // 搜索栏非空，或者中了过滤条件，返回true，既输入了搜索条件或者进行的本地过滤。
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    // 选择scope有改变，调用该方法重新搜索
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    // 当搜索栏的文本有变化，或者搜索栏变为first responder的时候调用该方法
    // 本协议的实际作用和文档描述不符，scope改变的时候并没有调用，如果要监控scope改变事件，请使用上面的协议和方法。
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
