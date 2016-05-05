<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aviso_creacion_nueva_ASR</fullName>
        <description>Aviso creación nueva ASR</description>
        <protected>false</protected>
        <recipients>
            <field>Email_ATC_centro__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_director_centro__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASR/Aviso_nueva_ASR_de_CAT</template>
    </alerts>
    <fieldUpdates>
        <fullName>Email_ATC_centro</fullName>
        <field>Email_ATC_centro__c</field>
        <formula>Centro__r.ATC_Centro__r.Email</formula>
        <name>Email ATC centro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_director_centro</fullName>
        <field>Email_director_centro__c</field>
        <formula>Centro__r.Director_del_centro__r.Email</formula>
        <name>Email director centro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ASR de CAT %28Act emails%29</fullName>
        <actions>
            <name>Email_ATC_centro</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_director_centro</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>CAT</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Tipo__c</field>
            <operation>equals</operation>
            <value>Sugerencia,Reclamación,Incidencia</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Email_director_centro__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASR de CAT %28Envio email%29</fullName>
        <actions>
            <name>Aviso_creacion_nueva_ASR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>CAT</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Tipo__c</field>
            <operation>equals</operation>
            <value>Sugerencia,Reclamación,Incidencia</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Email_director_centro__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Recordatorio contestar ASR</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ASR__c.CreatedDate</field>
            <operation>equals</operation>
            <value>HOY</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Tipo__c</field>
            <operation>equals</operation>
            <value>Sugerencia,Reclamación,Incidencia</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASR__c.Estado__c</field>
            <operation>equals</operation>
            <value>Abierta</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Recordatorio_contestar_ASR</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ASR__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Recordatorio_contestar_ASR</fullName>
        <assignedToType>owner</assignedToType>
        <description>Recuerde contestar la ASR en un plazo máximo de 5 días</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>ASR__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Recordatorio contestar ASR</subject>
    </tasks>
</Workflow>