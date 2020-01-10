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

enum SectionType {
    case main
}

protocol PersonSelectionDelegate: class {
  func personSelected(_ newPerson: Person)
}

class PersonsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    weak var delegate: PersonSelectionDelegate?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedResultsController:NSFetchedResultsController<Person>?
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<SectionType, Person>(tableView: tableView) { (tableView, indexPath, person) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        cell.textLabel?.text = person.lastFirst
        cell.detailTextLabel?.text = person.summaryText
        cell.imageView?.image = person.avatar
        
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
        updateSnapshot(animated: false)
    }
    
    func loadModel() {
        let releasedContentPredicate = NSPredicate.init(format: "release_status == true")
        let sortLastName = NSSortDescriptor(key: "lastName", ascending: true)
        let sortFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        
        request.sortDescriptors = [sortLastName, sortFirstName]
        request.predicate = releasedContentPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
        }
    }
    
    func updateSnapshot(animated: Bool = true) {
            var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, Person>()
            diffableDataSourceSnapshot.appendSections([.main])
            diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
            self.diffableDataSource.apply(diffableDataSourceSnapshot, animatingDifferences: animated)
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}

// MARK: - UITableViewDelegate methods

extension PersonsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let personItem = diffableDataSource.itemIdentifier(for: indexPath) {
            if let delegate = delegate {
                delegate.personSelected(personItem)

                if let detailViewController = delegate as? PersonDetailViewController {
                    if let splitViewController = splitViewController {
                        splitViewController.showDetailViewController(detailViewController, sender: self)
                    }
                    else {
                        DDLogDebug("Can't determine splitViewController.")
                    }
                }
                else {
                    DDLogDebug("Can't determine detailViewController.")
                }
            }
            else {
                DDLogDebug("Can't determine delegate.")
            }
        }
        else {
            DDLogDebug("Can't determine selected Person.")
        }
    }
}
