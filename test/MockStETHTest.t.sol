// MockStETHTest

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MockStETH} from "../src/MockStETH.sol";
import {DeployMockStETH} from "../script/DeployMockStETH.s.sol";

contract MockStETHTest is Test {
    MockStETH public mockStEth;
    address public user = makeAddr("user");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant USER_SUBMIT_AMOUNT = 2 ether;
    uint256 public constant STAKING_REWARD = 1e8;

    function setUp() public {
        DeployMockStETH deployer = new DeployMockStETH();
        mockStEth = deployer.run();
        if (block.chainid == 31337) {
            vm.deal(user, STARTING_USER_BALANCE);
        }
    }

    function test_TotalSupplyAndSharesIncreasesAfterUserSubmits() public {
        uint256 initialBalance = mockStEth.totalSupply();
        uint256 initialShares = mockStEth.sharesOf(user);

        vm.prank(user);
        mockStEth.submit{value: 1 ether}();

        uint256 newBalance = mockStEth.totalSupply();
        uint256 newShares = mockStEth.sharesOf(user);

        assertGt(newBalance, initialBalance);
        assertGt(newShares, initialShares);
    }

    function test_UserBalanceUpdatesWithRewards() public {
        vm.prank(user);
        mockStEth.submit{value: USER_SUBMIT_AMOUNT}();
        uint256 initialUserBalance = mockStEth.balanceOf(user);

        vm.prank(mockStEth.owner());
        mockStEth.accumulateRewards(STAKING_REWARD);
        uint256 endingUserBalance = mockStEth.balanceOf(user);

        assertGt(endingUserBalance, initialUserBalance);
        assertEq(
            endingUserBalance,
            (mockStEth.sharesOf(user) * mockStEth.totalPooledEth()) /
                mockStEth.totalShares()
        );
    }
}
