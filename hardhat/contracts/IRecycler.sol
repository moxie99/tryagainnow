// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IRecycler {
  struct CycleData {
    uint32 dateRecycled;
    bytes32 proof;
  }
}