// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*Owner Address: A variable to store the Ethereum address of the owner who can deposit and withdraw funds from the PiggyBank.

Deposit Amount: A variable to keep track of the amount of Ether deposited into the PiggyBank.

Withdrawal Amount: A variable to specify the amount the user can withdraw before the contract self-destructs.

Self-Destruct Trigger: A variable or condition that triggers the self-destruction of the contract when the withdrawal limit is reached.

*/
contract PiggyBank {
    address public owner;

    uint256 depositAmount;

    //mapping(address => uint) balances;
    event EtherReceived(address, uint);
   constructor(){
       owner = msg.sender;
       depositAmount = 0;
   }

   modifier onlyOwner(){
       require(msg.sender == owner, "Only owner can make this call");
       _;
   }

    function deposit() public payable onlyOwner{
        require(msg.value > 0.5 ether, "Deposits should be > 0.5 ether");
        require(msg.sender == owner);
       // balances[msg.sender]+= msg.value;
       depositAmount += msg.value;
       // took out the mapping because there is only 1 address that need to deposit
       // funds will go the contraact itself
    }

    // create a helper function to read the mapping balance/contract

    function getBalance() public view returns(uint){
        return address(this).balance;
        // returns contracts balance
    }

    function withdraw(uint _amount) external onlyOwner {
    require(_amount > 0, "Withdrawal amount must be greater than zero");
    require(_amount <= depositAmount, "Insufficient balance for withdrawal");
    payable(msg.sender).transfer(_amount);
    depositAmount -= _amount;
}


    function destroy() public onlyOwner{
        if(depositAmount <= 0){
            selfdestruct(payable(address(this)));
        }
        else{
           require(depositAmount == 0, "Contract still has ether");
        }
      
    }

    receive() external payable {
        emit EtherReceived(msg.sender, msg.value);
    }

    

}