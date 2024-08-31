//
//  customTableViewCell.swift
//  NewsApp
//
//  Created by Aman Agrwal on 10/09/22.
//

import UIKit

class customTableViewCellViewModel
{
	let title : String
	let subTitle : String
	let imageUrl : URL?
	var imageData : Data? = nil
	
	init(title : String ,subTitle : String ,imageUrl : URL?) {
		self.title = title
		self.subTitle = subTitle
		self.imageUrl = imageUrl
	}
}

class customTableViewCell: UITableViewCell {
	
	static let identifier = "customTableViewCell"
	
	private let newsTitleLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 25, weight: .medium)
		label.numberOfLines = 0
		return label
	}()
	
	private let newsSubTitleLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .regular)
		label.numberOfLines = 0
		return label
	}()
	
	private let newsImageView : UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .red
		view.contentMode = .scaleAspectFill
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(newsTitleLabel)
		contentView.addSubview(newsSubTitleLabel)
		contentView.addSubview(newsImageView)
	}
	
	required init(coder : NSCoder) {
		fatalError()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		newsTitleLabel.frame = CGRect(x: 5, y: 0, width: contentView.frame.self.width - 120, height: 70)
		
		newsSubTitleLabel.frame = CGRect(x: 10, y: newsTitleLabel.frame.size.height, width: contentView.frame.self.width - 200, height: contentView.frame.size.height/2)
		
		newsImageView.frame = CGRect(x:contentView.frame.size.width - 200, y: 5, width: 190, height: contentView.frame.size.height - 10)
		
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func configure(with viewModel:customTableViewCellViewModel)
	{
		newsTitleLabel.text = viewModel.title
		newsSubTitleLabel.text = viewModel.subTitle
		
		if let data = viewModel.imageData
		{
			newsImageView.image = UIImage(data: data )
		}
		else
		{
			if let image = viewModel.imageUrl
			{
				URLSession.shared.dataTask(with: image) { [weak self] data, _ , error in
					guard let data = data , error==nil else {
						return
					}
					viewModel.imageData = data
					DispatchQueue.main.async {
						self?.newsImageView.image = UIImage(data: data )
					}
				}.resume()
			}
		}
	}

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
