//
//  FavoritesDiffableDataSource.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/18/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class FavoritesDiffableDataSource: UITableViewDiffableDataSource<FavoriteSection, JsonImport> {
    // MARK: header/footer titles support
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let ii = self.itemIdentifier(for: IndexPath.init(item: 0, section: section))
        return ii?.entity.name
    }
}
