//
//  GTListCell.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import UIKit
class GTListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCellWith(_ todoItem:GTListDataModelProtocol) {
        bindDataWith(todoItem) // Binding Cell data
    }
}

//MARK:- Cell configuration methods
extension GTListCell {
    // Binding cell content
    private func bindDataWith(_ todoItem:GTListDataModelProtocol) {
        lblName.text = todoItem.name ?? GTConstants.fieldNames.empty
    }
}
