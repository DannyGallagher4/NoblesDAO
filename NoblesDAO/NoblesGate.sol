pragma solidity >=0.8.2 <0.9.0;

import "./NoblesDAO.sol";

contract NoblesGate{

    address admin;
    address NoblesDAOAddr;
    
    constructor(address contractAddr){
        admin = msg.sender;
        NoblesDAOAddr = contractAddr;
    }

    fallback() external {
        address _impl = NoblesDAOAddr;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function updateAddr(address newAddr) public{
        require(msg.sender == admin);
        NoblesDAOAddr = newAddr;
    }

}