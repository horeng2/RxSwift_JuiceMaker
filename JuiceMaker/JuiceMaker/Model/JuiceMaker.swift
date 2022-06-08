//
//  JuiceMaker.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/23.
//

import Foundation
import RxSwift

struct JuiceMaker {
    private let fruitRepository = FruitRepository.shared
    private let diposeBag = DisposeBag()
    
    func fetchFruitStock() -> Observable<[Fruit : Int]> {
        return self.fruitRepository.readStock()
    }
    
    func juiceMakingResult(_ juice: Juice) -> Observable<Bool> {
        let juiceObservable = self.haveFruitStock(to: juice)
            .do(onNext: { canMakeJuice in
                guard canMakeJuice else {
                    return
                }
                self.takeFruitStock(for: juice)
            })
        
        return juiceObservable
    }
    
    private func haveFruitStock(to juice: Juice) -> Observable<Bool> {
        return self.fruitRepository.readStock()
            .map{ stocks in
                juice.recipe.map{ fruit, count in
                    stocks[fruit, default: 0] >= count
                }
                .contains(false) ? false : true
            }
    }
    
    private func takeFruitStock(for juice: Juice) {
        juice.recipe.forEach { (fruit, count) in
            self.fruitRepository.decreaseStock(of: fruit, count: count)
        }
    }
    
    func updateFruitStock(for fruit: Fruit, newQuantity: Int) {
        self.fruitRepository.updateStock(of: fruit, to: newQuantity)
    }
}
