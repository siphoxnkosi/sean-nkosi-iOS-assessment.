//
//  CoreDataManaging.swift
//  About-You
//
//  Created by Sean Nkosi on 2025/02/12.
//

import Foundation

protocol CoreDataManaging {
    func saveEngineerImage(name: String, imageData: Data)
    func fetchEngineerImage(name: String) -> Data?
}
