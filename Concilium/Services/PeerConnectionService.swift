//
//  PeerConnectionService.swift
//  Concilium
//
//  Created by Sergey on 14.11.25.
//

import MultipeerConnectivity
import Foundation

final class PeerConnectionService: NSObject, ObservableObject {
    private let serviceType = "local-chat"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // callbacks for the ChatView to subscribe to later
    var onMessageReceived: ((Message) -> Void)?
    var onPeerConnected: ((String) -> Void)?
    
    override init() {
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
    }
    
    // MARK: - Public API
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
    }
    
    func send(_ message: Message) {
        guard !session.connectedPeers.isEmpty else { return }
        
        do {
            let data = try JSONEncoder().encode(message)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch{
            print("Error, Failed to send a message \(error.localizedDescription)")
        }
        
    }
}


extension PeerConnectionService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Connected, connecting, or not connected
        switch state {
        case .notConnected:
            print("❌ Disconnected from \(peerID.displayName)")
        case .connecting:
            print("🔄 Connecting to \(peerID.displayName)")
        case .connected:
            print("✅ Connected to \(peerID.displayName)")
            DispatchQueue.main.sync { [weak self] in
                self?.onPeerConnected?(peerID.displayName)
            }
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Handle incoming message data
        do{
            let incomingData = try JSONDecoder().decode(Message.self, from: data)
            let message = Message(id: incomingData.id, text: incomingData.text, isSentByMe: false, timestamp: incomingData.timestamp)
            DispatchQueue.main.async { [weak self] in
                self?.onMessageReceived?(message)
                
            }
        }catch {
            print("Error, Failed to decode a message \(error.localizedDescription)")
        }
    }
    
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) { }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) { }
}


extension PeerConnectionService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Automatically accept for now
        invitationHandler(true, session)
    }
}


extension PeerConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        // Invite any peer we find
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle peer disappearing
    }
}


