//
//  CreationModel.swift
//  Social-Reality
//
//  Created by Nick Crews on 3/18/21.
//

import Foundation
import Firebase
import CodableFirebase

struct CreationModel: Codable {
    
    public let id: String
    public var title: String
    public var description: String?
    public var lastViewed: String?
    public var accessibility: CreationAccessibility
    public var status: String
    public var date: String?
    public var userID: String?
    public var userName: String?
    public var userImage: String?
    
}