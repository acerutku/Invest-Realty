import { LightningElement, api, wire } from 'lwc';
import getChildAccount from '@salesforce/apex/GetAccountContact.getChildAccounts';
import { NavigationMixin } from 'lightning/navigation';

export default class childAccounts extends NavigationMixin(LightningElement) {
    @api recordId;
    
    @wire(getChildAccount, { parentAccId: '$recordId' }) childAccounts;
    
    navigateToRecordViewPage(event) {
        // View a custom object record.
        var recId = event.target.name;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Account', // objectApiName is optional
                actionName: 'view'
            }
        });
    }


}