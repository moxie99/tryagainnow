// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface Common {
  enum State { GENERATED, COLLECTED, RECYCLED }
  enum Category { COLLECTOR, GENERATOR, RECYCLER, BINOWNER }
  enum Share { COLLECTOR, GENERATOR, TEAM }

  error UserAlreadyExist();
  error UserAlreadyNotExist();
  error InvalidBinID();
  error EmptyBin();
  error CannotDeleteBinInEngagedMode();
  error InvalidWasteId();
  error NothingToWithdraw();

  struct WasteData {
    bytes32 value;
    address collector;
    address generator;
    address recycler;
    State state;
  }

  struct Profile {
    uint32 transactionTime;
    uint wasteCount;
    bool approval;
    bool isRegistered;
  }

  struct BinData {
    WasteData[] bin;
    address owner;
  }

}