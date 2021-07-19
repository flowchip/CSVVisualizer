//
//  IssueView.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 19/07/21.
//

import UIKit

struct IssueViewModel {
    enum Style {
        case header
        case content
    }
    
    let name: String?
    let surname: String?
    let issuesCount: String?
    let birth: String?
    var style: Style = .content
    
    init(name: String?, surname: String?, issuesCount: String?, birth: String?, style: Style = .content) {
        self.name = name
        self.surname = surname
        self.issuesCount = issuesCount
        self.birth = birth
        self.style = style
    }
}

final class IssueView: UIView {
    let nameLabel = Label()
    let surnameLabel = Label()
    let countLabel = Label()
    let birthLabel = Label()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(nameLabel)
        addSubview(surnameLabel)
        addSubview(countLabel)
        addSubview(birthLabel)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.30)
        }
        surnameLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.30)
        }
        countLabel.snp.makeConstraints {
            $0.left.equalTo(surnameLabel.snp.right)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        birthLabel.snp.makeConstraints {
            $0.left.equalTo(countLabel.snp.right)
            $0.top.bottom.right.equalToSuperview()
        }
    }
    
    func config(with viewModel: IssueViewModel) {
        nameLabel.text = viewModel.name
        surnameLabel.text = viewModel.surname
        countLabel.text = viewModel.issuesCount
        birthLabel.text = viewModel.birth
        
        backgroundColor = viewModel.style == .header ? .blue : .white
        [nameLabel, surnameLabel, countLabel, birthLabel].forEach {
            $0.textColor = viewModel.style == .header ? .white : .black
        }
    }
}
