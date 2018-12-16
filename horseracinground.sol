pragma solidity ^0.5.0;

import "./horsestable.sol";
import "./ownable.sol";

contract HorseRacingRound is HorseStable, Ownable {
    
    event HorseIsReady(uint horseId, string name, address owner, uint maxSpeed, uint vitality);
    event RaceIsOver(uint[] Results);
    
    
    uint numberOfSegments = 10;
    uint numberOfHorses = 4; 
    uint raceLength = 1000; // in meters
    uint decceleration = 10; // in percents
    
    uint[][] history;
    
        function getHistory(uint _raceId) public view returns(uint[] memory) {
            return history[_raceId];
        }
    
    struct ReadyHorse {
        uint id;
        string name;
        address owner;
        uint maxSpeed; // initial speed of a horse
        uint vitality;
    }
    
    ReadyHorse[] public readyHorses;
    
    // Set parameters of th..
    function setNumberOfSegments(uint _numberOfSegments) public onlyOwner {
        numberOfSegments = _numberOfSegments;
    }
    
    function setNumberOfHorses(uint _numberOfHorses) public onlyOwner {
        numberOfHorses = _numberOfHorses;
    }
    
    function setRaceLength(uint _raceLength) public onlyOwner {
        raceLength = _raceLength;
    }
    
    function setDecceleration(uint _newDecceleration) public onlyOwner {
        decceleration = _newDecceleration;
    }
    // ..e race
    
    function getRaceParameters() public view returns(uint, uint, uint, uint) {
        return(numberOfSegments, raceLength, numberOfHorses, decceleration);
    }
    
    // makes a horse ready to race
    function makeHorseReady(uint _horseId) public onlyOwnerOf(_horseId) {
        
        (string memory horseName, uint horseDna, address horseOwner) = HorseStable.getHorseParameters(_horseId);
        
        uint maxSpeed = (horseDna % 10000) / 100 + 1;  // figure out max (initial speed) from 13-14-th bytes in dna
        uint vitality = horseDna % 100 + 1; // figure out vitality from 15-16-th bytes in dna

        
        readyHorses.push(ReadyHorse(_horseId, horseName, horseOwner, maxSpeed, vitality));
        
        emit HorseIsReady(_horseId, horseName, horseOwner, maxSpeed, vitality);
        
        // if the number of ready horses is enough, the race starts:
        if (readyHorses.length == numberOfHorses) {
           history.push(startRace(readyHorses));
        }
    }
    
    // generates rundom number from 1 to 100. It's a temporary randomizer
    function randomBelowHundred(uint _seedNumber) public view returns(uint rand) {
        rand = uint(keccak256(toBytes(now + _seedNumber))) % 100 + 1;
    }
    
    function estimateTimeOnRace(uint _speed, uint _vitality) public view returns(uint) {

        uint raceLengthFemto = raceLength * (10 ** 15); // to handle with lack of float in solidity
        uint segmentLengthFemto = raceLengthFemto / numberOfSegments;
        uint timeOnRaceFemto = segmentLengthFemto / _speed;
        
        for(uint j = 1; j < numberOfSegments; j++) {
                if (_vitality > randomBelowHundred(j + now + _speed + _vitality)) {
                    _speed = _speed;
                } else {
                    _speed = _speed * (100 - decceleration) / 100;
                }
                timeOnRaceFemto = timeOnRaceFemto + segmentLengthFemto / _speed;
            }
            uint timeOnRaceMilli = timeOnRaceFemto / (10 ** 12);
        return timeOnRaceMilli;
    }
    
     function startRace(ReadyHorse[] memory _readyHorses) private returns(uint[] storage results){
        
        for (uint i = 0; i < numberOfHorses; i++) {
            results.push(estimateTimeOnRace(_readyHorses[i].maxSpeed, _readyHorses[i].vitality));
        }
        emit RaceIsOver(results);
        delete readyHorses;
        return results;
    }
}
