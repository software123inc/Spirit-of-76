//
//  EventsTableViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift
import S123Common

class EventsTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedResultsController:NSFetchedResultsController<Event>?
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<SectionType, Event>(tableView: tableView) { (tableView, indexPath, event) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCIdentifier.eventCell, for: indexPath)
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.asOfDate?.toString(style: .long) ?? "\(event.year)"
        cell.detailTextLabel?.textColor = UIColor.init(named: K.BrandColors.cayenne)
        
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
        if segue.identifier == K.SegueID.showEventDetail, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? EventDetailViewController {
            DDLogVerbose("DVC = \(dvc.className)")
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let currentItem = diffableDataSource.itemIdentifier(for: indexPath) {
                dvc.event = currentItem
            }
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - DATA MANAGEMENT
    
    private func loadModel() {
        let releasedContentPredicate = NSPredicate.init(format: "releaseStatus == true")
        let sort1 = NSSortDescriptor(key: "year", ascending: true)
        let sort2 = NSSortDescriptor(key: "asOfDate", ascending: true)
        let sort3 = NSSortDescriptor(key: "name", ascending: true)
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        
        request.sortDescriptors = [sort1, sort2, sort3]
        request.predicate = releasedContentPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
        }
    }
    
    private func updateSnapshot(animated: Bool = false) {
        // The animation default = false to prevent an error when the model updates and the tableView is not visible.
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, Event>()
        diffableDataSourceSnapshot.appendSections([.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        
        let shouldAnimate = animated && (tableView.window != nil)
        self.diffableDataSource.apply(diffableDataSourceSnapshot, animatingDifferences: shouldAnimate)
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension EventsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
