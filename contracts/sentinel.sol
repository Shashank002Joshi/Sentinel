// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/StorageSlot.sol";


abstract contract Sentinel {
    
    bytes32 private constant STATUS_STORAGE_SLOT = bytes32(uint256(keccak256("eip1967.reentrancy.status")) - 1);

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    event RentrancyStaticCallCheck();

    function _setReentrancyStatus(uint256 newStatus) private {
        StorageSlot.getUint256Slot(STATUS_STORAGE_SLOT).value = newStatus;
    }

    function _getReentrancyStatus() private view returns (uint256) {
        return StorageSlot.getUint256Slot(STATUS_STORAGE_SLOT).value;
    }

    modifier nonReentrant() {
        bool not_in_static = _nonReentrantBefore();
        _;
        if (not_in_static) {
            _nonReentrantAfter();
        }
    }

   
    modifier nonReentrantStatic() {
        require(_getReentrancyStatus() != _ENTERED, "ReentrancyGuard: reentrant static call");
        _;
    }

    function staticCallCheck() external {
        emit RentrancyStaticCallCheck();
    }

    function _isStaticCall() private returns (bool) {
        try this.staticCallCheck() {
            return false;
        } catch {
            return true;
        }
    }

    function _nonReentrantBefore() private returns (bool) {
        
        require(_getReentrancyStatus() != _ENTERED, "ReentrancyGuard: reentrant call");

        

        if (_isStaticCall()) {
            return false;
        } else {
            _setReentrancyStatus(_ENTERED);
            return true;
        }
    }

    function _nonReentrantAfter() private {
    
        _setReentrancyStatus(_NOT_ENTERED);
    }
}