//
//  ProportionalChartViewController.swift
//  Child Labor
//
//  Created by Gostu Bhargavi on 12/05/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//

import UIKit
import CoreGraphics


struct DataItem: Identifiable {
    var id = UUID()
    var title: String
    var size: CGFloat
    var color: UIColor
    var offset = CGSize.zero
}

class ProportionalChartViewController: UIViewController {
    
    private var data: [DataItem] = [
        DataItem(title: "GOLD", size: 2.4, color: .yellow),
        DataItem(title: "BRICKS", size: 2.0, color: UIColor(red: 255.0/255.0, green: 0, blue: 255.0/255.0, alpha: 1)),
        DataItem(title: "SUGARCANE", size: 1.9, color: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)),
        DataItem(title: "COTTON", size: 1.7, color: .purple),
        DataItem(title: "COFFEE", size: 1.7, color: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 247.0/255.0, alpha: 1)),
        DataItem(title: "TOBACCO", size: 1.7, color: UIColor(red: 0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)),
        DataItem(title: "CATTLE", size: 1.4, color: .green),
        DataItem(title: "FISH", size: 1.4, color: UIColor(red: 0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)),
        DataItem(title: "GARMENTS", size: 1.1, color: .red),
        DataItem(title: "RICE", size: 0.9, color: .green),
        DataItem(title: "COAL", size: 0.7, color: UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 255.0/255.0, alpha: 1))
       ]
    
    let minItemWidth : CGFloat = 65.0
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCollectionCell")
        self.collectionView.register(GoodsChartCollectionCell.self, forCellWithReuseIdentifier: "GoodsChartCollectionCell")
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.collectionView.collectionViewLayout == nil {
            self.collectionView.collectionViewLayout = CirclesLayout()
        }
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = "Proportional Chart"
        self.navigationController?.navigationBar.topItem?.title = " "

        // Navigation bar color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
            appearance.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        }
    }
    
}

extension ProportionalChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsChartCollectionCell", for: indexPath) as? GoodsChartCollectionCell
        cell?.configureCell(cellData: data[indexPath.item])

        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ProportionalChartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.data[indexPath.row].size * minItemWidth
        return CGSize(width: width, height: width)
    }
}

public extension UIViewController {
    
    class func loadFromNib(_ bundle:Bundle? = nil) -> Self {
        
        func instantiateFromNib<T: UIViewController>(bundle:Bundle?) -> T {
            
            let _bundle = bundle ?? Bundle(for: T.self)
            
            return T.init(nibName: String(describing: T.self), bundle: _bundle)
        }
        
        return instantiateFromNib(bundle: bundle)
    }
}
