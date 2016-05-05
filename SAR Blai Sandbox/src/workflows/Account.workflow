<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aprobacion_cambio_tipo_recomendador</fullName>
        <description>Aprobación cambio tipo recomendador</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_cuentas/Aprobacion_cambio_tipo_recomendador</template>
    </alerts>
    <alerts>
        <fullName>Informar_bloqueo_inicial</fullName>
        <description>Informar bloqueo inicial</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_cuentas/Bloqueo_cambio_tipo_recomendador</template>
    </alerts>
    <alerts>
        <fullName>Nuevo_centro_creado</fullName>
        <description>Nuevo centro creado</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_Comercial</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_cuentas/Nuevo_Centro</template>
    </alerts>
    <alerts>
        <fullName>Rechazo_tipo_recomendador</fullName>
        <description>Rechazo tipo recomendador</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_cuentas/Rechazo_cambio_tipo_recomendador</template>
    </alerts>
    <alerts>
        <fullName>enviar_email</fullName>
        <description>enviar email</description>
        <protected>false</protected>
        <recipients>
            <recipient>sarquavitae@konozca.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_contacto/Propietarios_cuenta_y_contacto_diferentes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Actualizar_aniversario2</fullName>
        <field>Fecha_aviso_Aniversario2__c</field>
        <formula>if( today()+10&lt;date(year(today()),month( PersonBirthdate ),day(PersonBirthdate)), 
date(year(today()),month(PersonBirthdate),day(PersonBirthdate))
,date(year(today())+1,month(PersonBirthdate),day(PersonBirthdate)))</formula>
        <name>Actualizar aniversario2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_campo_Aprobado</fullName>
        <description>Se actualiza el campo &quot;Estado convenio&quot; a &quot;Aprobado&quot;</description>
        <field>Estado_convenio__c</field>
        <formula>&apos;Aprobado&apos;</formula>
        <name>Actualizar campo Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_campo_Rechazado</fullName>
        <description>Se actualiza el campo &quot;Estado convenio&quot;</description>
        <field>Estado_convenio__c</field>
        <formula>&apos;Rechazado&apos;</formula>
        <name>Actualizar campo Rechazado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsApi_false</fullName>
        <field>IsAPI__c</field>
        <literalValue>0</literalValue>
        <name>IsApi false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mod_Loc_true</fullName>
        <field>Actualizar_direccion__c</field>
        <literalValue>0</literalValue>
        <name>Mod Loc true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cambio direccion</fullName>
        <actions>
            <name>Mod_Loc_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Ciudad__c ), 
ISCHANGED( Codigo_postal__c ), 
ISCHANGED( Calle__c ), 
ISCHANGED( Pais__c ), 
ISCHANGED( Provincia__c ), 
ISCHANGED( Pais__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Informar Clas Tipo Recom RES</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contacto Recomendador</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Residencial__c</field>
            <operation>equals</operation>
            <value>Verdadero</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Nuevo Centro</fullName>
        <actions>
            <name>Nuevo_centro_creado</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Activo__c</field>
            <operation>equals</operation>
            <value>Verdadero</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Centro</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
