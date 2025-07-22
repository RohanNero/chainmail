// SPDX-License-Identifier: GPL v3.0

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {MantleCounter} from "src/mantle/MantleCounter.sol";

/**@notice Outputs the `num` variable from the MantleCounter contract deployed on Mantle Sepolia or Ethereum Sepolia. */
contract LogCounter is Script {
    using stdJson for *;
    address public admin;
    /**@notice Address of the Mantle CrossDomainMessenger contract. */
    address public bridge;

    /**@notice MantleCounter contract on Etheruem Sepolia. */
    address public ethereumDeployment;
    /**@notice MantleCounter contract on Mantle Sepolia.*/
    address public mantleDeployment;

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

    function run() public view {
        /* Retrieve the stored number and log it */
        uint32 currentCount = counter.num();
        console2.log("Count:", currentCount);

        /* Log the origin address */
        address origin = counter.origin();
        console2.log("Origin:", origin);
    }
}
