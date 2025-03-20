// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReferralSystem {
    struct User {
        address referrer;
        uint256 referralCount;
        uint256 rewards;
    }

    mapping(address => User) public users;
    uint256 public rewardAmount;

    event UserRegistered(address indexed user, address indexed referrer);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(uint256 _rewardAmount) {
        rewardAmount = _rewardAmount;
    }

    function register(address referrer) external {
        require(users[msg.sender].referrer == address(0), "User already registered");
        require(referrer != msg.sender, "Self-referral is not allowed");

        users[msg.sender] = User(referrer, 0, 0);

        if (referrer != address(0)) {
            users[referrer].referralCount += 1;
            users[referrer].rewards += rewardAmount;
        }

        emit UserRegistered(msg.sender, referrer);
    }

    function claimRewards() external {
        uint256 rewards = users[msg.sender].rewards;
        require(rewards > 0, "No rewards to claim");

        users[msg.sender].rewards = 0;
        payable(msg.sender).transfer(rewards);

        emit RewardClaimed(msg.sender, rewards);
    }

    function depositFunds() external payable {}

    function getUserDetails(address user) external view returns (address, uint256, uint256) {
        User memory u = users[user];
        return (u.referrer, u.referralCount, u.rewards);
    }
}

