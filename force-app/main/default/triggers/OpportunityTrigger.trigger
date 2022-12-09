trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            OpportunityTriggerHandler.mappingTeamMembers(Trigger.new);
        }
    }
    
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
			OpportunityTriggerHandler.createContractForWonOpp(Trigger.new, Trigger.oldMap);
        }
	}
}