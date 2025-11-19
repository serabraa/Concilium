# 📡 Concilium

A simple local peer-to-peer messenger built with SwiftUI

**Concilium** is a small experimental iOS app that allows two nearby devices to connect and chat with each other without using the internet.
The app works entirely offline through Apple’s **Multipeer Connectivity** framework, which communicates over Bluetooth or the local network.

The project demonstrates how to:

---
## 🔮 Features
* Offline peer-to-peer messaging using Bluetooth or local Wi-Fi
* User chooses a custom display name on app launch
* Live discovery of nearby devices in a modern grid interface
* Tap-to-connect invitations with Accept/Decline prompt
* Secure encrypted session created through Multipeer Connectivity
* Clean SwiftUI chat screen with message bubbles and dark-mode design
* Smooth auto-scrolling and keyboard handling
* Real-time JSON-encoded message sending and receiving
* No servers, no accounts, and no saved conversations (temporary chats)

## ✨ How it works

### 1. Enter your name

When the app launches, the user chooses a display name.
This name becomes your identity when visible to nearby devices.

### 2. Discover peers

You see a modern grid of all nearby devices running the app.
This list updates automatically as peers appear or disappear.

### 3. Connect

Tapping a device sends a connection request.
The other user receives an “Accept / Decline” prompt.
If accepted, both devices instantly join a secure local session.

### 4. Chat

The chat screen uses SwiftUI message bubbles, auto-scrolling, and a simple dark design.
Messages are encoded with `JSONEncoder` and sent directly between devices —
no servers, no accounts, no storage, and no history.

---

## 🧩 Technologies Used

* **SwiftUI** for all UI
* **Multipeer Connectivity** for device discovery and communication
* **JSON Encoding/Decoding** for message data
* **Local-only peer-to-peer communication** (Bluetooth / local network)

---

## 🎯 Purpose

This project is an MVP and a learning experiment.
The goal is to create a minimal messenger that:

* works offline
* connects only to nearby devices
* keeps conversations temporary
* and demonstrates how SwiftUI and Multipeer Connectivity can be combined

## 📁 Photos of the project 


<img width="200" alt="1" src="https://github.com/user-attachments/assets/87f58922-0122-46bd-a4f3-8bafa2ecbb2c" />
<img width="200" alt="2" src="https://github.com/user-attachments/assets/22f9b9ea-21b2-4577-8a63-91ab8e3158a1" />
<img width="200" alt="3" src="https://github.com/user-attachments/assets/3665b78c-7c47-4078-a2d9-a8af8bdff697" />
<img width="200" alt="4" src="https://github.com/user-attachments/assets/a478d346-103f-49ca-9672-af74270be7f3" />
<img width="200" alt="5" src="https://github.com/user-attachments/assets/49f5eef3-dffb-48b2-be4d-66159e726b44" />
<img width="200" alt="6" src="https://github.com/user-attachments/assets/a5b98f91-b473-43ca-a34b-e641cc327ea3" />
<img width="200" alt="7" src="https://github.com/user-attachments/assets/9dcfabda-6ecc-41fa-bf2e-9f30d4bfe814" />
<img width="200" alt="8" src="https://github.com/user-attachments/assets/19de03b9-a515-498e-bcfc-eecb3354bc9e" />
