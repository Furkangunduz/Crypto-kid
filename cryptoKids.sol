// SPDX-License-Identifier: unlicensed

pragma solidity >=0.7.0 <0.9.0;

contract CryptoKids {
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"You must be owner");
        _;
    }

    struct Kid { 
        address payable walletAdress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public kids;

    function  addKid(address payable walletAdress,  string memory firstName,  string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner {
        kids.push(
            Kid(walletAdress,
                firstName,
                lastName,
                releaseTime,
                amount,
                canWithdraw));
        
    }

    function balanceOf() public view returns (uint){
        return address(this).balance;
    }

    function deposit(address walletAdress) payable public {
        addKidsBalance(walletAdress);
    }   

    function addKidsBalance (address walletAdress) private onlyOwner{
        for(uint i  = 0; i<kids.length; i++){
            if(kids[i].walletAdress == walletAdress){
                kids[i].amount += msg.value;
            }
        }
    }

    function getIndex(address walletAdress) public view returns(uint) {
        for( uint i=0;i<kids.length;i++){
            if(kids[i].walletAdress == walletAdress){
                return i;
            }
        }
        return 999;
    }

    function avaliableWithdraw(address walletAdress) public returns(bool){
        uint i = getIndex(walletAdress);
        if(block.timestamp  > kids[i].releaseTime ){
            kids[i].canWithdraw = true;
            return true;
        }else{
            return false;
        }
    }

    function withdraw(address walletAdress) payable public {
        uint i = getIndex(walletAdress);
        require(msg.sender == kids[i].walletAdress, "You are not a owner.");
        require(kids[i].canWithdraw == true, "You are not able to withdraw.");

        kids[i].walletAdress.transfer(kids[i].amount);
    }
}
