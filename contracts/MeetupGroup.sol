pragma solidity 0.4.24;

import "./zeppelin/lifecycle/Destructible.sol";
import "./blockparty/Conference.sol";

contract MeetupGroup is Destructible {
    string public name;
    string public ens;
    bytes8 public geohash;
    string public category;
    string public description;
    bytes public logo;
    uint public memberCount;

    address[] public events;
    mapping (address => bool) public participants;

    event CreateEvent(address groupId, address eventId, string name, string description, uint date, address userId);
    event JoinGroup(address groupId, address userId, uint memberCount);
    event LeaveGroup(address groupId, address userId, uint memberCount);


    /* Public functions */
    /**
     * @dev Constructor.
     * @param _owner Address of the user that creates the group from factory contract
     * @param _name The name of the meetup group
     * @param _geohash Geohash of the meetup group
     * @param _category Category the meetup group belongs to
     * @param _description Desciption of the meetup group
     * @param _logo IPFS link
     
     */
    constructor (
        address _owner,
        string _name,
        bytes8 _geohash,
        string _category,
        string _description,
        bytes _logo
    ) public {
        require(_owner != 0x0, "Owner needs to be a valid address");
        owner = _owner;

        if (bytes(_name).length != 0){
            name = _name;
        } else {
            name = "Test";
        }

        if (_geohash.length != 0){
            geohash = _geohash;
        } else {
            geohash = 0x0;
        }

        if (bytes(_category).length != 0){
            category = _category;
        } else {
            category = "Tech";
        }

        if (bytes(_description).length != 0){
            description = _description;
        } else {
            description = "Test description";
        }

        if (_logo.length != 0){
            logo = _logo;
        } else {
            logo = "0x0";
        } 
    }

    /**
     * @dev Adds ENS to the contract
     * @param _ens ENS string of meetup
     */
    function addENS(string _ens) public {
        if (bytes(_ens).length != 0){
            ens = _ens;
        } else {
            ens = "test.example.eth";
        }
    }

    /**
     * @dev Creates an event = a Conference smart contract
     * @param _name The name of the event
     * @param _deposit The amount each participant deposits. The default is set to 0.02 Ether. The amount cannot be changed once deployed.
     * @param _limitOfParticipants The number of participant. The default is set to 20. The number can be changed by the owner of the event.
     * @param _coolingPeriod The period participants should withdraw their deposit after the event ends. After the cooling period, the event owner can claim the remining deposits.
     * @param _description Desciption of the event
     * @param _date Timestamp of the event
     * @param _geohash Geohash of the event
     */
    function createEvent (
        string _name,
        uint256 _deposit,
        uint _limitOfParticipants,
        uint _coolingPeriod,
        string _description,
        uint _date,
        bytes8 _geohash
    ) public onlyOwner {
        address conference = new Conference(
            msg.sender,
            _name,
            _deposit,
            _limitOfParticipants,
            _coolingPeriod,
            _description,
            _date,
            _geohash
        );
        events.push(conference);
        emit CreateEvent(this, conference, _name, _description, _date, msg.sender);
    }

    /**
     * @dev Adds a user to the meetup group
     */
    function joinGroup () public {
        participants[msg.sender] = true;
        memberCount++;
        emit JoinGroup(this, msg.sender, memberCount);
    }

    /**
     * @dev Deletes a user from the meetup group
     */
    function leaveGroup () public {
        participants[msg.sender] = false;
        memberCount--;
        emit LeaveGroup(this, msg.sender, memberCount);
    }
}