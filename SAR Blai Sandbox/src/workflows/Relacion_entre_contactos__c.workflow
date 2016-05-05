<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aviso_propietarios_en_cuenta_y_contacto_distintos</fullName>
        <description>Aviso propietarios en cuenta y contacto distintos</description>
        <protected>false</protected>
        <recipients>
            <field>Email_propietario_emrpesa__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_contacto/Propietarios_cuenta_y_contacto_diferentes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Actualizar_campo_control_duplicados_1</fullName>
        <field>Control_duplicados_1__c</field>
        <formula>Contacto__r.Id    &amp; &apos; &apos; &amp;   Residente__r.Id &amp; &apos; &apos; &amp;
 Contacto_Recomendador__r.Id     &amp; &apos; &apos; &amp;    Empresa_recomendadora__r.Id</formula>
        <name>Actualizar campo control duplicados 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Informar_email_propietario_cuenta</fullName>
        <field>Email_propietario_emrpesa__c</field>
        <formula>Empresa_recomendadora__r.Owner.Email</formula>
        <name>Informar email propietario cuenta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Control familiares duplicados</fullName>
        <actions>
            <name>Actualizar_campo_control_duplicados_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Relacion_entre_contactos__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Relación Recomendadores,Relación Familiar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Relacion_entre_contactos__c.Ultima_Mod__c</field>
            <operation>notEqual</operation>
            <value>GCR</value>
        </criteriaItems>
        <description>Control de relaciones familiares duplicadas</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Propietario de contacto y cuenta diferentes</fullName>
        <actions>
            <name>Aviso_propietarios_en_cuenta_y_contacto_distintos</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Informar_email_propietario_cuenta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Contacto_Recomendador__r.Owner.Email &lt;&gt;  Empresa_recomendadora__r.Owner.Email</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
