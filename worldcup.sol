contract  worldcup
{
    //to keep coding simple, leave 0 index as unused;
    //mapping(address => uint256)[33]  public userBetAmountForTeam;
    mapping(address => uint256)[33]  public userBetMultipliedAmountForTeam;
    uint256 public totalAmountForBets;
	uint256[33]  public  totalBetMultipliedAmountForTeam;
    bool isBetClosed = false;
    uint  championTeamId = 0;
    uint  multiplier = 32;  // it actually meanns:how many teams are posssible champion.
    function betFinalChampionForTeam(uint teamId) payable public
    {
        //valid teamId should be 1~32
        require(teamId > 0);
        require(teamId < 33);
        require(!isBetClosed);
        
        totalAmountForBets += msg.value;
        userBetMultipliedAmountForTeam[teamId][msg.sender] += (msg.value * multiplier);
        totalBetMultipliedAmountForTeam[teamId] += (msg.value * multiplier);
        
    }
    function setBetClosed() public
    {
        isBetClosed = true;
    }
    function setChampionTeam(uint teamId)
    {
        require(teamId > 0);
        require(teamId < 33);
        championTeamId = teamId;
    }
    function claimWin() public
    {
        require(championTeamId > 0);
        uint multipliedAmount = userBetMultipliedAmountForTeam[championTeamId][msg.sender];
        if(multipliedAmount > 0)
        {
            userBetMultipliedAmountForTeam[championTeamId][msg.sender] = 0;
            uint winAmount = multipliedAmount * totalAmountForBets / totalBetMultipliedAmountForTeam[championTeamId];
            if(!msg.sender.send(winAmount))
			{
                userBetMultipliedAmountForTeam[championTeamId][msg.sender] = multipliedAmount;
			}
        }
        
    }
    
}
