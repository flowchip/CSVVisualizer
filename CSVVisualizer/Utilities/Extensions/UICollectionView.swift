//
//  UICollectionView.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self)
        return dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.defaultReuseIdentifier)
        return dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
}
