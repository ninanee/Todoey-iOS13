//
//  Category.swift
//  Todoey
//
//  Created by Yun Ni on 2024-05-30.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
