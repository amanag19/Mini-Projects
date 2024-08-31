//
//  ApiCaller.swift
//  NewsApp
//
//  Created by Aman Agrwal on 08/09/22.
//

import Foundation

final class ApiCaller
{
	static let shared = ApiCaller()
	struct Constants{
		static let topHeadlinesUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=44f57cb810f7469c8a0badadca4f4183")
	}
	
	private init(){}
	
	public func getTopStories(completion:@escaping (Result<[Article] , Error>) -> Void)
	{
		guard let url = Constants.topHeadlinesUrl else{
			return
		}
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				completion(.failure(error))
			}
			else if let data = data {
				do{
					let result = try JSONDecoder().decode(ApiResponse.self , from: data)
					print("Articles : \(result.articles.count)")
					completion(.success(result.articles))
				}
				catch{
					completion(.failure(error))
				}
			}
		}
		task.resume()
	}
}

//Models

struct ApiResponse:Codable
{
	let articles :[Article]
	
}

struct Article:Codable
{
	let source:Source
	let title:String
	let description:String?
	let url:String
	let urlToImage: String?
//	let publishedAt:String
}

struct Source:Codable
{
	let name:String
	
}
