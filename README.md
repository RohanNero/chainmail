# Chain Mail

Minimal interactions between smart contracts deployed on Ethereum Mainnet and various Ethereum Layer 2 chains.

## Mantle 

Overview from Mantle's [documentation](https://docs.mantle.xyz/network):

    "combines an optimistic rollup with various innovative data availability solutions, 
    providing cheaper and more accessible data availability while inheriting the security of Ethereum"

Mantle has a [markdown guide](https://github.com/mantlenetworkio/mantle-tutorial/tree/main/cross-dom-comm#communication-between-contracts-on-l1-and-l2) explaining how to send data using their bridge both [offchain in JavaScript](https://github.com/mantlenetworkio/mantle-tutorial/tree/main/cross-dom-comm#seeing-it-in-action) and [onchain in Solidity](https://github.com/mantlenetworkio/mantle-tutorial/tree/main/cross-dom-comm#how-its-done-in-solidity).

### Mantle Bridge Interface

To send data between Mantle and Ethereum L1, we can use Mantle's [ICrossDomainMessenger](https://github.com/mantlenetworkio/mantle/blob/main/packages/contracts/contracts/libraries/bridge/ICrossDomainMessenger.sol). The function that allows us to send `bytes` between chains is called `sendMessage()`, here is the function signature:

```
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
```

Alternatively, if we don't need to send native tokens between chains, the `mntAmount` variable can be excluded to reference the `sendMessage()` function signature that only requires the `target`, `message`, and `gasLimit` parameters.

**Note: Currently, calling `sendMessage()` to send data from Mantle Sepolia to Ethereum Sepolia will fail if `mntAmount` is not provided. The [bridge contract on Mantle Sepolia](https://sepolia.mantlescan.xyz/address/0x4200000000000000000000000000000000000007#code) is not verified so the reason for this cannot be easily determined.**

**Note: The Mantle Sepolia -> Ethereum Sepolia flow doesn't function as expected. The `sendCount()` transaction will execute correctly, but the `num` and `origin` values are never updated in the Ethereum Sepolia `MantleCounter` contract.**

### Mantle Sepolia Commands

Deploy MantleCounter to Mantle Sepolia:

```
forge script DeployMantleCounter --rpc-url https://rpc.sepolia.mantle.xyz/ --broadcast --verify --etherscan-api-key <YOUR__ETHERSCAN_API_KEY>
```

Log `num` and `origin` on Mantle Sepolia:
    
```
forge script LogCounter --rpc-url https://rpc.sepolia.mantle.xyz/
```

Send a number from Mantle Sepolia (to Ethereum Sepolia):

```
forge script SendCount --rpc-url https://rpc.sepolia.mantle.xyz/ --sig "run(uint32)" 777 --broadcast
```

### Ethereum Sepolia Commands

Deploy MantleCounter to Ethereum Sepolia: 

```
forge script script/DeployCounter.s.sol:DeployCounter --rpc-url https://eth-sepolia.g.alchemy.com/v2/<YOUR_ALCHEMY_API_KEY> --broadcast --verify --etherscan-api-key <YOUR__ETHERSCAN_API_KEY>
```

Log `num` and `origin` on Ethereum Sepolia: 

```
forge script LogCounter --rpc-url https://eth-sepolia.g.alchemy.com/v2/<YOUR_ALCHEMY_API_KEY>
```

Send a number from Ethereum Sepolia (to Mantle Sepolia):

```
forge script SendCount --rpc-url https://eth-sepolia.g.alchemy.com/v2/<YOUR_ALCHEMY_API_KEY> --sig "run(uint32)" 777 --broadcast
```
