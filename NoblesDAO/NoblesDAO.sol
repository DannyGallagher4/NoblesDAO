pragma solidity >=0.8.2 <0.9.0;

import "./NoblesStorage.sol";
import "./jsmnSol/contracts/JsmnSolLib.sol";

contract NoblesDAO{

    uint counter = 1;
    address admin;
    NoblesStorage public noblesStorage;
    address NoblesStorageAddr;

    mapping(string => function(address) external) public functionMap;
    mapping(string => bool) public isFunctionRegistered;

    constructor(address _noblesStorageAddress) {
        admin = msg.sender;
        noblesStorage = NoblesStorage(_noblesStorageAddress);
        NoblesStorageAddr = _noblesStorageAddress;
    }

    fallback() external {
        string memory jsonString = hexToString(msg.data);
        uint returnCode;
        Token[] memory tokens;
        uint actualNumber;

        (returnCode, tokens, actualNumber) = parse(jsonString, 100);
    }

    function hexToString(bytes memory data) public pure returns (string memory) {
        bytes memory bytesArray = new bytes(data.length);
        for (uint256 i = 0; i < data.length; i++) {
            bytesArray[i] = data[i];
        }
        return string(bytesArray);
    }

    function containsAddress(address[] memory myArray, address _value) public pure returns (bool){
        for (uint i = 0; i < myArray.length; i++) {
            if (myArray[i] == _value) {
                return true;
            }
        }
        return false;
    }

    function updateAddr(address newAddr) public{
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        NoblesStorageAddr = newAddr;
    }

    function addStudentAddress(address newStudent) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getStudentAddresses(), newStudent));
        noblesStorage.addStudentAddresses(newStudent);
    }

    function addTeacherAddress(address newTeacher) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getTeacherAddresses(), newTeacher));
        noblesStorage.addTeacherAddresses(newTeacher);
    }

    function addAdminAddress(address newAdmin) public {
        require(containsAddress(noblesStorage.getAdminAddresses(), msg.sender));
        require(!containsAddress(noblesStorage.getAdminAddresses(), newAdmin));
        noblesStorage.addAdminAddresses(newAdmin);
    }

    function createPoll(address originalCaller, string memory question, string[] memory options) public {
        require(containsAddress(noblesStorage.getTeacherAddresses(), originalCaller));
        address[][] memory myaddrs = new address[][](options.length);
        noblesStorage.addActivePoll(Poll(counter, question, options, myaddrs));
        counter++;
    }
    
    function deletePoll(address originalCaller, uint pollId) public { 
        require(containsAddress(noblesStorage.getTeacherAddresses(), originalCaller)); 
        for (uint p = 0; p < noblesStorage.getActivePolls().length; p++) {
            if (noblesStorage.getActivePolls()[p].id == pollId) {
                noblesStorage.addInactivePoll(noblesStorage.getActivePolls()[p]);
                noblesStorage.setActivePollIndex(p, noblesStorage.getActivePolls()[noblesStorage.getActivePolls().length - 1]);
                noblesStorage.popActivePoll();
                return;
            }
        }
    }

    function vote(address originalCaller, uint pollId, uint optionIndex) public{
        require(containsAddress(noblesStorage.getStudentAddresses(), originalCaller));
        for(uint i = 0; i < noblesStorage.getActivePolls().length; i++){
            if(noblesStorage.getActivePolls()[i].id == pollId){
                for(uint j = 0; j < noblesStorage.getActivePolls()[i].options.length; j++){
                    require(!containsAddress(noblesStorage.getActivePolls()[i].votes[j], originalCaller), "User already voted");
                }
                noblesStorage.addVote(i, optionIndex, originalCaller);
                break;
            }
        }
    }

    function viewPolls(address originalCaller) public view returns (Poll[] memory) {
        require(containsAddress(noblesStorage.getStudentAddresses(), originalCaller) || containsAddress(noblesStorage.getTeacherAddresses(), originalCaller) || containsAddress(noblesStorage.getAdminAddresses(), originalCaller));
        return noblesStorage.getActivePolls();
    }

    function viewCertainPolls(address originalCaller, uint pollId) public view returns (Poll memory) {
        require(containsAddress(noblesStorage.getStudentAddresses(), originalCaller) || containsAddress(noblesStorage.getTeacherAddresses(), originalCaller) || containsAddress(noblesStorage.getAdminAddresses(), originalCaller));
        for (uint i = 0; i < noblesStorage.getActivePolls().length; i++){
            if (noblesStorage.getActivePolls()[i].id == pollId){
                return noblesStorage.getActivePolls()[i];
            }
        }
        revert("Poll not found.");
    }
    

}