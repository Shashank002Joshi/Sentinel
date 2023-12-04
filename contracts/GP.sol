// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./sentinel.sol";

contract SentinelProxy is TransparentUpgradeableProxy, Sentinel {
    constructor(address _logic, address admin_, bytes memory _data)
        payable
        TransparentUpgradeableProxy(_logic, admin_, _data)
    {}

    function _internalDelegate(address _toimplementation) private nonReentrant returns (bytes memory) {
        bytes memory ret_data = Address.functionDelegateCall(_toimplementation, msg.data);
        return ret_data;
    }
    function _delegate(address _toimplementation) internal override {
        bytes memory ret_data = _internalDelegate(_toimplementation);
        uint256 ret_size = ret_data.length;
        assembly {
            return(add(ret_data, 0x20), ret_size)
        }
    }
}