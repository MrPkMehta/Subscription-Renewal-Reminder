// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionManager {
    struct Subscription {
        uint256 endTime;
        bool isActive;
    }

    mapping(address => Subscription) public subscriptions;

    event SubscriptionCreated(address indexed user, uint256 endTime);
    event SubscriptionRenewed(address indexed user, uint256 newEndTime);
    event SubscriptionCanceled(address indexed user);

    // Create/renew a subscription (payment logic omitted for brevity)
    function createSubscription(uint256 _duration) external payable {
        uint256 endTime = block.timestamp + _duration;
        subscriptions[msg.sender] = Subscription(endTime, true);
        emit SubscriptionCreated(msg.sender, endTime);
    }

    function renewSubscription(uint256 _duration) external payable {
        require(subscriptions[msg.sender].isActive, "No active subscription");
        subscriptions[msg.sender].endTime += _duration;
        emit SubscriptionRenewed(msg.sender, subscriptions[msg.sender].endTime);
    }

    function cancelSubscription() external {
        subscriptions[msg.sender].isActive = false;
        emit SubscriptionCanceled(msg.sender);
    }
}
