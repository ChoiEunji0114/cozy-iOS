//
//  DetailReviewService.swift
//  Cozy
//
//  Created by IJ . on 2020/07/16.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Alamofire

struct DetailReviewService {
    static let shared = DetailReviewService()
    
    let header: HTTPHeaders = [
        "Content-Type" : "application/json",
        "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoxLCJpYXQiOjE1OTQ1NDM5NDIsImV4cCI6My42MzYzNjM2MzYzNjM3OTU0ZSsyMiwiaXNzIjoib3VyLXNvcHQifQ.gIsHK5BvP0CCvz7g2GgGVvREJyvIjaybQTk93xGR5r4"
    ]
    
    
    func getReviewData(bookstoreIndex: Int ,completion: @escaping (NetworkResult<Any>) -> Void){
        
        let URL  = APIConstants.reviewURL + "\(bookstoreIndex)"
        let dataRequest = Alamofire.request(URL, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.result.value else { return }
                
                let networkResult = self.judge(by: statusCode, value)
                completion(networkResult)
                
                print("success")
            case .failure :
                completion(.networkFail)
                print("failure")
            }
        }
    }
    
    // 통신 분기 처리
    private func judge(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isData(by: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    // json decoding
    private func isData(by data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(DetailReviewModel.self, from: data) else { return .pathErr }
        //print(decodedData)
        
        if decodedData.message == "작성된 후기가 없습니다." {
            return .success(false)
        }
        
        guard let reviewData = decodedData.data else { print("디코딩 데이터 에서 Error")
            return .requestErr(decodedData.message) }
        //print(reviewData)
        return .success(reviewData)
    }
    
}
