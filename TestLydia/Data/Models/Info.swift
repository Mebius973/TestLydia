//
//  Info.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//


struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

extension Info {
    func asEntity() -> PaginationInfoEntitiy {
        return PaginationInfoEntitiy(
            seed: self.seed,
            results: self.results,
            page: self.page
        )
    }
}
