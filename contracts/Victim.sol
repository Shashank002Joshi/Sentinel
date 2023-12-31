// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Attacker.sol";

contract Victim {
    uint256 public counter;

    function callback() external {
        _count();
    }

    function countLocalRecursive(uint256 n) public {
        if (n > 0) {
            _count();
            countLocalRecursive(n - 1);
        }
    }

    function countThisRecursive(uint256 n) public {
        if (n > 0) {
            _count();
            (bool success,) = address(this).call(abi.encodeWithSignature("countThisRecursive(uint256)", n - 1));
            require(success, "ReentrancyMock: failed call");
        }
    }

    function countAndCall(Attacker _attacker) public {
        _count();
        bytes4 func = bytes4(keccak256("callback()"));
        _attacker.callSender(func);
    }

    function _count() private {
        counter += 1;
    }
}
