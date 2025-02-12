//
//  OrderByDelegate.swift
//  About-You
//
//  Created by Sean Nkosi on 2025/02/12.
//


protocol OrderByDelegate: AnyObject {
    func didSelectOrder(by criterion: String)
}