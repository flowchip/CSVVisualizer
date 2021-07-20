//
//  HomeViewController.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

protocol HomeViewControllerInput {
    var section: Driver<IssuesSection> { get }
    var error: Driver<String> { get }
}

protocol HomeViewControllerOutput {
    var action: AnyObserver<HomeAction> { get }
}

enum HomeAction {
    case viewLoaded
}

final class HomeViewController: UIViewController {
    
    // MARK: - Views
    lazy var collectionViewLayout: UICollectionViewLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }()
    
    // MARK: - Properties
    let input: HomeViewControllerInput
    let output: HomeViewControllerOutput
    private let disposeBag = DisposeBag()
    private var section: IssuesSection?
    
    // Infinyte scroll
    private var showMore: Bool = false
    private var page: Int = 1
    private var canLoadMore: Bool = true

    // MARK: - Lifecycle
    init(input: HomeViewControllerInput, output: HomeViewControllerOutput) {
        self.input = input
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addSubviews()
        setupCollectionView()
        setupBindings()
        output.action.onNext(.viewLoaded)
    }

    // MARK: - Private functions
    private func setupAppearance() {
        title = "Issues"
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }

    private func setupBindings() {
        input.section
            .drive(onNext: { [weak self] section in
                guard let self = self else { return }

                self.section = section
                self.collectionView.reloadData()
                self.canLoadMore = true
            })
            .disposed(by: disposeBag)

        input.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(message: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "An error occured", message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = section?.items[safe: indexPath.item]
    
        let cell: IssueCell = {
            return collectionView.dequeueReusableCell(for: indexPath) as IssueCell
        }()
        
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, let viewModel = section?.header {
            let sectionHeader = collectionView.dequeueSupplementaryView(ofKind: kind, for: indexPath) as IssuesHeader
            sectionHeader.config(with: viewModel)
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard self.section?.header != nil else { return .zero }
        return CGSize(width: view.frame.width , height: 40)
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
