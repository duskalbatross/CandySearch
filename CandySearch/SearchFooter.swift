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

// 作为table的搜索结果页脚
class SearchFooter: UIView {

    let label: UILabel = UILabel()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func configureView() {
        backgroundColor = UIColor.candyGreen
        alpha = 0.0 // 初始设置完全隐藏

        // Configure label
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }

    // 绘制
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }

    //MARK: - Animation

    // 隐藏
    fileprivate func hideFooter() {
        UIView.animate(withDuration: 0.7) { [unowned self] in
            self.alpha = 0.0
        }
    }

    // 显示
    fileprivate func showFooter() {
        UIView.animate(withDuration: 0.7) { [unowned self] in
            self.alpha = 1.0
        }
    }
}

extension SearchFooter {
    //MARK: - Public API

    // 没有过滤的时候，文本设置成空，并隐藏
    public func setNotFiltering() {
        label.text = ""
        hideFooter()
    }

    // 设置过滤并显示
    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            // 如果和总数相同，实际上是全部显示，不显示footer
            setNotFiltering()
        } else if (filteredItemCount == 0) {
            // 如果为0，则显示没有查询结果
            label.text = "No items match your query"
            showFooter()
        } else {
            // 其它情况显示特定格式："12/15"
            label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }

}
