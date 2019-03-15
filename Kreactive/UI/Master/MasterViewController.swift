//
//  MasterViewController.swift
//  Kreactive
//
//  Created by perotin nicolas on 12/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    private var detailViewController: DetailViewController? = nil
    private let provider = Provider<Movie>()
    private var viewModel: ListViewModel!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("master_title", comment: "")
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            split.delegate = self
        }
        tableView.register(UINib(nibName: Constant.CellIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.ListTableViewCell)
        viewModel = ListViewModel(provider: provider)
        viewModel.datasDidLoad = datasDidLoad
        viewModel.didFailLoading = didFailLoading
        viewModel.datasDidAppend = datasDidAppend
        viewModel.getItems()
        
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = false
        super.viewWillAppear(animated)
    }
    
    private func configureSearchController(){
        //to not display search bar on other screen when still active
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_movies", comment: "")
        navigationItem.searchController = searchController
    }
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            showDetail(imDBId: viewModel.items[indexPath.row].imdbID)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.items.count - 1 {
            viewModel.loadMoreItems()
        }
        
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.ListTableViewCell, for: indexPath) as! ListTableViewCell
        cell.movie = viewModel.items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    private func showDetail(imDBId: String?){
        if let controller = detailViewController{
            controller.imDBId = imDBId
            splitViewController?.showDetailViewController(controller, sender: nil)
        }
    }
    
    // MARK: -  ViewModel listener
    private func datasDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let isPortrait = UIDevice.current.orientation.isPortrait
            //select first line by default, only in landscape for regular width
            if self.viewModel.items.count > 0, UIScreen.main.traitCollection.horizontalSizeClass == .regular, isPortrait == false{
                let initialIndexPath = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition: .top)
                self.showDetail(imDBId: self.viewModel.items[initialIndexPath.row].imdbID)
            }
        }
    }
    
    private func datasDidAppend(fromIndex: Int) {
        DispatchQueue.main.async {
            var indexPathToAdd = [IndexPath]()
            for i in fromIndex...self.viewModel.items.count - 1{
                indexPathToAdd.append(IndexPath(row: i, section: 0))
            }
            let contentOffset = self.tableView.contentOffset
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPathToAdd, with: .bottom)
            self.tableView.setContentOffset(contentOffset, animated: false)
            self.tableView.endUpdates()
        }
    }
    
    private func didFailLoading(error: Error){
        if error.isNetworkError(){
            let alertController = UIAlertController(title: NSLocalizedString("network_error_label", comment: ""), message: NSLocalizedString("check_your_network_label", comment: ""), preferredStyle: .alert)
            let retryAction = UIAlertAction(title: NSLocalizedString("retry_button_title", comment: ""), style: .default) { (action) in
                self.viewModel.getItems()
            }
            alertController.addAction(retryAction)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

// MARK: - Split view

extension MasterViewController: UISplitViewControllerDelegate{
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.imDBId == nil {
            return true
        }
        return true
    }   
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isSearching() {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: nil)
            self.perform(#selector(self.search), with: nil, afterDelay: 0.3)
        }
    }
    
    @objc func search(){
        viewModel.getItems(searchTerms: searchController.searchBar.text)
    }
}
