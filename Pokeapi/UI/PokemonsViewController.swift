//
//  PokemonsViewController.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import UIKit

final class PokemonsViewController: UIViewController {
    
    @IBOutlet weak private(set) var tableView: UITableView!
    @IBOutlet weak private(set) var loadingContainerView: UIView!
    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    
    private let cellId = "PokemonCell"
    
    private var presenter: PokemonsPresenter?
    
    private var cellViewModels = [PokemonCellViewModel]()
    
    init?(coder: NSCoder, presenter: PokemonsPresenter) {
        super.init(coder: coder)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        presenter?.viewLoaded()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        showTableViewSeparator(false)
    }
}

// MARK: - PokemonsView

extension PokemonsViewController: PokemonsView {
    
    func display(_ viewModel: PokemonsNavigationBarViewModel) {
        self.title = viewModel.title
    }
    
    func display(_ cellViewModels: [PokemonCellViewModel]) {
        self.cellViewModels = cellViewModels
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func display(_ viewModel: PokemonsLoadingViewModel) {
        if viewModel.isLoading {
            DispatchQueue.main.async { [weak self] in
                self?.showLoadingView()
                self?.showTableViewSeparator(false)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.hideLoadingView()
                self?.showTableViewSeparator(true)
            }
        }
    }
    
    func display(_ viewModel: PokemonsErrorViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension PokemonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let cellViewModel = cellViewModels[indexPath.row]
        cell.textLabel?.text = cellViewModel.pokemon.name
        cell.detailTextLabel?.text = cellViewModel.subtitle
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension PokemonsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension PokemonsViewController {
    
    func showLoadingView() {
        loadingContainerView.isHidden = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingContainerView.isHidden = true
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func showTableViewSeparator(_ shouldShow: Bool) {
        if shouldShow {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
    }
    
}
