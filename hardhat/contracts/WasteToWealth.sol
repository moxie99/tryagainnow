// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./libraries/WasteToWealthLib.sol";
import "./deps/Context.sol";
import "./deps/Ownable.sol";
import "./deps/IERC20.sol";

/**
 * @title Main
 * @author Bobeu: https://github.com/bobeu
 * A smart contract that will tokenize the disposal and collection of waste. 
    Users get a token when they dispose of their waste in a waste bin, collectors 
    get token for collecting waste and taking them to the waste recyclers 

    The process of tokenization happens when the waste drops in the waste bin. Every
    waste bin has a unique wallet ID which will receive the token at the end of evacuation.
    The owners of the waste bin will have a DAO. 

    *Wallet 
    *Token (iBoola token) which would be paired against either Avalanche, Celo or Polygon 
    *New users get 10 $IBT after sign up 
    *Community of waste bins will have a DAO 
    Waste generators get 10% collectors get 65 while the iBoola team gets 25% 
    Decimals: use standard 18 decimals 

    Mintable: not mintable

    Ownership privilege :  30% locked for 5 years, 20% for dev team 45% for  initial circulation, 
    5% for presale 

    PSEUDO
    ======
    Parties:
        o Waste generators.
        o Collectors.
        o Recyclers.

    o When waste is disposed or evacuated, then reward collectors.
    o Each waste bin has a unique identifer and an owner.
    o On sign up, user gets 10 $IBT Token.
    o Waste collectors own a DAO.
    o Waste bin owners own a DAO.
    o Reward sharing formula
    ========================
        - Waste generators 10%.
        - Collectors 65%.
        - Team 25%.
 */
contract WasteToWealth is Context, Common, Ownable {

    ///@dev New sign up reward
    uint public newSignUpReward;

    ///@dev iBoola Token
    address public token;

    ///@dev Total waste generated to date
    uint256 public totalWasteGenerated;

    ///@dev Collector reward
    uint public collectorReward;

    ///@dev Total bin registered to date
    uint public binCounter;

    /**
        @dev Array of bins 
            { Contain bins which contain collected wastes which contains wastedata}
            @notice Bins in this list are owned by addresses.
    */
    BinData[] public bins;
    
    mapping (Share=>uint8) public formula;
    

    /**
        @dev Mapping of Generated and Recycled Waste State -> binId (binCounter) -> WasteData
        Keys type: 
            o State
            o uint256

        value:
           array of struct(s) 
     */
    mapping (State=>WasteData[]) public garbages;
    
    /**
        @dev Mapping of Waste State -> user -> profile
        Keys type: 
            o State
            o address

        value:
            struct 
     */
    mapping (Category=>mapping(address=>Profile)) profiles;

    /**
        @dev Sign up fees for different category.
            @notice - It can be configured to suit any category.
     */
    mapping (Category=>uint256) public signUpFees;

    ///@dev Rewards
    // mapping(address=>uint) public rewards;


    modifier validateWasteId(uint binId, uint wasteId, State state, string memory errorMessage) {
        if(binId >= bins.length) revert InvalidBinID();
        if(state == State.COLLECTED) {
            if(wasteId >= bins[binId].bin.length) revert InvalidWasteId();
        }
        require(bins[binId].bin[wasteId].state == state, errorMessage);
        _;
    }

    ///Checks user's existence
    modifier isApproved(Category cat, address who) {
        if(!_getApproval(cat, who)) revert UserAlreadyNotExist();
        _;
    }

    ///@dev Validates category
    modifier validateCategory(uint8 cat) {
        require(cat < 4, "Invalid category");
        _;
    }

    constructor (address _token) { 
        token = _token;
        newSignUpReward = 10 * (10 ** 18);
        profiles[Category.BINOWNER][_msgSender()].approval = true;
        formula[Share.COLLECTOR] = 65;
        formula[Share.GENERATOR] = 10;
        formula[Share.TEAM] = 25;
    }

    /**
        @notice Sign up function. 
                o Caller must not already be a member. 
    */
    function signUpAsWasteCollector() public {
       require(!profiles[Category.COLLECTOR][_msgSender()].isRegistered, "Already sign up");
       WasteToWealthLib.registerCollector(profiles, _msgSender());
       IERC20(token).approve(_msgSender(), newSignUpReward);
    }

    /**
        @dev Adds new bin.
            @notice Caller must already be approves as BinOwner .
    */
    function addNewBin() public payable isApproved(Category.BINOWNER, _msgSender()) {
        WasteToWealthLib.registerNewBin(bins, _msgSender());
        binCounter ++;
    }

    /**
        @dev Removes bin at binId.
            @notice Caller must already be approves as BinOwner .
    */
    function removeBin(uint binId) public isApproved(Category.BINOWNER, _msgSender()) {
        address _owner = _getBinOwner(binId);
        if(_msgSender() != owner()) require(_msgSender() == _owner, "Not Authorized");
        
        WasteToWealthLib.removeBin(bins, binId);
    }

    ///@dev Return owner of bin at binId. 
    function _getBinOwner(uint binId) internal view returns(address) {
        return bins[binId].owner;
    }

    /**
        @dev Whitelist user
            Note Admin privilege.
                cat should reference the Category enum.
     */
    function whitelistuser(address who, uint8 category) public onlyOwner validateCategory(category) {
        WasteToWealthLib.setStatus(profiles, who, true, Category(category));
    }

    /**
        @dev Blacklist user
            Note Admin privilege.
                cat should reference the Category enum.
     */
    function blacklistUser(address who, uint8 category) public onlyOwner validateCategory(category){
        WasteToWealthLib.setStatus(profiles, who, false, Category(category));
    }

    /**
        @dev Set new fee
            @notice To perfectly select the right category,
                category parameter should not be greater than 4.
     */
    function setFee(uint8 category, uint newFee) public onlyOwner {
        require(category < 4, "Invalid category");
        signUpFees[Category(category)] = newFee;
    }

    /**
        @dev Generates new waste. 
        @notice Each waste is unique to another.
            Note To successfully generate waste, bin id must be provided.
                    This represents the destination where wastes are dumped.
     */
    function generateWaste(bytes memory _data) public isApproved(Category.GENERATOR, _msgSender()) {
        State state = State.GENERATED;
        totalWasteGenerated ++;
        uint nonce = totalWasteGenerated;
        WasteToWealthLib.portToMap(
            garbages, 
             WasteData(
                keccak256(abi.encodePacked(_data, nonce)), 
                address(0), 
                _msgSender(), 
                address(0),
                state
            ), 
            state
        );
    }

    /**
        @dev Gets approval for user 'who'
            @param cat - Category of user e.g COLLECTOR etc
            @param who - Address of user.
    */
    function _getApproval(Category cat, address who) internal view returns(bool) {
        return profiles[cat][who].approval;
    }

    /**
        @dev Collect waste.
            Note : Only generated waste can be collected
            @param binId - Bin where the waste is located.
            @param wasteId - Which waste to collect.
                    Note - Every waste is unique to another.
     */
    function recycle(uint binId, uint wasteId) internal isApproved(Category.RECYCLER, _msgSender()) validateWasteId(binId, wasteId, State.COLLECTED, "Invalid waste pointer") {
        WasteData memory outWaste = WasteToWealthLib.popFromArray(bins, binId, wasteId);
        WasteToWealthLib.portToMap(garbages, outWaste, State.RECYCLED);
        uint amount = collectorReward;

        (uint collector, uint generator, uint team) = WasteToWealthLib.split(formula, amount);
        IERC20(token).approve(outWaste.collector, collector);
        IERC20(token).approve(outWaste.generator, generator);
        IERC20(token).approve(address(this), team);

    }

    /**@notice Withdraw reward if any
        Note - Caller must have previous reward otherwise it fails.
     */
    function withdraw() public {
        uint rewardBal = IERC20(token).allowance(address(this),_msgSender());
        if(rewardBal == 0) revert NothingToWithdraw();
        IERC20(token).transferFrom(address(this), _msgSender(), rewardBal);
    }

    /**
        @dev Collect waste for disposal. 
            Note: Caller must be an approved waste collector.
                must supply the following:
                    o @param binId - Location of bin to deposit collected waste. ie bin index
                    o @param wasteId - Identifier for waste collected.
     */
    function collectWaste(uint binId, uint wasteId) public isApproved(Category.COLLECTOR, _msgSender()) validateWasteId(binId, wasteId, State.GENERATED, "Invalid waste pointer") {
        require(
            profiles[Category.COLLECTOR][_msgSender()].approval && 
            profiles[Category.COLLECTOR][_msgSender()].isRegistered,
            "Not allowed"
        );
        WasteData memory outWaste = WasteToWealthLib.popFromMapping(garbages, wasteId, State.GENERATED);
        WasteToWealthLib.portToArray(bins, binId, outWaste, State.COLLECTED);

    }

    ///@dev Sets new sign up reward. Note With access modifier
    function setSignUpReward(uint newReward) public onlyOwner{
        newSignUpReward = newReward;
    }

    ///@dev Sets new sign up reward. Note With access modifier
    function setCollectorUpReward(uint newReward) public onlyOwner{
        collectorReward = newReward;
    }


}



// Ticket Created #801750