pragma solidity ^0.5.7;

contract Will{
    address owner;
    uint fortune;
    bool deceased;

    constructor() payable public {
        owner = msg.sender; //represents address being called
        fortune = msg.value; //represents amount of ether being sent
        deceased = false; //
    }

    //create modifier so only peerson that can call the contract is owner
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    //create modifier so that we only allocate funds if owner deceased
    
    modifier mustbeDeceased {
        require(deceased == true);
        _;
    }

    address payable[] familyWallets; //array variables

    mapping(address => uint) inheritance; 
    
    // set inheritance for each address

    function setInheritance(address payable wallet, uint amount) public onlyOwner {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    //pay each family member based on their wallet address

    function payout() private mustbeDeceased{
        for(uint i=0;i<familyWallets.length;i++){
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
            //transferring funds from contract address to receiver address
        }   
    }

    function  hasdecesed() public onlyOwner {
        deceased = true;
        payout();
    }

}
