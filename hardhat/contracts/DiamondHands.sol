//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract DiamondHands {
    uint256 public constant TWO_YEARS = 2 * 365 days;
    struct DepositInfo {
        uint256 balance;
        uint256 expirationTimestamp;
    }
    mapping(address => DepositInfo) public deposits;

    event Deposit(address indexed account, uint256 indexed amount);
    event Withdrawal(address indexed account, uint256 indexed amount);

    function balanceOf(address _account) external view returns (uint256) {
        return deposits[_account].balance;
    }

    function deposit() external payable {
        DepositInfo storage senderDeposit = deposits[msg.sender];
        if (senderDeposit.balance == 0) {
            deposits[msg.sender].expirationTimestamp =
                block.timestamp +
                TWO_YEARS;
        }
        senderDeposit.balance += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(
            block.timestamp >= deposits[msg.sender].expirationTimestamp,
            "DiamondHands: funds are still locked"
        );
        require(
            deposits[msg.sender].balance >= _amount,
            "DiamondHands: insufficient balance"
        );
        deposits[msg.sender].balance -= _amount;
        (bool executed, ) = msg.sender.call{value: _amount}("");
        require(executed, "DiamondHands: withdrawal failed");

        emit Withdrawal(msg.sender, _amount);
    }
}
