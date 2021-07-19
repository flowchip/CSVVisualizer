//
//  IssueCell.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

final class IssueCell: UICollectionViewCell, ReusableView {
    
    enum Constants {
        static let spacing: CGFloat = 16
    }
    
    // MARK:- Views
    let issueView = IssueView()
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK:- Private functions
    private func setupAppearance() {
        contentView.backgroundColor = .white
    }
    
    // MARK:- Functions
    func config(with viewModel: IssueViewModel?) {
        guard let viewModel = viewModel else { return }
        issueView.config(with: viewModel)
    }
    
    func addSubviews() {
        contentView.addSubview(issueView)
    }
    
    func setupConstraints() {
        issueView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
