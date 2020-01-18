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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController:NSFetchedResultsController<JsonImport>?
    private var dataSource: FavoritesDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.showFavoriteEvent, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? EventDetailViewController {
            dvc.event = sender as? Event
        }
        else if segue.identifier == K.SegueID.showFavoriteSigner, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? PersonDetailViewController {
            dvc.person = sender as? Person
        }
        else if segue.identifier == K.SegueID.showFavoriteTopic, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? TopicDetailViewController {
            dvc.topic = sender as? Topic
        }
        else if segue.identifier == K.SegueID.showFavoriteDetail, let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? FavoriteDetailViewController {
            dvc.favorite = sender as? CardSummary
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ii = dataSource.itemIdentifier(for: indexPath)
        if let entityName = ii?.entity.name, let sectionTypeTrueName = FavoriteSectionEntityNames.init(rawValue: entityName) {
            switch sectionTypeTrueName {
                case .event:
                    performSegue(withIdentifier: K.SegueID.showFavoriteEvent, sender: ii)
                case .person:
                    performSegue(withIdentifier: K.SegueID.showFavoriteSigner, sender: ii)
                case .topic:
                    performSegue(withIdentifier: K.SegueID.showFavoriteTopic, sender: ii)
                case .education, .fact, .profession, .quote:
                        performSegue(withIdentifier: K.SegueID.showFavoriteDetail, sender: ii)
            }
        }
    }
    
    //MARK: - DATA MANAGEMENT
    private func configureDataSource() {
        dataSource = FavoritesDiffableDataSource(tableView: tableView) {(tableView, indexPath, jsonImport) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCIdentifier.favoriteCell, for: indexPath)
            cell.textLabel?.text = jsonImport.cardTitle
            cell.detailTextLabel?.text = jsonImport.cardDetailText
            
            return cell
        }
        
        self.loadModelFromFetchResult()
    }
    
    private func loadModelFromFetchResult() {
        let releasedContentPredicate = NSPredicate.init(format: "isFavorite == true")
        
        let sectionNameKeyPath = "entity"
        let sort1 = NSSortDescriptor(key: sectionNameKeyPath, ascending: true)
        let request: NSFetchRequest<JsonImport> = JsonImport.fetchRequest()
        
        request.sortDescriptors = [sort1]
        request.predicate = releasedContentPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: viewContext,
                                                              sectionNameKeyPath: sectionNameKeyPath,
                                                              cacheName: "favoritesCache")
        fetchedResultsController?.delegate = self
        
        do {
            DDLogVerbose("Perform fetch<JsonImport>.")
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
            DDLogError(error.localizedDescription)
        }
        
        updateSnapshot()
    }
    
    private func updateSnapshot(animated: Bool = false) {
        // The animation default = false to prevent an error when the model updates and the tableView is not visible.
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<FavoriteSection, JsonImport>()
        
        if let frc = self.fetchedResultsController, let sections = frc.sections {
            for (i, section) in (sections.enumerated()) {
                if let items = section.objects as? [JsonImport],
                    let sectionType = FavoriteSectionType.init(rawValue: i)
                {
                    /* our sectionType really won't correspond to our Entity class, we just
                     need to keep our sections indexes in order. We can figure out what the
                     name of the section is not from sectionType, but by pulling the entity.name
                     value from the first object in each section (as we do for the header names).*/
                    diffableDataSourceSnapshot.appendSections([sectionType])
                    diffableDataSourceSnapshot.appendItems(items)
                    
                    let shouldAnimate = animated && (tableView.window != nil)
                    dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: shouldAnimate, completion: nil)
                }
                else {
                    DDLogWarn("Unexpected objects in FetchResultsController<JsonImport>.")
                }
            }
        }
        else {
            DDLogWarn("Unexpected FetchResultsController<JsonImport>.")
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
