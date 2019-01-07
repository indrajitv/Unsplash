//
//  File.swift
//  Unsplash
//
//  Created by Indrajit-mac on 31/12/18.
//  Copyright © 2018 IND. All rights reserved.
//

import UIKit

class BaseCellForCollectionView:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){}
}
