// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

abstract contract Disposer {

  struct Disposal {
    bool userType;
    uint64 disposeCount;
  }

  mapping(address => Disposal) public approvals;

  modifier isDiposer(address who) {
    require(approvals[who].userType, "Not a disposer");
    _;
  }

  function _approveNewtDisposer(address newDisposer, bool value) internal virtual {
    if(value) require(!approvals[newDisposer].userType, "Already approved");
    else require(approvals[newDisposer].userType, "Already deactivated");
    approvals[newDisposer].userType = value;
  }
}