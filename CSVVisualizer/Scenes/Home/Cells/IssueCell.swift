//
//  IssueCell.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

struct IssueCellViewModel {
    let name: String?
    let surname: String?
    let issuesCount: String?
    let birth: String?
}

class IssueCell: UICollectionViewCell, ReusableView {
    
    enum Constants {
        static let spacing: CGFloat = 16
    }
    
    // MARK:- Views
    let nameLabel = Label()
    let surnameLabel = Label()
    let countLabel = Label()
    let birthLabel = Label()
    
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
    func setupAppearance() {
        contentView.backgroundColor = .white
    }
    
    // MARK:- Functions
    func config(with viewModel: IssueCellViewModel?) {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        surnameLabel.text = viewModel.surname
        countLabel.text = viewModel.issuesCount
        birthLabel.text = viewModel.birth
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(surnameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(birthLabel)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
        surnameLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
        countLabel.snp.makeConstraints {
            $0.left.equalTo(surnameLabel.snp.right)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.05)
        }
        birthLabel.snp.makeConstraints {
            $0.left.equalTo(countLabel.snp.right)
            $0.top.bottom.right.equalToSuperview()
        }
    }
}
