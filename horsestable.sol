pragma solidity ^0.5.0;

/// @title A contract for creating players' first horse
/// @author Savva Antonyuk

contract HorseStable {
    
    event NewHorse(uint horseId, string name, uint dna);

    uint8 dnaDigits = 16;
    uint dnaModulus = 10 ** 16;
    uint population = 0;
    string [] takenNames;
    
    struct Horse {
        string name;
        uint dna;
    }
    
    Horse[] public horses;
    
    mapping (uint => address) horseToOwner;
    mapping (address => uint) ownerHorseCount;
    
    modifier onlyOwnerOf(uint _horseId) {
        require(msg.sender == horseToOwner[_horseId]);
        _;
    }
    
    function toBytes(uint256 x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    function _createHorse(string memory _name, uint _dna) internal {
        uint id = horses.push(Horse(_name, _dna)) - 1;
        takenNames.push(_name);
        population++;
        horseToOwner[id] = msg.sender;
        ownerHorseCount[msg.sender]++;
        emit NewHorse(id, _name, _dna);
    }
    
    function _generateRandomDna(string memory _str) private view returns(uint) {
        uint randFromName = uint(keccak256(bytes(_str)));
        uint randFromTime = uint(keccak256(toBytes(now)));
        return (randFromName + randFromTime) % dnaModulus;
    }
    
    function createRandomHorse(string memory _name) public returns(uint) {
        require(ownerHorseCount[msg.sender] == 0);
        for (uint i = 0; i < population; i++) {
            require(keccak256(bytes(_name)) != keccak256(bytes(takenNames[i])));
        }
        uint randDna = _generateRandomDna(_name);
        _createHorse(_name, randDna);
    }
}
