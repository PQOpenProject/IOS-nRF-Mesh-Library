//
//  NodeAddAppKeyViewController.swift
//  nRFMeshProvision_Example
//
//  Created by Aleksander Nowakowski on 28/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import nRFMeshProvision

protocol AppKeyDelegate {
    /// This method is called when a new Application Key has been added to the Node.
    func keyAdded()
}

class NodeAddAppKeyViewController: ProgressViewController {
    
    // MARK: - Outlets and Actions
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        guard let selectedIndexPath = selectedIndexPath else {
            return
        }
        let selectedAppKey = keys[selectedIndexPath.row]
        start("Adding Application Key...") {
            try? MeshNetworkManager.instance.send(ConfigAppKeyAdd(applicationKey: selectedAppKey), to: self.node)
        }
    }
    
    // MARK: - Properties
    
    var node: Node!
    var delegate: AppKeyDelegate?
    
    private var keys: [ApplicationKey]!
    private var selectedIndexPath: IndexPath?
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEmptyView(title: "No keys available", message: "Go to Settings to create a new key,\nor add a bound Network Key first.", messageImage: #imageLiteral(resourceName: "baseline-key"))
        
        MeshNetworkManager.instance.delegate = self
        
        let meshNetwork = MeshNetworkManager.instance.meshNetwork!
        keys = meshNetwork.applicationKeys.notKnownTo(node: node).filter {
            node.knows(networkKey: $0.boundNetworkKey)
        }
        if keys.isEmpty {
            tableView.showEmptyView()
        }
        // Initially, no key is checked.
        doneButton.isEnabled = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = keys[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = key.name
        cell.detailTextLabel?.text = "Bound to \(key.boundNetworkKey.name)"
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var rows: [IndexPath] = []
        if let selectedIndexPath = selectedIndexPath {
            rows.append(selectedIndexPath)
        }
        rows.append(indexPath)
        selectedIndexPath = indexPath
        tableView.reloadRows(at: rows, with: .automatic)
        
        doneButton.isEnabled = true
    }
}

extension NodeAddAppKeyViewController: MeshNetworkDelegate {
    
    func meshNetworkManager(_ manager: MeshNetworkManager,
                            didReceiveMessage message: MeshMessage,
                            sentFrom source: Address, to destination: Address) {
        // Has the Node been reset remotely.
        guard !(message is ConfigNodeReset) else {
            (UIApplication.shared.delegate as! AppDelegate).meshNetworkDidChange()
            done() {
                let rootViewControllers = self.presentingViewController?.children
                self.dismiss(animated: true) {
                    rootViewControllers?.forEach {
                        if let navigationController = $0 as? UINavigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                    }
                }
            }
            return
        }
        // Is the message targetting the current Node?
        guard node.unicastAddress == source else {
            return
        }
        
        // Handle the message based on its type.
        switch message {
            
        case let status as ConfigAppKeyStatus:
            done() {
                if status.status == .success {
                    self.dismiss(animated: true)
                    self.delegate?.keyAdded()
                } else {
                    self.presentAlert(title: "Error", message: status.message)
                }
            }
            
        default:
            // Ignore
            break
        }
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager,
                            failedToSendMessage message: MeshMessage,
                            from localElement: Element, to destination: Address,
                            error: Error) {
        done() {
            self.presentAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager,
                            failedToReceiveResponseForMessage message: AcknowledgedMeshMessage,
                            sentFrom localElement: Element, to destination: Address, error: Error) {
        done() {
            self.presentAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
}
