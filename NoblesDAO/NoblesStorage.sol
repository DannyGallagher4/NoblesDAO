pragma solidity ^0.8.19;

// struct Choice{
//     string option;
//     address[] votes;
// }

struct Poll{
    uint id;
    string name;
    string[] options;
    address[][] votes;
}

contract NoblesStorage{

    address[] public students;
    address[] public teachers;
    address[] public admins;

    Poll[] public activePolls;
    Poll[] public inactivePolls;

    constructor(){
        admins.push(msg.sender);
    }

    function getStudentAddresses() public view returns (address[] memory){
        return students;
    }

    function getTeacherAddresses() public view returns (address[] memory){
        return teachers;
    }

    function getAdminAddresses() public view returns (address[] memory){
        return admins;
    }
    
    function addStudentAddresses(address student) public {
        students.push(student);
    }

    function addTeacherAddresses(address teacher) public {
        teachers.push(teacher);
    }

    function addAdminAddresses(address admin) public {
        admins.push(admin);
    }

    function getActivePolls() public view returns (Poll[] memory){
        return activePolls;
    }

    function setActivePollIndex(uint idx, Poll memory newValue) public{
        activePolls[idx] = newValue;
    }

    function getInactivePolls() public view returns (Poll[] memory){
        return inactivePolls;
    }

    function addActivePoll(Poll memory newPoll) public {
        activePolls.push(newPoll);
    }

    function popActivePoll() public {
        activePolls.pop();
    }

    function addInactivePoll(Poll memory newPoll) public {
        inactivePolls.push(newPoll);
    }

    function addVote(uint pollIndex, uint choiceIndex, address originalCaller) public {
        activePolls[pollIndex].votes[choiceIndex].push(originalCaller);
    }
}