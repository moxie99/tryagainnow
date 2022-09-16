// contracts/SupportToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice A simple ERC20 Token implementation that also accepts donation for the project
 */
contract IBoola is ERC20, Ownable {
    constructor(uint initialMintAmount) ERC20("iBoola Token", "IBT") {
        
        /// @notice mint 10000 tokens to the owner
        _mint(_msgSender(), initialMintAmount);
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to.amount);
    }

    function burn(uint amount) public {
        _burn(_msgSender(), amount);
    }
}
