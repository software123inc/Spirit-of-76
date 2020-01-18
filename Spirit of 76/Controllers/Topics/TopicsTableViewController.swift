//
//  TopicsTableViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift
import S123Common

class TopicsTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedResultsController:NSFetchedResultsController<Topic>?
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<SectionType, Topic>(tableView: tableView) { (tableView, indexPath, topic) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCIdentifier.topicCell, for: indexPath)
        
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.synopsis
        
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
        if segue.identifier == K.SegueID.showTopicDetail, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? TopicDetailViewController {
            DDLogVerbose("DVC = \(dvc.className)")
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let currentItem = diffableDataSource.itemIdentifier(for: indexPath) {
                dvc.topic = currentItem
            }
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - DATA MANAGEMENT
    
    private func loadModel() {
        let releasedContentPredicate = NSPredicate.init(format: "releaseStatus == true")
        let sort1 = NSSortDescriptor(key: "title", ascending: true)
        let request: NSFetchRequest<Topic> = Topic.fetchRequest()
        
        request.sortDescriptors = [sort1]
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
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, Topic>()
        diffableDataSourceSnapshot.appendSections([.main])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController?.fetchedObjects ?? [])
        
        let shouldAnimate = animated && (tableView.window != nil)
        self.diffableDataSource.apply(diffableDataSourceSnapshot, animatingDifferences: shouldAnimate)
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension TopicsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
