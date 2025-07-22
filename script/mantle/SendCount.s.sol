// SPDX-License-Identifier: GPL v3.0

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {MantleCounter} from "src/mantle/MantleCounter.sol";

/**@notice Used to call `sendCount()` on the MantleCounter contract. */
contract SendCount is Script {
    using stdJson for *;
    address public admin;
    /**@notice Address of the Mantle CrossDomainMessenger contract. */
    address public bridge;

    /**@notice MantleCounter contract on Etheruem Sepolia. */
    address public ethereumDeployment;
    /**@notice MantleCounter contract on Mantle Sepolia.*/
    address public mantleDeployment;

    /**@notice Gas limit provided to the CrossDomainMessenger. */
    uint32 gasLimit = 2_000_000;

    MantleCounter public counter;

    function setUp() public {
        admin = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
        vm.label(admin, "Admin");

        /* Retrieve the MantleCounter contract addresses from the JSON file */
        string memory deployments = vm.readFile("deployments/mantle.json");
        mantleDeployment = deployments.readAddress(".mantleSepolia");
        ethereumDeployment = deployments.readAddress(".ethereumSepolia");

        console2.log("mantleDeployment:", mantleDeployment);
        console2.log("ethereumDeployment:", ethereumDeployment);

        /** Set the counter address based on the chain Id */
        if (block.chainid == 11155111) {
            /* Ethereum Sepolia */
            counter = MantleCounter(ethereumDeployment);
        } else if (block.chainid == 5003) {
            /* Mantle Sepolia */
            counter = MantleCounter(mantleDeployment);
        } else {
            revert("Unsupported chain ID");
        }
    }

    function run(uint32 x) public {
        /* Set the target address based on the chain Id */
        address target = block.chainid == 11155111
            ? mantleDeployment
            : ethereumDeployment;
        /* Retrieve the stored number and log it */
        vm.broadcast(admin);
        counter.sendCount(x, gasLimit, target);
    }
}
