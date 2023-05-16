public with sharing class ApplicantHandler {


    public static Lead[] createLeadFromApplicant(Job_Application__c[] applicantions){

        List<Lead> newLeads = new List<Lead>();

        Form_to_Lead_Map__mdt[] formToLeadFields = [SELECT Id, Form_Field_API_Name__c, Lead_Field_API_Name__c 
                                                    FROM Form_to_Lead_Map__mdt WHERE Active__c = true
                                                    WITH SECURITY_ENFORCED];
        

        for (Job_Application__c jobApp : applicantions){

            Lead tmpLead = new Lead();
            for (Form_to_Lead_Map__mdt fieldMap : formToLeadFields){
                String leadFieldName = fieldMap.Lead_Field_API_Name__c;
                String jobAppFieldName = fieldMap.Form_Field_API_Name__c;
                if (jobAppFieldName.contains('.')) {
                    String[] jobAppFieldNames = jobAppFieldName.split('\\.');
                    String jobAppFieldName1 = jobAppFieldNames[0];
                    String jobAppFieldName2 = jobAppFieldNames[1];
                    tmpLead.put(leadFieldName,jobApp.getSObject(jobAppFieldName1).get(jobAppFieldName2));
                } else {
                    tmpLead.put(leadFieldName,jobApp.get(jobAppFieldName));
                }
                
            }
            System.debug(tmpLead);
            newLeads.add(tmpLead);
        }
            
        insert newLeads;
        return newLeads;
    }

    public static void enhanceJobAppData(Job_Application__c[] jobApps){
        Set<Id> candidateIds = new Set<Id>();
        for (Job_Application__c jobApp : jobApps){
            candidateIds.add(jobApp.Candidate__c);
        }
        Map<Id,Candidate__c> candidateMap = new Map<Id,Candidate__c>([SELECT Id, Name, Email__c, Phone__c 
                                                                        FROM Candidate__c 
                                                                        WHERE Id IN :candidateIds]);
        for (Job_Application__c jobApp : jobApps){
            jobApp.Candidate__r = candidateMap.get(jobApp.Candidate__c);
        }                                                                
    }
}



//Map<String, Form_to_Lead_Map__mdt> formToLeadFieldMap =Form_to_Lead_Map__mdt.getAll();
//formToLeadFields = formToLeadFieldMap.values();

/*
Job_Application__c[] jobApps = [SELECT Id, Applicant_First_Name__c, Agency__c, Applicant_Last_Name__c 
                                FROM Job_Application__c WHERE Id = 'a092M00001MoYYCQA3'];
ApplicantHandler.createLeadFromApplicant(jobApps);
*/