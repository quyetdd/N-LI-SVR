<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActionFieldUpdate</fullName>
        <field>Field8__c</field>
        <formula>IF( KaiinArea__c &lt;&gt;&quot;&quot;, KaiinArea__c , KazokuArea__c )</formula>
        <name>変更依頼先地区</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>変更依頼先地区</fullName>
        <actions>
            <name>ActionFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ModificationRequest__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
