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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
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

