// SPDX-License-Identifier: GPL v3.0

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/Test.sol";
import {MantleCounter} from "src/mantle/MantleCounter.sol";

/**@notice Deploys the MantleCounter contract to either Ethereum Sepolia or Mantle Sepolia. */
contract DeployMantleCounter is Script {
    /**@notice The deployer address. */
    address public admin;
    /**@notice Address of the Mantle CrossDomainMessenger contract. */
    address public bridge;

    MantleCounter public counter;

    function setUp() public {
        admin = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
        vm.label(admin, "Admin");

        /** Assign the bridge address based on the chain Id */
        if (block.chainid == 11155111) {
            /* Ethereum Sepolia */
            bridge = 0x37dAC5312e31Adb8BB0802Fc72Ca84DA5cDfcb4c;
        } else if (block.chainid == 5003) {
            /* Mantle Sepolia */
            bridge = 0x4200000000000000000000000000000000000007;
        } else {
            revert("Unsupported chain ID");
        }
    }

    function run() public {
        vm.broadcast(admin);
        /* Deploy the MantleCounter contract with the bridge address */
        counter = new MantleCounter(bridge);
        storeDeploymentAddress();
    }

    function storeDeploymentAddress() public {
        /* Path to the JSON file where the deployed MantleCounter addresses are stored */
        string memory path = "deployments/mantle.json";

        /* Allows us to update the new address without overwriting the entire file */
        string memory valueKey = block.chainid == 11155111
            ? ".ethereumSepolia"
            : ".mantleSepolia";

        /* Convert the address to a string */
        string memory jsonValue = vm.toString(address(counter));

        /* Create file with empty object if it doesn't exist yet */
        if (!vm.exists(path)) {
            vm.writeJson('{"mantleSepolia": "", "ethereumSepolia": ""}', path);
        }

        /* Write just the address at the correct key */
        vm.writeJson(jsonValue, path, valueKey);
    }
}
