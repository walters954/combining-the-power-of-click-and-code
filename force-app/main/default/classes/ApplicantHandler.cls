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
                Map<String, Object> jobMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(jobApp)); 
                if (jobMap.containsKey(jobAppFieldName)) {
                    tmpLead.put(leadFieldName,jobApp.get(jobAppFieldName));
                }
            }
            System.debug(tmpLead);
            newLeads.add(tmpLead);
        }
            
        insert newLeads;
        return newLeads;
    }
}



//Map<String, Form_to_Lead_Map__mdt> formToLeadFieldMap =Form_to_Lead_Map__mdt.getAll();
//formToLeadFields = formToLeadFieldMap.values();

/*
Job_Application__c[] jobApps = [SELECT Id, Applicant_First_Name__c, Agency__c, Applicant_Last_Name__c 
                                FROM Job_Application__c WHERE Id = 'a092M00001MoYYCQA3'];
ApplicantHandler.createLeadFromApplicant(jobApps);
*/