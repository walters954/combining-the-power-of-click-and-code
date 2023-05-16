public with sharing class ApplicationAction {

    @InvocableMethod(label='Create leads from applications' description='Create leads from application useing custom metadata mapping' category= 'Leads')
    public static List<Lead> processApplications(List<Job_Application__c> applications) {
        ApplicantHandler.enhanceJobAppData(applications);
        List<Lead> newLead = ApplicantHandler.createLeadFromApplicant(applications);
        return newLead;
    }
}