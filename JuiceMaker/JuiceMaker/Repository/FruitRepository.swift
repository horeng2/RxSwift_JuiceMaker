//
//  FruitStore.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift
import RxOptional

class FruitRepository {
    static let shared = FruitRepository()
    private(set) var fruitStock = [Fruit : Int]()
    private let initialStock = 10
    
    init() {
        Fruit.allCases.forEach { fruit in
            fruitStock.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return Observable.just(self.fruitStock[fruit])
                .filterNil()
    }
    
    func modifyStock(of fruit: Fruit, to newQuantity: Int) -> PublishSubject<Bool> {
        let modifySuccess = PublishSubject<Bool>()
        guard let currentStock = fruitStock[fruit], currentStock > .zero else {
            modifySuccess.onNext(false)
            return modifySuccess
        }
        self.fruitStock.updateValue(newQuantity, forKey: fruit)
        modifySuccess.onNext(true)
        return modifySuccess
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        guard let currentStock = fruitStock[fruit], currentStock > .zero else {
            return
        }
        self.fruitStock.updateValue(currentStock - count, forKey: fruit)
    }
}
