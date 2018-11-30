pragma solidity ^0.5.0;

contract HorseStable {
    
    event NewHorse(uint horseId, string name, uint dna);

    uint8 dnaDigits = 16;
    uint dnaModulus = 10 ** 16;
    
    struct Horse {
        string name;
        uint dna;
    }
    
    Horse[] public horses;
    
    mapping (uint => address) horseToOwner;
    mapping (address => uint) ownerHorseCount;
    
    function _createHorse(string memory _name, uint _dna) internal {
        uint id = horses.push(Horse(_name, _dna)) - 1;
        horseToOwner[id] = msg.sender;
        ownerHorseCount[msg.sender]++;
        emit NewHorse(id, _name, _dna);
    }
    
    function toBytes(uint256 x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    function _generateRandomDna(string memory _str) private view returns(uint) {
        uint randFromName = uint(keccak256(bytes(_str)));
        uint randFromTime = uint(keccak256(toBytes(now)));
        return (randFromName + randFromTime) % dnaModulus;
    }
    
    function createRandomHorse(string memory _name) public {
        require(ownerHorseCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createHorse(_name, randDna);
    }
}