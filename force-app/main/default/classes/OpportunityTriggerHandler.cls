public class OpportunityTriggerHandler {
    //story 33:
    
    public static void mappingTeamMembers(List<Opportunity> oppRecs){
        Set<Id> oppCenterIds = new Set<Id>();
        for(Opportunity opp:oppRecs){
            if(String.isNotBlank(opp.Center__c)){
            	oppCenterIds.add(opp.Center__c);                
            }
        }
        if(!oppCenterIds.isEmpty()){
        	Map<Id, Center__c> mapVar = new Map<Id, Center__c>([SELECT Id, Name, Asset_Manager__c, Leasing_Admin__c, Leasing_Analyst__c 
                                                          	FROM Center__c WHERE Id IN : oppCenterIds]);
            for(Opportunity opp:oppRecs){
                if(String.isNotBlank(opp.Center__c)){
                opp.Asset_Manager__c = mapVar.get(opp.Center__c).Asset_Manager__c;
                opp.Leasing_Admin__c = mapVar.get(opp.Center__c).Leasing_Admin__c;
                opp.Leasing_Analyst__c = mapVar.get(opp.Center__c).Leasing_Analyst__c;
                }
            }            
        }

    }
    //story 32:
    public static void createContractForWonOpp(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        List<Contract> contList = new List<Contract>();
        for(Opportunity opp:oppList){ //iteration
            if(opp.StageName =='Closed Won' && opp.StageName != oppOldMap.get(opp.Id).StageName){
                Contract cont = new Contract();
                cont.AccountId = opp.AccountId;
                cont.Status = 'Draft';
                cont.Center__c = opp.Center__c;
                cont.Space__c = opp.Space__c;
                cont.Leasing_Admin__c = opp.Leasing_Admin__c;
                cont.Asset_Manager__c = opp.Asset_Manager__c;
                cont.Leasing_Analyst__c = opp.Leasing_Analyst__c;
                cont.StartDate = opp.CloseDate;
                cont.Type__c = opp.Contract_Type__c;
                cont.ContractTerm = opp.Lease_Term__c > 0.0 ? Integer.valueOf(opp.Lease_Term__c) : Integer.valueOf(opp.Short_Term__c);
                contList.add(cont);
                
            }
        }if(!contList.isEmpty()){
	       insert contList;   
        }
    }
}