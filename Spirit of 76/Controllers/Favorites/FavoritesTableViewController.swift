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
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var dataSource: FavoritesDiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.didToggleFavorite,
                                               object: nil,
                                               queue: .main) { (note) in
                                                if self.dataSource == nil {
                                                    self.configureDataSource()
                                                }
                                                self.loadModel(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard JsonImport.hasFavorites else { return }
        configureDataSource()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            dvc.favorite = sender as? FavoriteSummary
        }
        else {
            DDLogWarn("unhandled segue id: \(String(describing: segue.identifier))")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ii = dataSource?.itemIdentifier(for: indexPath), let entityName = ii.entity.name, let sectionTypeTrueName = FavoriteSectionEntityNames.init(rawValue: entityName) {
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
            cell.textLabel?.text = jsonImport.favoriteTitle
            cell.detailTextLabel?.text = jsonImport.favoriteDetailText
            cell.imageView?.image = jsonImport.favoriteAvatar ?? K.Image.libertyBell
            
            return cell
        }
        
        self.loadModel()
    }
    
    private func loadModel(animated: Bool = false) {
        let sectionNameKeyPath = K.ManObjKey.entity
        let sort1 = NSSortDescriptor(key: sectionNameKeyPath, ascending: true)
        let request: NSFetchRequest<JsonImport> = JsonImport.fetchRequest()
        
        request.sortDescriptors = [sort1, K.SortBy.sortValueASC]
        request.predicate = K.Predicate.isFavorite
        
        let frc = requestController(fetchRequest: request, sectionNameKeyPath: sectionNameKeyPath)
        
        do {
            DDLogVerbose("Perform fetch<JsonImport>.")
            try frc.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
            DDLogError(error.localizedDescription)
        }
        
        updateSnapshot(frc:frc, animated: animated)
    }
    
    private func requestController<T>(fetchRequest:NSFetchRequest<T>, sectionNameKeyPath:String) -> NSFetchedResultsController<T> {
        // We don't want a cache as we need to re-fetch on appearance.
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: viewContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }
    
    private func updateSnapshot(frc:NSFetchedResultsController<JsonImport>?, animated: Bool = false) {
        // The animation default = false to prevent an error when the model updates and the tableView is not visible.
        var snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, JsonImport>()
        
        if let frc = frc, let sections = frc.sections {
            for (i, section) in (sections.enumerated()) {
                if let items = section.objects as? [JsonImport], let sectionType = FavoriteSectionType.init(rawValue: i)
                {
                    /* our sectionType really won't correspond to our Entity class, we just
                     need to keep our sections indexes in order. We can figure out what the
                     name of the section is not from sectionType, but by pulling the entity.name
                     value from the first object in each section (as we do for the header names).*/
                    snapshot.appendSections([sectionType])
                    snapshot.appendItems(items)
                    
                    let shouldAnimate = animated && (tableView.window != nil)
                    dataSource?.apply(snapshot, animatingDifferences: shouldAnimate)
                }
                else {
                    DDLogWarn("Unexpected objects in FetchResultsController<JsonImport>.")
                }
            }
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    // It's likely this is never called as our FRC is a local variable.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let frc = controller as? NSFetchedResultsController<JsonImport> {
            updateSnapshot(frc: frc, animated: true)
        }
    }
}
