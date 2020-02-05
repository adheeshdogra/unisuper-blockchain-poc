pragma solidity ^0.5.0;

contract InvestmentAccount{
    address payable public ManagerAddress;
    address payable public AccountId;
    uint256 public NetUserInvestedAmount;

    mapping (string => uint) public AssetPortfolio;

    constructor() public payable{
        ManagerAddress = msg.sender;
        AccountId = address(this);
        NetUserInvestedAmount = 0;
    }


    modifier onlyManager(address){
            require(msg.sender == ManagerAddress, "Invalid Authentication");
        _;
    }

    function addToAssets(string memory _shareName, uint _insertVal) public payable onlyManager(ManagerAddress){
        if(AssetPortfolio[_shareName] == 0){
            AssetPortfolio[_shareName] = _insertVal;
        }
        else {
            uint temp = AssetPortfolio[_shareName];
            temp = temp + _insertVal;
            AssetPortfolio[_shareName] = temp;
        }
    }

    function deductFromAssets(string memory _shareName, uint _deductVal, uint256 _ethVal) public payable onlyManager(ManagerAddress){
        if (_deductVal >= 0){
            uint temp = AssetPortfolio[_shareName];
            temp = temp - _deductVal;
            AssetPortfolio[_shareName] = temp;
            msg.sender.transfer(_ethVal);
        }
    }

    function getNumberOfUnits(string memory _shareName) public view onlyManager(ManagerAddress) returns (uint){
       return  AssetPortfolio[_shareName];
    }

    function getContractBalance() public view returns (uint256){
        return address(this).balance;
    }

    function() external payable{
        NetUserInvestedAmount += msg.value;
    }
}