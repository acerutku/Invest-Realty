import { LightningElement, api, wire } from 'lwc';
import getChildContact from '@salesforce/apex/GetAccountContact.getRelatedContacts';
import { NavigationMixin } from 'lightning/navigation';

export default class ChildContact extends NavigationMixin(LightningElement){
    @api accId;    

@wire(getChildContact, { childAccId: '$accId' }) relatedContacts;

    navigateToRecordViewPage(event) {
    // View a custom object record.
    var recId = event.target.name;
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recId,
            objectApiName: 'Contact', // objectApiName is optional
            actionName: 'view'
        }
    });
}


}