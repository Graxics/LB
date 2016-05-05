<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Actualizar_Estado_Tarea</fullName>
        <field>Status</field>
        <literalValue>Completada</literalValue>
        <name>Actualizar Estado Tarea</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_tipo_de_registro</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Tarea_Recomendador</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar tipo de registro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test2</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Tarea_Recomendador</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Test2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test_1</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Tarea_Recomendador</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>test 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cerrar Tarea</fullName>
        <actions>
            <name>Actualizar_Estado_Tarea</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>CAT - Información</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
