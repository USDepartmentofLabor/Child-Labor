//
//  GoodsChartCollectionCell.swift
//  Child Labor
//
//  Created by Gostu Bhargavi on 13/05/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//

import UIKit

class GoodsChartCollectionCell: UICollectionViewCell {
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize:14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel.configure(on: self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureCell(cellData: DataItem) {
        self.titleLabel.text = cellData.title
        self.backgroundColor = cellData.color
        self.layer.cornerRadius = self.frame.size.width / 2;

    }
}

extension UIView {
    
    func configure(on parent: UIView, insets: UIEdgeInsets = .zero, safe:Bool = false) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        NSLayoutConstraint.activate(self.constraints(on: parent, insets: insets, safe: safe))
    }
    
    private func constraints(on parent:UIView, insets: UIEdgeInsets, safe:Bool = false) -> [NSLayoutConstraint] {
        
        guard  #available(iOS 11.0, *), safe == true else {
            
            return [self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
                    self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom)]
        }
        
        return [self.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom),
                self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: insets.right)]
    }
}
