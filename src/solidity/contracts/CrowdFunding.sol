//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract CrowdFunding{
    //state variable
    address public Manager;
    uint256 totalFunds;
    uint256 start;
    uint256 end;
    uint256 public counter;
    
  //Struct
    struct Project{
        uint256 id;
        address payable owner;
        string projectName;
        string description;
        uint256 expectedCost;
        uint256 isRegistered;
        uint256 isVerified;
        uint256 fundedAmt;
        uint256 fundWithdraw;
    }
        
    constructor(uint256 _duration){
        Manager = msg.sender;
        start = block.timestamp;
        end = (_duration * 1 days) + start;
    }
    
    //mappings
    mapping(address => uint256)public ProjectId;
    mapping(uint256 => Project) public Projects;
    mapping(uint256 => uint256) public ProjectFunds;
    
     //events
    event ProjectRegistered(uint256 _id,uint256 _rtime,string _name,address _owner);
    event ProjectIsVerified(uint256 _pid,uint256 _time);
    event FundsTransferred(uint256 _pid,uint256 _time,address _from,uint256 _fund);
    event FundsWithdrawn(uint256 _pid,uint256 _time,address _to,uint256 _fund);
    
   //modifiers
    modifier onlyManager(){
        require(msg.sender==Manager,"You are not Manager");
        _;
    }
    
    //functions
    function regProject(string memory _pName,string memory _desc,uint256 _cost) public {
        require(block.timestamp < end, "Duration is over");
        require(msg.sender != Manager && ProjectId[msg.sender]== 0,"Manager and existing owners of projects not able to register again");
        counter++;
        Project memory pro = Project(counter,payable (msg.sender),_pName,_desc,_cost,1,0,0,0);
        ProjectId[msg.sender] = counter;
        Projects[counter]  = pro;
        emit ProjectRegistered(counter, block.timestamp, _pName, msg.sender);
    }
    
    function verifyProject(uint256 _id) public onlyManager() {
        Projects[_id].isVerified = 1;
        emit ProjectIsVerified(_id,block.timestamp);
    }
    
    function viewProject(uint256 _id) public view returns(uint256,address,string memory,string memory,uint256,uint256,uint256){
        require(Projects[_id].isVerified == 1,"Project is not verified");
        return (
        Projects[_id].id,
        Projects[_id].owner,
        Projects[_id].projectName,
        Projects[_id].description,
        Projects[_id].expectedCost,
        Projects[_id].isRegistered,
        Projects[_id].fundedAmt
        );
    }
    
    function TimeLeft() public view returns(uint256) {
        require(block.timestamp <= end, "The funding duration is over");
        return end - block.timestamp;
    }
    
    function sendFunds(uint256 _id) payable public  {
        require(block.timestamp < end, "The funding duration is over");
        require(Projects[_id].isVerified == 1 && msg.sender != Projects[_id].owner && Projects[_id].fundWithdraw == 0,"you are owner or project is unverified");
        Projects[_id].fundedAmt += msg.value;
        totalFunds++;
        ProjectFunds[_id] = msg.value;
        emit FundsTransferred(_id,block.timestamp,msg.sender,msg.value);
    }
    
    function contractBal() public view returns(uint256){
        return address(this).balance;
    }
    
    function withdrawFunds(uint256 _id) public payable {
        require(block.timestamp > end, "The funding duration is not over yet");
        require(msg.sender == Projects[_id].owner,"You are not owner of this project");
        address payable add = Projects[_id].owner;
        Projects[_id].fundedAmt-=ProjectFunds[_id];
        add.transfer(ProjectFunds[_id]);
        Projects[_id].fundWithdraw +=ProjectFunds[_id];
        emit FundsWithdrawn(_id,block.timestamp,add,ProjectFunds[_id]);
    }
}