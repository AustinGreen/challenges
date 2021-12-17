// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

/*
 * Build a diamond hands contract that allows users to deposit ETH. Every time they deposit ETH, it will be locked for two years.
 * After two years, they will be able to withdraw the ETH.
 * Your implementation should run unit tests on the contract, and actually confirm all of its functionality.
 */

contract DiamondHands {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockExpiryTimestamps;

    event Deposit(address indexed account, uint256 indexed amount);
    event Withdrawal(address indexed account, uint256 indexed amount);

    function deposit() external payable {
        if (balances[msg.sender] == 0) {
            lockExpiryTimestamps[msg.sender] = block.timestamp + 730 days;
        }
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(
            block.timestamp >= lockExpiryTimestamps[msg.sender],
            "DiamondHands: funds are still locked"
        );
        require(
            balances[msg.sender] >= _amount,
            "DiamondHands: insufficient balance"
        );
        balances[msg.sender] -= _amount;
        (bool executed, ) = msg.sender.call{value: _amount}("");
        require(executed, "DiamondHands: withdrawal failed");

        emit Withdrawal(msg.sender, _amount);
    }
}
