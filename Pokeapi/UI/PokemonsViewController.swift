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
    
    private var pokemons = [Pokemon]()
    
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
        
        // presenter?.viewLoaded()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}

// MARK: - PokemonsView

extension PokemonsViewController: PokemonsView {
    
    func display(_ pokemons: [Pokemon]) {
        self.pokemons = pokemons
        self.tableView.reloadData()
    }
    
    func display(_ isLoading: Bool) {
        if isLoading {
            loadingContainerView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            loadingContainerView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    func display(_ message: String) {
        let alertController = UIAlertController(title: "Oops..", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension PokemonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension PokemonsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

