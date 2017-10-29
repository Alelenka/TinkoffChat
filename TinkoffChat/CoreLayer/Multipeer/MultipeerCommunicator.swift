//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 22.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, ICommunicator {
    
    private var sessions = [ String : MCSession ]()
    
    private let peerID = MCPeerID(displayName: UUID().uuidString)
    private var browser: MCNearbyServiceBrowser!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var messageLoader: IMessageLoader!
    
    private let serviceType = "tinkoff-chat"
    private let discoveryInfo = ["userName" : "a$belyaeva"]
    private let messageEvent = "TextMessage"
    
    //ICommunicator
    weak var delegate: ICommunicatorDelegate?
    var online: Bool = true
    
    init(withMessageLoader loader: MessageLoader) {
        
        super.init()
        
        messageLoader = loader
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    // MARK: - Session Create
    
    private func createSession(forUser userID: String) -> MCSession {
        if let session = sessions[userID] {
            return session
        } else {
            
            let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
            sessions[userID] = session
            session.delegate = self
            
            return session
        }
    }
    
    // MARK: - Messages
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        guard let session = sessions[userID] else {
            completionHandler?(false, CommunicatorError.internalCommunicatorError)
            return
        }
        guard let message = messageLoader.maker.createMessage(text: string) else {
            completionHandler?(false, CommunicatorError.generateMessageCommunicatorError)
            return
        }
        
        for peer in session.connectedPeers {
            if peer != peerID {
                do {
                    try session.send(message, toPeers: [peer], with: .reliable)
                    completionHandler?(true, nil)
                } catch {
                    completionHandler?(false, CommunicatorError.sendCommunicatorError)
                }
            }
        }
    }
}

    // MARK: - MCSessionDelegate
extension MultipeerCommunicator: MCSessionDelegate {

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        guard let messageText = messageLoader.parser.getMessage(fromData: data) else { return }
        delegate?.didReceiveMessage(text: messageText, fromUser: peerID.displayName, toUser: UUID().uuidString)
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

    // MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate  {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("%@", "lostPeer: \(peerID)")
        
        sessions[peerID.displayName] = nil
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        
        let session = createSession(forUser: peerID.displayName)
        
        if !session.connectedPeers.contains(peerID) {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            let userName = info?["userName"] ?? "Noname"
            delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

    // MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        let session = createSession(forUser: peerID.displayName)
        if !session.connectedPeers.contains(peerID) {
            invitationHandler(true, session)
        } else {
            invitationHandler(false, nil)
        }
    }
}
