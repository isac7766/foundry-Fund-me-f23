//SPDX-License-Identifier:MIT
pragma solidity 0.8.34;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
contract DeployFundme is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address eth_pricefeed_address = helperConfig.current_network();
        vm.startBroadcast();
        FundMe fundme = new FundMe(eth_pricefeed_address);
        vm.stopBroadcast();
        return fundme;
    }
}
