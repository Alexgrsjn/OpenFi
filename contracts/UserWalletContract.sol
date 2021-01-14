pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2; 
contract Ownable {
  address public owner;

  constructor() internal{
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender == owner)
      _;
  }

   function transferOwnership(address newOwner) onlyOwner public{
    if (newOwner != address(0)) owner = newOwner;
  }

}
    
contract UserWalletContract is Ownable{
    mapping(address => uint) public balances;
    string[] walletName;
    address[] walletAddr;
    string[] walletDescription;
    bool[] isMyWallet;
    uint walletCount = 0;
    
    mapping(address => uint) public arrayIndex;

   function initialize(address _owner) public  {
    Ownable(_owner);
  }
    
    function getAllWallets() public returns(string[] memory, address[] memory , string[] memory, bool[] memory, uint)
    {
        
        return(walletName, walletAddr, walletDescription, isMyWallet, walletCount);
    }
    
    function _getWalletIndex(address _addr) internal returns(uint){
        return arrayIndex[_addr];
    }
    
    function addWallet(string memory _walletName, address  _walletAddr, string memory _walletDescription) public  {
       walletName.push(_walletName);
       walletAddr.push(_walletAddr);
       walletDescription.push(_walletDescription);
       isMyWallet.push(false);
       arrayIndex[_walletAddr] = walletCount;
       walletCount++;
    }
    function _validate(address _walletToValidate) internal{
        uint index = arrayIndex[_walletToValidate];
        isMyWallet[index] = true;
    }
    
    function _send(address payable _to, uint256 _value) internal returns (bool) 
    {
        require(_value <= address(this).balance);
        _to.transfer(_value);
        return true;
    }
    function() external payable
    {
       _validateOwnership(msg.sender);
    }
    
    function _validateOwnership(address  _walletToVerify) internal {
        balances[msg.sender] += msg.value;
        if(msg.sender == _walletToVerify){
            _send(msg.sender, msg.value);
            _validate(_walletToVerify);
        }
        
    }

    
}
    