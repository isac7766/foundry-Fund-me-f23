// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../src/Mock.sol";
contract HelperConfig is Script {
    networkconfig public current_network;
    constructor() {
        if (block.chainid == 11155111) {
            current_network = sepolianetwork();
        } else {
            current_network = anvilnetwork();
        }
    }

    struct networkconfig {
        address pricefeed;
    }
    function sepolianetwork() public pure returns (networkconfig memory) {
        networkconfig memory s_network = networkconfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return s_network;
    }
    function anvilnetwork() public returns (networkconfig memory) {
        vm.startBroadcast();
        MockV3Aggregator anvilpricefeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        networkconfig memory a_network = networkconfig({
            pricefeed: address(anvilpricefeed)
        });
        return a_network;
    }
}
