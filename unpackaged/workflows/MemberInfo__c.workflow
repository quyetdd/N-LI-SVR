<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActionFieldUpdate</fullName>
        <field>MemberNo__c</field>
        <formula>CommodityCd__c  &amp;  CountryCodes__c  &amp;  KeiyakuNo__c  &amp; &quot;0&quot;</formula>
        <name>会員番号生成</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>会員番号生成</fullName>
        <actions>
            <name>ActionFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MemberInfo__c.KeiyakuNo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>安心生活退会チェック</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>MemberInfo__c.TaikaiDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MemberInfo__c.InsuranceKind__c</field>
            <operation>equals</operation>
            <value>安心NHST,安心生活</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
