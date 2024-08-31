//
//  ViewController.swift
//  NewsApp
//
//  Created by Aman Agrwal on 07/09/22.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

	private let tableView: UITableView = {
		let table = UITableView()
		table.register(customTableViewCell.self, forCellReuseIdentifier:customTableViewCell.identifier)
		return table
	}()
	
	private var viewModels = [customTableViewCellViewModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.title = "News"
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		view.backgroundColor = .systemBackground
		ApiCaller.shared.getTopStories { [weak self] result in
			switch result{
			case .success(let articles):
				self?.viewModels = articles.compactMap({
					customTableViewCellViewModel(title: $0.title, subTitle: $0.description ?? "No Description", imageUrl: URL(string: $0.urlToImage ?? ""))
				})
				
				DispatchQueue.main.async {
					self?.tableView.reloadData()
				}
				
			case .failure(let error):
				print(error)
			}
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:customTableViewCell.identifier , for: indexPath) as? customTableViewCell else{
			fatalError()
		}
		cell.configure(with: viewModels[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}


}

