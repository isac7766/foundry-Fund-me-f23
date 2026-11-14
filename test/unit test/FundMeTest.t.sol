//SPDX-License-Identifier:MIT
pragma solidity 0.8.34;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
contract FundMeTest is Test {
    FundMe fundme;
    address Ismail = makeAddr("ismail");
    modifier funder() {
        vm.prank(Ismail);
        fundme.fund{value: 5 ether}();
        _;
    }
    function setUp() public {
        //fundme = new FundMe();
        DeployFundme deployfundme = new DeployFundme();
        fundme = deployfundme.run();
        vm.deal(Ismail, 10 ether);
    }
    function testminusd() public {
        //console.log("the minimum usd is:",fundme.s_MINIMUM_USD());
        assertEq(fundme.s_MINIMUM_USD(), 5 * 10 ** 18);
    }
    function testversion() public {
        assertEq(fundme.getVersion(), 4);
    }
    function testfund() public {
        vm.expectRevert();
        fundme.fund();
        //if you want insert value:fundme.fund{valu:...}();
    }
    function testaddressToAmountFunded() public funder {
        assertEq(fundme.viewaddressToAmountFunded(Ismail), 5 ether);
    }
    function testfundersrecords() public funder {
        assertEq(fundme.viewfunders(0), Ismail);
    }
    function testonlyownertowithrdraw() public funder {
        vm.prank(Ismail);
        vm.expectRevert();
        fundme.withdraw();
    }
    function testwithdrawalwhithsinglefunder() public funder {
        uint256 ownerbalancebefore = fundme.getowneraddress().balance;
        uint256 contractbalancebefore = address(fundme).balance;
        vm.prank(fundme.getowneraddress());
        fundme.withdraw();
        uint256 ownerbalanceafter = fundme.getowneraddress().balance;
        uint256 contractbalanceafter = address(fundme).balance;
        assertEq(contractbalanceafter, 0);
        assertEq(contractbalancebefore + ownerbalancebefore, ownerbalanceafter);
    }
    function testwithdrawalaftermultiplefunding() public {
        for (uint160 i = 1; i < 11; i++) {
            hoax(address(i), 10 ether);
            fundme.fund{value: 5 ether}();
        }
        uint256 ownerbalancebefore = fundme.getowneraddress().balance;
        uint256 contractbalancebefore = address(fundme).balance;
        vm.prank(fundme.getowneraddress());
        fundme.withdraw();
        uint256 ownerbalanceafter = fundme.getowneraddress().balance;
        uint256 contractbalanceafter = address(fundme).balance;
        assert(contractbalanceafter == 0);
        assertEq(contractbalancebefore + ownerbalancebefore, ownerbalanceafter);
    }
    /* function testcheaperwithdrawalwhithsinglefunder() public funder {
        uint256 ownerbalancebefore = fundme.getowneraddress().balance;
        uint256 contractbalancebefore = address(fundme).balance;
        vm.prank(fundme.getowneraddress());
        fundme.cheaperwithdraw();
        uint256 ownerbalanceafter = fundme.getowneraddress().balance;
        uint256 contractbalanceafter = address(fundme).balance;
        assertEq(contractbalanceafter, 0);
        assertEq(contractbalancebefore + ownerbalancebefore, ownerbalanceafter);
    }
    function testcheaperwithdrawalaftermultiplefunding() public {
        for (uint160 i = 1; i < 11; i++) {
            hoax(address(i), 10 ether);
            fundme.fund{value: 5 ether}();
        }
        uint256 ownerbalancebefore = fundme.getowneraddress().balance;
        uint256 contractbalancebefore = address(fundme).balance;
        vm.prank(fundme.getowneraddress());
        fundme.cheaperwithdraw();
        uint256 ownerbalanceafter = fundme.getowneraddress().balance;
        uint256 contractbalanceafter = address(fundme).balance;
        assert(contractbalanceafter == 0);
        assertEq(contractbalancebefore + ownerbalancebefore, ownerbalanceafter);
    }*/
}
