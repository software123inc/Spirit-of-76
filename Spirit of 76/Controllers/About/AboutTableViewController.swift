//
//  AboutTableViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/19/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import MessageUI
import UIKit
import CocoaLumberjackSwift
import DeviceKit
import S123Common

class AboutTableViewController: UITableViewController {
    @IBOutlet weak var prefScrollMiniTextViews: UISwitch!
    @IBOutlet weak var prefShowTablesInitially: UISwitch!
    @IBOutlet weak var rateMeCell: UITableViewCell!
    @IBOutlet weak var shareAppCell: UITableViewCell!
    @IBOutlet weak var sendEmailCell: UITableViewCell!
    @IBOutlet weak var creditsCell: UITableViewCell!
    @IBOutlet weak var aboutAppCell: UITableViewCell!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        initializePrefsFromUserDefaults()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController, let dvc = navVC.topViewController as? AboutDetailsViewController {
            if let senderCell = sender as? UITableViewCell {
                switch senderCell {
                    case creditsCell:
                        dvc.aboutText = "Lives of the Signers of the Declaration of Independence\nLossing, B.J.; Geo. F. Cooledge & Brother\nNew York. 1848. Reprinted by Wallbuilder Press, 2008.\n🇺🇸\nFounders' Almanac, The: A Practical Guide to the Notable Events, Greatest Leaders & Most Eloquent Words of the American Founding\nSpalding, Matthew. 2004."
                    case aboutAppCell:
                        dvc.aboutText = "\(K.appName) version \(K.appVersion)\n🇺🇸\nWebsite: \(K.facebookURL)\n🇺🇸\nCopyright © 2020 by EduServe, Inc. All rights reserved."
                    default:
                        DDLogWarn("Unhandled sender.")
                }
            }
            else {
                DDLogWarn("Unhandled segue. Sender type:\(sender.debugDescription)")
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func PrefValueChanged(_ sender: UISwitch) {
        switch sender {
            case prefScrollMiniTextViews:
                toggleScrollMiniTextViewsPref()
            case prefShowTablesInitially:
                toggleShowTablesInitially()
            default:
                DDLogWarn("Unhandled switch pref.")
        }
        
        let idxSet = IndexSet.init(1..<tableView.numberOfSections)
        tableView.reloadSections(idxSet, with: .automatic)
    }
    
    //MARK: - Instance functions
    
    private func initializePrefsFromUserDefaults() {
        prefScrollMiniTextViews.isOn = UserDefaults.standard.bool(forKey: K.PrefKey.scrollMiniTextViews)
        prefShowTablesInitially.isOn = UserDefaults.standard.bool(forKey: K.PrefKey.showTablesInitially)
    }
    
    private func toggleScrollMiniTextViewsPref() {
        UserDefaults.standard.set(prefScrollMiniTextViews.isOn, forKey: K.PrefKey.scrollMiniTextViews)
    }
    
    private func toggleShowTablesInitially() {
        UserDefaults.standard.set(prefShowTablesInitially.isOn, forKey: K.PrefKey.showTablesInitially)
    }
    
    private func shareApp() {
        if let appURL = K.appURL {
            let activityViewController = UIActivityViewController(
                activityItems: [appURL],
                applicationActivities: nil)
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let device = Device.current
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@software123.com"])
            mail.setMessageBody("<p>======<br/>App: \(K.appName).<br />Version: \(K.appVersion)<br />Device: \(device)<br />Please Do Not Remove<br/>======</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            DDLogWarn("App cannot send email.")
        }
    }
    
    private func showCredits() {
        performSegue(withIdentifier: K.SegueID.showAboutDetails, sender: creditsCell)
    }
    
    private func showAboutInformation() {
        performSegue(withIdentifier: K.SegueID.showAboutDetails, sender: aboutAppCell)
    }
    
    //MARK: - TableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        switch selectedCell {
            case rateMeCell:
                AppStoreReviewManager.requestReviewIfAppropriate()
            case shareAppCell:
                shareApp()
            case sendEmailCell:
                sendEmail()
            case creditsCell:
                showCredits()
            case aboutAppCell:
                showAboutInformation()
            default:
                DDLogVerbose("Unhandled cell selection.")
        }
    }
}

extension AboutTableViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
