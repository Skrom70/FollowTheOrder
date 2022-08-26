//
//  FortunaService.swift
//  FollowTheOrder
//
//  Created by Viacheslav Tolstopianteko on 26.08.2022.
//

import Foundation


class FortunaService {
	
	func getData(complete: @escaping (String?) -> Void) {
		let url = URL(string: "http://yerkee.com/api/fortune")
		
		URLSession.shared.dataTask(with: url!) { data, response, error in
			if let data = data {
				if let json = try? JSONDecoder().decode(Fortuna.self, from: data) {
					complete(json.fortune)
				} else {
					print("Invalid Response")
				}
			} else if let error = error {
				print("HTTP Request Failed \(error)")
			}
		}.resume()
	}
}


struct Fortuna: Decodable {
	let fortune: String
}
