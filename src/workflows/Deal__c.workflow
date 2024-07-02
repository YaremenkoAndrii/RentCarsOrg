<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>One_day_before_rent_end</fullName>
        <ccEmails>andrii.yaremenko.sfdev@gmail.com</ccEmails>
        <description>One day before rent end</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>andrii.yaremenko.sfdev@wise-bear-vfrl8u.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CommerceReorderPortalInvitation</template>
    </alerts>
</Workflow>
