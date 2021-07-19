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
    var issues: Driver<Issues> { get }
    var error: Driver<String> { get }
}

protocol HomeViewControllerOutput {
    var action: AnyObserver<HomeAction> { get }
}

enum HomeAction {
    case viewLoaded
    case selectedIndexPath(IndexPath)
}

final class HomeViewController: UIViewController {
    
    // MARK: - Views
    lazy var collectionViewLayout: UICollectionViewLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }()
    
    // MARK: - Properties
    let input: HomeViewControllerInput
    let output: HomeViewControllerOutput
    private let disposeBag = DisposeBag()
    private var issues: Issues?
    private var collectionItems = [IssueCellViewModel]()
    
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
//        navigationBar.setTitle("Front Page")
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
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
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    private func setupBindings() {
        input.issues
            .drive(onNext: { [weak self] issues in
                guard let self = self else { return }

                self.issues = issues
                self.collectionItems = issues.items.map {
                    IssueCellViewModel(name: $0.name, surname: $0.surname, issuesCount: $0.issuesCount, birth: $0.dateOfBirth)
                }
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
        return collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = collectionItems[safe: indexPath.item]
    
        let cell: IssueCell = {
            return collectionView.dequeueReusableCell(for: indexPath) as IssueCell
        }()
        
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.action.onNext(.selectedIndexPath(indexPath))
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 50)
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
