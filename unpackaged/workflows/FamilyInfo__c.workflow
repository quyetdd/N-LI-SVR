<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActionFieldUpdate</fullName>
        <field>MemberNo__c</field>
        <formula>CommodityCd_txt__c  &amp; CountryCodes__c &amp; KeiyakuNo__c &amp;  FamilyNo__c</formula>
        <name>会員番号（家族）</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>会員番号生成%EF%BC%88家族%EF%BC%89</fullName>
        <actions>
            <name>ActionFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FamilyInfo__c.KeiyakuNo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
