// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        uint256 deployerKey;
    }

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 5) {
            activeNetworkConfig = getGoerliEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig()
        public
        view
        returns (NetworkConfig memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    function getGoerliEthConfig()
        public
        view
        returns (NetworkConfig memory goerliNetworkConfig)
    {
        goerliNetworkConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    function getOrCreateAnvilEthConfig()
        public view
        returns (NetworkConfig memory anvilNetworkConfig)
    {
        anvilNetworkConfig = NetworkConfig({
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY
        });
    }
}
