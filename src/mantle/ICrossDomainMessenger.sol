// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.9.0;

/**
 * @title ICrossDomainMessenger
 * @notice Mantle's bridge interface.
 * @dev https://github.com/mantlenetworkio/mantle/blob/main/packages/contracts/contracts/libraries/bridge/ICrossDomainMessenger.sol
 */
interface ICrossDomainMessenger {
    /**********
     * Events *
     **********/

    event SentMessage(
        address indexed target,
        address sender,
        bytes message,
        uint256 messageNonce,
        uint256 gasLimit
    );
    event RelayedMessage(bytes32 indexed msgHash);
    event FailedRelayedMessage(bytes32 indexed msgHash);

    /*************
     * Variables *
     *************/

    function xDomainMessageSender() external view returns (address);

    /********************
     * Public Functions *
     ********************/

    /**
     * @notice Sends a cross domain message to the target messenger.
     * @dev This signature is used when sending messages from Mantle to Ethereum.
     * @param mntAmount Amount of MNT to send with the message.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        uint mntAmount,
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external;

    /**
     * @notice Sends a cross domain message to the target messenger.
     * @dev This signature can be used when sending messages from Ethereum to Mantle.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external;
}
