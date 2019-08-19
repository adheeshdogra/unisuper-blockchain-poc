pragma solidity ^0.5.0;

import './helpers/SafeMath.sol';

contract Account {
    using SafeMath for *;

    enum AccountStatusType {
        closed,
        open
    }

    enum AccountAccumulationType {
        Accumulation1,
        Accumulation2,
        DefinedBenefitDivision,
        PersonalAccount,
        Pension
    }

    enum DelegatedPermissionTypes {
        none,
        contributive,
        administrative
    }

    // Most of these variables should be private, and updated through functions that check ownership permissions

    address payable SuperAccountId; // contractID
    address payable EmployeeId; // AccountHolder Address, used for permissions to update private variables
    address public TaxOutputAddress; //Address controlled by UniSuper or ATO
    mapping (address => DelegatedPermissionTypes) public DelegatePermissions; // List of Addresses that are allowed to contribute

    uint public NetBalance;
    uint public TimeTillReward;
    uint public RewardSize;
    uint public PayoutFrequency;


    AccountStatusType public AccountStatus;
    AccountAccumulationType AccountType;

    constructor(address payable employeeId, AccountAccumulationType accountType) public {
        SuperAccountId = address(this);
        EmployeeId = employeeId;
        AccountStatus = AccountStatusType.open;
        AccountType = accountType;
    }


    function increaseRewardSize(uint rewardIncrement) public {
        RewardSize = RewardSize.add(rewardIncrement);
    }

    function decreaseRewardSize(uint rewardIncrement) public {
        RewardSize = RewardSize.sub(rewardIncrement);
    }

    function increasePayoutFrequency(uint payoutFrequencyIncrement) public {
        PayoutFrequency = PayoutFrequency.add(payoutFrequencyIncrement);
    }

    function decreasePayoutFrequency(uint payoutFrequencyIncrement) public {
        PayoutFrequency = PayoutFrequency.sub(payoutFrequencyIncrement);
    }

    function removeAllDelegatePermissions(address thirdPartyAddress) public {
        if(DelegatePermissions[thirdPartyAddress] != DelegatedPermissionTypes.none) {
            DelegatePermissions[thirdPartyAddress] = DelegatedPermissionTypes.none;
        }
    }

    function permitToContributiveOnly(address thirdPartyAddress) public {
        if(DelegatePermissions[thirdPartyAddress] != DelegatedPermissionTypes.none) {
            DelegatePermissions[thirdPartyAddress] = DelegatedPermissionTypes.none;
        }
    }

    function permitToAdmistrative(address thirdPartyAddress) public {
        if(DelegatePermissions[thirdPartyAddress] != DelegatedPermissionTypes.none) {
            DelegatePermissions[thirdPartyAddress] = DelegatedPermissionTypes.none;
        }
    }

    function closeAccount() public {
        require(msg.sender == EmployeeId, 'invalid authorisation');

        AccountStatus = AccountStatusType.closed;
    }

    function transferFunds(address payable recieverAddress, uint amount) public {
        if (msg.sender == EmployeeId && NetBalance < amount) {
            // Add validation that address belongs to a type(SuperAccount)
            NetBalance -= amount;
            recieverAddress.transfer(amount);
        }

        // Add administrative abilities and behaviours

    }

    // Handles exceptions and received payments
    function () external payable {
        // This is bad, we need to add logic in order to handle who sends money to the account and what kind of transaction it is likely to be.
        NetBalance += msg.value;
    }
}