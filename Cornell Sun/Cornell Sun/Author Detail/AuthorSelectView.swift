//
//  AuthorSelectView.swift
//  
//
//  Created by Cameron Hamidi on 3/26/21.
//

import SnapKit
import UIKit

class AuthorSelectView: UIView {

    let cellHeight: CGFloat = 41
    let cellIdentifier = "cellIdentifier"
    let handleBottomOffset: CGFloat = -19
    let handleHeight: CGFloat = 7
    let handleWidth: CGFloat = 65
    let tableViewBottomOffset: CGFloat = 33
    let tableViewSideOffset: CGFloat = 41
    let tableViewTopOffset: CGFloat = 18

    let handle = UIView()
    let tableView = UITableView()

    var authorNames: [String] = []
    var selectedIndex = 0

    var delegate: AuthorSelectViewDelegate?

    init(authorNames: [String]) {
        super.init(frame: .zero)

        backgroundColor = .white

        self.authorNames = authorNames

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(tableViewTopOffset)
            make.bottom.equalToSuperview().offset(tableViewBottomOffset)
            make.leading.equalToSuperview().offset(tableViewSideOffset)
            make.trailing.equalToSuperview().offset(-tableViewSideOffset)
        }

        handle.backgroundColor = .dividerGray
        handle.layer.cornerRadius = handleHeight / 2.0
        addSubview(handle)
        handle.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(handleBottomOffset)
            make.height.equalTo(handleHeight)
            make.width.equalTo(handleWidth)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getHeight() -> CGFloat {
        return tableViewTopOffset + cellHeight * CGFloat(authorNames.count) + tableViewBottomOffset
    }

}

extension AuthorSelectView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        cell.textLabel?.text = authorNames[indexPath.row]
        cell.textLabel?.font = .avenir18
        cell.textLabel?.textColor = selectedIndex == indexPath.row
            ? .black
            : .authorSelectGray
        cell.textLabel?.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        cell.selectionStyle = .none

        return cell
    }

}

extension AuthorSelectView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCell = tableView.cellForRow(at: indexPath)!
        newCell.textLabel?.textColor = .black

        let oldCell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))!
        oldCell.textLabel?.textColor = .authorSelectGray

        selectedIndex = indexPath.row
        delegate?.authorIndexChanged(to: selectedIndex)
    }

}


protocol AuthorSelectViewDelegate {

    func authorIndexChanged(to index: Int)

}
