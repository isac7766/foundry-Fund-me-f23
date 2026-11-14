//SPDX-License-Identifier:MIT
pragma solidity 0.8.34;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interaction.s.sol";
contract testinteraction is Test {
    FundMe fundMe;
    function setUp() external {
        DeployFundme deploy = new DeployFundme();
        fundMe = deploy.run();
        //vm.deal(USER, STARTING_BALANCE);
    }
    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}

/*//SPDX-License-Identifier:MIT
pragma solidity 0.8.34;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interaction.s.sol";
contract testinteraction is Test {
    address user = makeAddr("IA");
    FundMe fundme;
    function setup() public {
        DeployFundme deploy = new DeployFundme();
        fundme = deploy.run();
        vm.deal(user, 10 ether);
    }
    function testinteractionfund() public {
        FundFundMe fundfundme = new FundFundMe();
        vm.prank(user);
        fundfundme.fundFundMe(address(fundme));
        assertEq(address(fundme).balance(), 0.1 ether);
    }
    function testinteractiondwithdraw() public {
        WithdrawFundMe withdrawfundme = new WithdrawFundMe();
        expectRevert();
        vm.prank(user);
        withdrawfundme.withdrawFundMe(address(fundme));
    }
}*/
/*
// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract InteractionsTest is ZkSyncChainChecker, StdCheats, Test {
    FundMe public fundMe;
    HelperConfig public helperConfig;

    uint256 public constant SEND_VALUE = 0.1 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    address public constant USER = address(1);

    // uint256 public constant SEND_VALUE = 1e18;
    // uint256 public constant SEND_VALUE = 1_000_000_000_000_000_000;
    // uint256 public constant SEND_VALUE = 1000000000000000000;

    function setUp() external skipZkSync {
        if (!isZkSyncChain()) {
            DeployFundMe deployer = new DeployFundMe();
            (fundMe, helperConfig) = deployer.deployFundMe();
        } else {
            helperConfig = new HelperConfig();
            fundMe = new FundMe(helperConfig.getConfigByChainId(block.chainid).priceFeed);
        }
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public skipZkSync {
        uint256 preUserBalance = address(USER).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 originalFundMeBalance = address(fundMe).balance;

        // Using vm.prank to simulate funding from the USER address
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 afterUserBalance = address(USER).balance;
        uint256 afterOwnerBalance = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        assertEq(preOwnerBalance + SEND_VALUE + originalFundMeBalance, afterOwnerBalance);
    }
}*/
