pragma solidity >=0.7.0 <0.9.0;

//the contract allows only its creator to create new coins (different issurance schemes possible).
//anyone can send coins to each other without a need for registering with a username and password, all you need is a ethereum keypair.

contract Coin {
    address public minter;
    mapping (address => uint) public balances;
    // public keyword is making variables accessible by other contracts
    
    event Sent(address from, address to, uint amount);

    constructor() {
        //only runs when we deploy contract
        minter = msg.sender;
    }
    //make new coins and send them to an address
    //only owner can send these coins
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    //send any amount of coin to an existing address

    error insufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if(amount > balances[msg.sender])
        revert insufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        });
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
