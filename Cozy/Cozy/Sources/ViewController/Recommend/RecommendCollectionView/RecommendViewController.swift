//
//  RecommendViewController.swift
//  Cozy
//
//  Created by IJ . on 2020/07/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController {
    
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    fileprivate var selectedCell: UICollectionViewCell?
    private var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        flowLayout을 이용한 cellsize
        //        let layout = recommendCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        
        
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        
        // Set the cells sizes and layout direction
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 327, height: 405)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.recommendCollectionView.collectionViewLayout = layout
        
        self.recommendCollectionView.register(cellType: CardCollectionViewCell.self)
        
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
}


extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCollectionViewCell.self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = self.recommendCollectionView.cellForItem(at: indexPath)
        
        let vc = DetailViewController.instantiate()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
      
}

extension RecommendViewController: Animatable {
    var containerView: UIView? {
        return self.recommendCollectionView
    }
    
    var childView: UIView? {
        return self.selectedCell
    }
}

extension UIViewController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if self.tabBarController?.tabBar.isHidden != hidden{
            if animated {
                //Show the tabbar before the animation in case it has to appear
                if (self.tabBarController?.tabBar.isHidden)!{
                    self.tabBarController?.tabBar.isHidden = hidden
                }
                if let frame = self.tabBarController?.tabBar.frame {
                    let factor: CGFloat = hidden ? 1 : -1
                    let y = frame.origin.y + (frame.size.height * factor)
                    UIView.animate(withDuration: duration, animations: {
                        self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                    }) { (bool) in
                        //hide the tabbar after the animation in case ti has to be hidden
                        if (!(self.tabBarController?.tabBar.isHidden)!){
                            self.tabBarController?.tabBar.isHidden = hidden
                        }
                    }
                }
            }
        }
    }
}