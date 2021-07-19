//
//  IssuesHeader.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 19/07/21.
//

import UIKit
import SnapKit

class IssuesHeader: UICollectionReusableView, ReusableView {
    let issueView = IssueView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(issueView)
        issueView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with viewModel: IssueViewModel) {
        issueView.config(with: viewModel)
    }
}
