pragma solidity >=0.7.0 < 0.9.0;
//Decentralized voting Application
contract Ballot {
    struct Voter {
        uint vote; //vote index
        bool voted;//voted or not
        uint weight;//weight of vote
    }

    struct Proposal {
        //bytes are basic unit of measurement of information in computer
        //bytes32 is better than string as it saves memory and thus gas fee
        string name; //name of the proposal
        uint voteCount; //no of accummulated votes
    }

    Proposal[] public proposals; //array of Proposal structure objects

    //mapping allows us to create a store value with keys and indexes
    mapping(address => Voter) public voters; //voters gets address as a key and Voter for value

    address public chairperson;

    constructor(string[] memory proposalNames) {
        //memory defines a temporary data location in solidity during run time only of methods
        //memory vs storage

        //Only chairperson can access the contract call
        chairperson = msg.sender;

        //add 1 to chairperson weight
        voters[chairperson].weight = 1;

        //Will add the proposal names to the smart contract upon deployement
        for(uint i=0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    //function to authenticate voters

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson,'Only the Chairperson can give access to vote');
        //require that voter has not already voted
        require(!voters[voter].voted,'Voter has already voted');
        require(voters[voter].weight == 0);

        voters[voter].weight = 1;

    }

    //function for voting

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender]; 
        require(sender.weight != 0, 'Has no right to vote');
        require(!sender.voted, 'Already Voted');
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    //functions for showing results

    function winningProposal() public view returns(uint winningProposal_) {
        //function that returns winning proposal by integer
        uint winningVoteCount = 0;
        for(uint i=0; i < proposals.length; i++) {
            if(proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    function winningName() public view returns (string memory winningName_) {
        //function that shows name of the winning proposal
        winningName_ = proposals[winningProposal()].name;
    }

    function winningCount() public view returns (uint winningCount_) {
        //function that shows name of the winning proposal
        winningCount_ = proposals[winningProposal()].voteCount;
    }

}
