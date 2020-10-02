//
//  CategoryService.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import Foundation


class CategoryService {
    static let shared = CategoryService()
    let categories: [Category]
    
    private init() {
        let categoriesUrl = Bundle.main.url(forResource: "categories", withExtension: "json")!
        let data = try! Data(contentsOf: categoriesUrl)
        let decoder = JSONDecoder()
        categories = try! decoder.decode([Category].self, from: data)
        
    }
}
