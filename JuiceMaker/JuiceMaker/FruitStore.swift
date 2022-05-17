//
//  FruitStore.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation

class FruitStore {
    static let shared = FruitStore()
    var fruitStock: [Fruit : Int]
    private let initialStock = 10
    
    init() {
        let fruit = Fruit.allCases
        let fruitStocks = Array(repeating: initialStock, count: fruit.count)
        
        self.fruitStock = Dictionary(uniqueKeysWithValues: zip(fruit, fruitStocks))
    }
    
    func increaseStock(of fruit: Fruit, count: Int) {
        guard let currentStock = fruitStock[fruit] else {
            return
        }
        fruitStock[fruit] = currentStock + count
    }
    
    func decreasStock(of fruit: Fruit, count: Int) {
        guard let currentStock = fruitStock[fruit], currentStock > .zero else {
            return
        }
        fruitStock[fruit] = currentStock - count
    }
}
