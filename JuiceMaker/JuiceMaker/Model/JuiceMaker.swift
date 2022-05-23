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
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return fruitRepository.readStock(of: fruit)
    }
    
    func makeJuice(_ juice: Juice) -> Observable<Juice?> {
        let canMake = BehaviorSubject<Bool>(value: false)
        
        juice.recipe.forEach { (fruit, count) in
            fruitRepository.readStock(of: fruit)
                .map{ $0 >= count }
                .subscribe(onNext: { canMake.onNext($0) })
                .disposed(by: diposeBag)
        }

        let juiceObservable = canMake
            .scan(into: []) { $0.append($1) }
            .map{ $0.contains(true) ? true : false }
            .map{ $0 == true ? juice : nil }
            .do(onNext: { _ in
                self.takeFruitStock(for: juice)
            })
        
        return juiceObservable
    }
    
    func takeFruitStock(for juice: Juice) {
        juice.recipe.forEach { (fruit, count) in
            fruitRepository.decreasStock(of: fruit, count: count)
        }
    }
}
