// SPDX-License-Identifier: GPL v3.0

pragma solidity ^0.8.17;

import {ICrossDomainMessenger} from "./ICrossDomainMessenger.sol";

/**@notice This contract is used to validate that we can send messages from Mantle to Ethereum and vice versa.
 * @author Rohan Nero
 */
contract MantleCounter {
    /**@notice The Mantle CrossDomainMessenger contract that relays our data from one chain to another. */
    address public bridge;

    /**@notice Variable that is updated by a nearly identical contract deployed on a different chain. */
    uint32 public num;

    /**@notice Used to validate the original sender's address.
     *@dev E.g. If this contract is deployed on Mantle Sepolia, this address should be updated to the Ethereum Sepolia contract address whenever `updateCount()` is called. */
    address public origin;

    /**@notice Emitted when `updateCount()` is called by the CrossDomainMessenger. */
    event CountUpdated(uint32 indexed newCount, address indexed origin);

    constructor(address _bridge) {
        bridge = _bridge;
    }

    /**@notice Designed to be called by the CrossDomainMessenger. */
    function updateCount(uint32 x) public {
        num = x;
        /* `xDomainMessageSender()` returns the address that sent the cross chain data */
        origin = ICrossDomainMessenger(bridge).xDomainMessageSender();

        emit CountUpdated(x, origin);
    }

    /**@notice Sends an ABI encoded uint32 variable to the CrossDomainMessenger contract.
     *@dev The `num` value at the `target` address should be updated to `x` after execution. */
    function sendCount(uint32 x, uint32 gasLimit, address target) public {
        bytes memory message = abi.encodeWithSelector(
            this.updateCount.selector,
            x
        );

        ICrossDomainMessenger(bridge).sendMessage(0, target, message, gasLimit);
    }
}
