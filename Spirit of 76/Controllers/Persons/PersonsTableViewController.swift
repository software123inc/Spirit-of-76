//
//  PersonsTableViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/3/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift
import S123Common

class PersonsTableViewController: UITableViewController  {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController:NSFetchedResultsController<Person>?
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<SectionType, Person>(tableView: tableView) { (tableView, indexPath, person) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCIdentifier.personCell, for: indexPath)
        
        cell.textLabel?.text = person.lastFirst
        cell.detailTextLabel?.text = person.summaryText
        cell.imageView?.image = person.cardAvatar
        
        return cell
    }
    
    //MARK: - VIEW LIFE CYCLE
    
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
        if segue.identifier == K.SegueID.showPersonDetail, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? PersonDetailViewController {
            DDLogVerbose("DVC = \(dvc.className)")
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let personItem = diffableDataSource.itemIdentifier(for: indexPath) {
                dvc.person = personItem
            }
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - DATA MANAGEMENT
    
    private func loadModel() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.sortDescriptors = [K.SortBy.sortValueASC]
        request.predicate = K.Predicate.isReleased
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: K.CacheName.personCache)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
        }
    }
    
    private func updateSnapshot(animated: Bool = false) {
        // The animation default = false to prevent an error when the model updates and the tableView is not visible.
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, Person>()
        diffableDataSourceSnapshot.appendSections([.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        
        let shouldAnimate = animated && (tableView.window != nil)
        self.diffableDataSource.apply(diffableDataSourceSnapshot, animatingDifferences: shouldAnimate)
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension PersonsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
