<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActionFieldUpdate</fullName>
        <field>OwnerId</field>
        <lookupValue>colin-lee@wellbemedic.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>大使館所有者変更</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>大使館所有者変更</fullName>
        <actions>
            <name>ActionFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.ReceiptLine__c</field>
            <operation>notEqual</operation>
            <value>平安VIP,ハノイアラーム,アラームセンター,メディックBL,BL(医療)</value>
        </criteriaItems>
        <description>アラームセンター,平安VIP,ハノイアラーム,メディックBL,BL(医療)以外</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>平安VIP所有者変更</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.ReceiptLine__c</field>
            <operation>equals</operation>
            <value>平安VIP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
