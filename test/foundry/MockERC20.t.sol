// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {MockERC20} from "../../contracts/MockERC20.sol";

contract MockERC20Test is Test {
    error OwnableUnauthorizedAccount(address account);

    MockERC20 public mockERC20;

    function setUp() external {
        mockERC20 = new MockERC20();
    }

    function test_Mint() external {
        uint mintAmount = 1 ether;
        address owner = mockERC20.owner();

        uint beforeBalance = mockERC20.balanceOf(owner);
        console2.log("before balance: ", beforeBalance);

        // set owner as msg.sender
        vm.prank(owner);
        mockERC20.mint(mintAmount);

        uint afterBalance = mockERC20.balanceOf(owner);
        console2.log("after balance: ", afterBalance);

        assertEq(afterBalance - beforeBalance, mintAmount);
    }

    function test_Mint_RevertWhen_CallerIsNotOwner() external {
        address tempAddr = vm.addr(1);
        vm.prank(tempAddr);
        uint mintAmount = 1 ether;

        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUnauthorizedAccount.selector,
                tempAddr
            )
        ); // expectRevert 는 revert 발생하는 함수 호출 상단에 존재해야한다

        mockERC20.mint(mintAmount);
    }

    function testFuzz_Mint(uint mintAmount) external {
        address owner = mockERC20.owner();

        uint beforeBalance = mockERC20.balanceOf(owner);
        console2.log("before balance: ", beforeBalance);

        vm.prank(owner);
        mockERC20.mint(mintAmount);

        uint afterBalance = mockERC20.balanceOf(owner);
        console2.log("after balance: ", afterBalance);

        assertEq(afterBalance - beforeBalance, mintAmount);
    }
}
