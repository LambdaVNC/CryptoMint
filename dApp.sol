// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Coin {

    // Define the minter but its should be coin owner
    address public minter;
    // Mapping for tx log
    mapping(address => uint) public balances;

    // Share info to external
    event Sent(address from, address to, uint amount);

    // Only owner pass the function
    modifier onlyOwner(){
        require(msg.sender == minter, "Only owner!");
        _;
    } 

    // Constructor code is run only one time when contract is created
    constructor() {
        minter = msg.sender;
    }

    // Errors allow you to provide information about
    error insufficentBalance(uint requested, uint available);

    // Sends an amount of newly created coins to an adress
    // Can only be called by contract creator
    function mining(uint amount) public onlyOwner{
        balances[address(this)] += amount;
    }  

    // Withdrawal your coin
    function withdrawal(address withdrawalAccount,uint amount)public onlyOwner{
        balances[address(this)] -= amount;
        balances[withdrawalAccount] += amount;
    }
    
    // See how many coin have on this contract
    function accountBalanceOfContract() public view onlyOwner returns(uint){
        return balances[address(this)];
    }

    // Sends an amount of existing coins
    // From any caller to an address
    function send(address receiver, uint amount)public {
        if(amount > balances[msg.sender]){
            revert insufficentBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}

