//
//  Post.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import Foundation
import ParseSwift


struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var description: String?
    var user: User?
    var imageFile: ParseFile?
    var longitude: Double?
    var latitude: Double?
}


