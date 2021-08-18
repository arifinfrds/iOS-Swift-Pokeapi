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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

