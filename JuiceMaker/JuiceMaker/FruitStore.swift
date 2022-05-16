//
//  FruitStore.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation

struct FruitStore {
    private var fruitStock: [Fruit : Int]
    private let initialStock = 10
    
    init() {
        let fruit = Fruit.allCases
        let fruitStocks = Array(repeating: 10, count: fruit.count)
        
        self.fruitStock = Dictionary(uniqueKeysWithValues: zip(fruit, fruitStocks))
    }
}



