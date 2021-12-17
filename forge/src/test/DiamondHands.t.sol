// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../DiamondHands.sol";

interface Vm {
    function warp(uint256 x) external;
}

contract DiamondHandsTest is DSTest {
    DiamondHands diamondHands;
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        vm.warp(100);
        diamondHands = new DiamondHands();
    }

    function testDeposit() public {
        (bool executed, ) = address(diamondHands).call{value: 1 ether}(
            abi.encodeWithSignature("deposit()")
        );
        require(executed, "deposit failed");

        assertEq(
            diamondHands.balances(address(this)),
            1 ether,
            "deposit amount incorrect"
        );
        assertEq(
            diamondHands.lockExpiryTimestamps(address(this)),
            63072100,
            "deposit expiry date incorrect"
        );

        (bool exec, ) = address(diamondHands).call{value: 5 ether}(
            abi.encodeWithSignature("deposit()")
        );
        require(exec, "deposit failed");

        assertEq(
            diamondHands.balances(address(this)),
            6 ether,
            "deposit amount incorrect"
        );
        assertEq(
            diamondHands.lockExpiryTimestamps(address(this)),
            63072100,
            "deposit expiry date incorrect"
        );
    }
}
