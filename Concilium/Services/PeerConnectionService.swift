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
    private let myPeerID: MCPeerID
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // callbacks for the ChatView to subscribe to later
    var onMessageReceived: ((Message) -> Void)?
    var onPeerConnected: ((String) -> Void)?
    
    @Published var connectedPeerName: String?
    @Published var isConnected = false

    @Published var discoveredPeers: [MCPeerID] = []
    
    @Published var showInviteAlert = false
    var pendingInvitation: (peer: MCPeerID, handler: (Bool, MCSession?) -> Void)?

    
    init(displayName: String = UIDevice.current.name) {
        self.myPeerID = MCPeerID(displayName: displayName)
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
        print("📣Started advertising as \(myPeerID.displayName)")
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
        print("🔍Started browsing for peers")
    }
    
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
        discoveredPeers.removeAll()
        print("🛑 Stopped all peer activities")
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
    
    func invite(_ peer: MCPeerID) {
        print("📨 Sending invitation to \(peer.displayName)")
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
    }
    
    func acceptInvitation(){
        pendingInvitation?.handler(true,session)
        pendingInvitation = nil
        showInviteAlert = false
        print("✅ Invitation accepted")
    }
    
    func declineInvitation(){
        pendingInvitation?.handler(false,session)
        pendingInvitation = nil
        showInviteAlert = false
        print("❌ Invitation declined")
    }
}


extension PeerConnectionService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Connected, connecting, or not connected
        switch state {
        case .notConnected:
            
            DispatchQueue.main.sync { [weak self] in
                self?.connectedPeerName = nil
                self?.isConnected = false
            }
            print("❌ Disconnected from \(peerID.displayName)")
            
        case .connecting:
            print("🔄 Connecting to \(peerID.displayName)")
        case .connected:
            
            DispatchQueue.main.sync { [weak self] in
                self?.onPeerConnected?(peerID.displayName)
                self?.connectedPeerName = peerID.displayName
                self?.isConnected = true
            }
            print("✅ Connected to \(peerID.displayName)")
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
        
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            self.pendingInvitation = (peerID, invitationHandler)
            self.showInviteAlert = true
            print("📩 Received invitation from \(peerID.displayName)")
        }
    }
}


extension PeerConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            if !self.discoveredPeers.contains(peerID){
                self.discoveredPeers.append(peerID)
                print("📡 Found peer: \(peerID.displayName)")
            }
        }
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
         DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.discoveredPeers.removeAll { $0 == peerID }
            print("🚫 Lost peer: \(peerID.displayName)")
        }
    }
}


