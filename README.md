# 🚀 On-Chain Subscription Renewal Reminder  

## 📌 Overview  
This project is a **decentralized subscription renewal reminder** system that leverages **Ethereum smart contracts** and an **off-chain Node.js notification service** to alert users before their subscriptions expire. The system ensures timely renewals through automated event emissions and email notifications.  

## 🛠 Features  
✅ **Smart Contract (Solidity)**  
- Stores user subscription details (start time, duration, status).  
- Emits an event when a subscription is about to expire.  
- Supports subscription renewal.  

✅ **Off-Chain Listener (Node.js + Web3.js)**  
- Monitors blockchain events for expiration alerts.  
- Sends email notifications via **Nodemailer**.  
- Can be extended for Web3 push notifications.  

## 🚀 Tech Stack  
- **Smart Contract:** Solidity (EVM compatible)  
- **Blockchain:** Ethereum (Deployed Contract: `0x516CedC381B5Dc4daE3B36D18C926Ab0A81A1484`)  
- **Backend Listener:** Node.js, Web3.js  
- **Notifications:** Nodemailer (Email alerts)  

---

## 📜 Smart Contract (Solidity)  
### **SubscriptionManager.sol**  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionManager {
    struct Subscription {
        address user;
        uint256 startTime;
        uint256 duration;
        bool active;
    }

    mapping(address => Subscription) public subscriptions;
    event SubscriptionRenewalReminder(address indexed user, uint256 expiryTime);
    event SubscriptionRenewed(address indexed user, uint256 newExpiryTime);

    function subscribe(uint256 _duration) external payable {
        require(_duration > 0, "Invalid duration");
        subscriptions[msg.sender] = Subscription(msg.sender, block.timestamp, _duration, true);
    }

    function checkSubscription() external {
        Subscription storage sub = subscriptions[msg.sender];
        require(sub.active, "No active subscription");
        uint256 expiryTime = sub.startTime + sub.duration;
        if (block.timestamp >= expiryTime - 1 days) {
            emit SubscriptionRenewalReminder(msg.sender, expiryTime);
        }
    }

    function renewSubscription(uint256 _newDuration) external payable {
        Subscription storage sub = subscriptions[msg.sender];
        require(sub.active, "No active subscription");
        sub.startTime = block.timestamp;
        sub.duration = _newDuration;
        emit SubscriptionRenewed(msg.sender, sub.startTime + _newDuration);
    }
}
```  

---

## 🖥 Off-Chain Notification System (Node.js + Web3.js)  
### **Install Dependencies**  
```sh
npm install web3 nodemailer dotenv
```  

### **Listener Script (index.js)**  
```javascript
const Web3 = require("web3");
const nodemailer = require("nodemailer");
require("dotenv").config();

const web3 = new Web3("https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID");
const contractAddress = "0x516CedC381B5Dc4daE3B36D18C926Ab0A81A1484";
const abi = [ /* Contract ABI here */ ];
const contract = new web3.eth.Contract(abi, contractAddress);

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: { user: process.env.EMAIL, pass: process.env.PASSWORD }
});

contract.events.SubscriptionRenewalReminder()
.on("data", async (event) => {
    const userAddress = event.returnValues.user;
    console.log(`Reminder: Subscription for ${userAddress} is expiring soon.`);
    
    const emailOptions = {
        from: process.env.EMAIL,
        to: "user_email@example.com",
        subject: "Subscription Renewal Reminder",
        text: `Your subscription is expiring soon. Please renew to continue the service.`
    };

    await transporter.sendMail(emailOptions);
    console.log("Email sent successfully!");
})
.on("error", console.error);
```  

---

## 📌 Setup & Deployment  
### **Smart Contract Deployment (Hardhat)**  
1. Install dependencies:  
   ```sh
   npm install --save-dev hardhat ethers
   ```  
2. Compile contract:  
   ```sh
   npx hardhat compile
   ```  
3. Deploy contract:  
   ```sh
   npx hardhat run scripts/deploy.js --network goerli
   ```  
4. **Deployed Contract Address:** `0x516CedC381B5Dc4daE3B36D18C926Ab0A81A1484`  

### **Run Notification Listener**  
1. Set up `.env` file with:  
   ```sh
   EMAIL=your_email@gmail.com
   PASSWORD=your_email_password
   INFURA_PROJECT_ID=your_infura_project_id
   ```  
2. Start the listener:  
   ```sh
   node index.js
   ```  

---

## 🔮 Future Enhancements  
- ✅ **Integrate Web3 push notifications (e.g., Push Protocol).**  
- ✅ **Enable automatic subscription renewals via smart contracts.**  
- ✅ **Build a frontend dashboard (React.js) for easy subscription management.**  

---

## 📜 License  
This project is licensed under the **MIT License**.  

## ✨ Author  
Developed by **[Your Name]** 🚀  

---

### 🌟 Like this project? Give it a ⭐ on GitHub!  
