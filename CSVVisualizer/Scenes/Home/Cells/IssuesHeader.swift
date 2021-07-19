//
//  IssuesHeader.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 19/07/21.
//

import UIKit
import SnapKit

final class IssuesHeader: UICollectionReusableView, ReusableView {
    
    // MARK: - Views
    let issueView = IssueView()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(issueView)
        issueView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func config(with viewModel: IssueViewModel) {
        issueView.config(with: viewModel)
    }
}
