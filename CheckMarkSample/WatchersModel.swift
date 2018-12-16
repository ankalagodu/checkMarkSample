//
//  WatchersModel.swift
//  CheckMarkSample
//
//  Created by Koushik on 30/07/18.
//  Copyright © 2018 Wolken Software Pvt Ltd. All rights reserved.
//

import Foundation

struct WatcherData {
    var item: JSON
    var isSelected: Bool
    
    init(item: JSON, isSelected: Bool = false) {
        self.item = item
        self.isSelected = isSelected
    }
}
