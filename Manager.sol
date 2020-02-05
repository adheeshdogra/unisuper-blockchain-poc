pragma solidity ^0.5.0;
import './helpers/SafeMath.sol';
import './InvestmentAccount.sol';
<<<<<<< HEAD
import {usingBandProtocol, Oracle} from 'band-solidity/contracts/Band.sol';
=======
import {BandAssetPriceFeed, GenericAssetPrice} from './BandAssetPriceFeed.sol';
>>>>>>> 048a98fbe4dedcceacd3229ed53918fc91fb5423

contract Manager is usingBandProtocol{
    using SafeMath for *;

    mapping  (address => InvestmentAccount) InvestmentAccounts;
    mapping (address => address) SenderToContractAddressMap;
    InvestmentAccount[] arrayOfAccounts;

    constructor () public payable{} //an empty payable contructor to handel the transfer functionality

    function createInvestmentAccount() public payable{
        InvestmentAccount InvestmentAccountContract = new InvestmentAccount();
        // address payable UserAccount = address(InvestmentAccountContract);
        InvestmentAccounts[msg.sender] = InvestmentAccountContract;
        arrayOfAccounts.push(InvestmentAccountContract);
        SenderToContractAddressMap[msg.sender] = address(InvestmentAccountContract);
    }

    function query(string memory _shareName) public payable returns(uint256){
        return FINANCIAL.querySpotPrice(_shareName);
    }

    function sellAssets(uint _debitVal, string memory _shareName, uint256 _ethVal) public payable {
        InvestmentAccounts[msg.sender].deductFromAssets(_shareName,_debitVal, _ethVal);
    }

<<<<<<< HEAD
    function buyAssets(uint _creditVal, string memory _shareName, uint256 _ethVal) public payable {
        InvestmentAccounts[msg.sender].addToAssets.value(_ethVal)(_shareName,_creditVal);
=======
    function query(string memory _shareName) public payable returns(uint){
        GenericAssetPrice assetPriceContract = new BandAssetPriceFeed();
        uint256 price = assetPriceContract.getAssetPrice.value(msg.value)(_shareName, msg.sender);
        return price;
>>>>>>> 048a98fbe4dedcceacd3229ed53918fc91fb5423
    }

    function getNumberOfUnits(string memory _shareName) public view returns (uint){
        return  InvestmentAccounts[msg.sender].getNumberOfUnits(_shareName);
    }

    function withdraw(uint256 _ethVal) public payable {
        uint temp = getContractBalance();
        if (temp >= 0){
            msg.sender.transfer(_ethVal);
            }
        }

    function getContractBalance() public view returns (uint256){
        return address(this).balance;
    }

    function getConAddressOfInvestmentAccount() public view returns (InvestmentAccount[] memory){
        //return address(InvestmentAccounts[msg.sender]);
        return arrayOfAccounts;
        //SenderToContractAddressMap
    }

    function() external payable{}

}