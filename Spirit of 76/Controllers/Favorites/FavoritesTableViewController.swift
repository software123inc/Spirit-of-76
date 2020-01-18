//
//  FavoritesTableViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift
import S123Common

class FavoritesTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedResultsController:NSFetchedResultsController<JsonImport>?
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<SectionType, JsonImport>(tableView: tableView) { (tableView, indexPath, JsonImport) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCIdentifier.favoriteCell, for: indexPath)
        
        cell.textLabel?.text = JsonImport.cardTitle
        cell.detailTextLabel?.text = JsonImport.cardDetailText
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = diffableDataSource
        self.loadModel()
        
        /*
         When loading the snapshot the first time, the table is not visible, so it should
         not be animated. Passing TRUE at this stage would throw a warning about the table not
         existing yet, and getting a performance hit.
         */
        updateSnapshot()
    }
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.showFavoriteDetail, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? FavoriteDetailViewController {
            DDLogVerbose("DVC = \(dvc.className)")
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let _ = diffableDataSource.itemIdentifier(for: indexPath) {
//                dvc.favorite = currentItem
            }
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - DATA MANAGEMENT
    
    private func loadModel() {
        let releasedContentPredicate = NSPredicate.init(format: "isFavorite == true")
        let sort1 = NSSortDescriptor(key: "entity", ascending: true)
        let request: NSFetchRequest<JsonImport> = JsonImport.fetchRequest()
        
        request.sortDescriptors = [sort1]
        request.predicate = releasedContentPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
            DDLogError(error.localizedDescription)
        }
    }
    
    private func updateSnapshot(animated: Bool = false) {
        // The animation default = false to prevent an error when the model updates and the tableView is not visible.
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, JsonImport>()
        diffableDataSourceSnapshot.appendSections([.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        
        let shouldAnimate = animated && (tableView.window != nil)
        self.diffableDataSource.apply(diffableDataSourceSnapshot, animatingDifferences: shouldAnimate)
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
