<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Calcular_descuento_Dispositivo</fullName>
        <field>Descuento_Dispositivo__c</field>
        <formula>1-(  Precio_Dispositivo__c /  Tarifa_TA__r.Precio_dispositivo__c )</formula>
        <name>Calcular descuento Dispositivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Periodo_1</fullName>
        <field>Descuento_Periodo_1__c</field>
        <formula>1-( Importe_Periodo_1__c / Tarifa_TA__r.Precio_servicio__c )</formula>
        <name>Calcular descuento Periodo 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Periodo_2</fullName>
        <field>Descuento_Periodo_2__c</field>
        <formula>1-( Importe_Periodo_2__c / Tarifa_TA__r.Precio_servicio__c )</formula>
        <name>Calcular descuento Periodo 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Periodo_3</fullName>
        <field>Descuento_Periodo_3__c</field>
        <formula>1-( Importe_Periodo_3__c / Tarifa_TA__r.Precio_servicio__c )</formula>
        <name>Calcular descuento Periodo 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_UCR</fullName>
        <field>Descuento__c</field>
        <formula>1-(  Precio__c /  Tarifa_TA__r.Precio_ucr_adicional__c )</formula>
        <name>Calcular descuento UCR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_Dispositivo</fullName>
        <field>Precio_Dispositivo__c</field>
        <formula>Tarifa_TA__r.Precio_dispositivo__c*(1- Descuento_Dispositivo__c )</formula>
        <name>Calcular importe Dispositivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_Periodo_1</fullName>
        <field>Importe_Periodo_1__c</field>
        <formula>Tarifa_TA__r.Precio_servicio__c *(1- Descuento_Periodo_1__c)</formula>
        <name>Calcular importe Periodo 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_Periodo_2</fullName>
        <field>Importe_Periodo_2__c</field>
        <formula>Tarifa_TA__r.Precio_servicio__c *(1- Descuento_Periodo_2__c)</formula>
        <name>Calcular importe Periodo 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_Periodo_3</fullName>
        <field>Importe_Periodo_3__c</field>
        <formula>Tarifa_TA__r.Precio_servicio__c *(1- Descuento_Periodo_3__c)</formula>
        <name>Calcular importe Periodo 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_UCR</fullName>
        <field>Precio__c</field>
        <formula>Tarifa_TA__r.Precio_ucr_adicional__c *(1- Descuento__c)</formula>
        <name>Calcular importe UCR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Calcular descuento Dispositivo</fullName>
        <actions>
            <name>Calcular_descuento_Dispositivo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Precio_Dispositivo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Dispositivo__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Periodo 1</fullName>
        <actions>
            <name>Calcular_descuento_Periodo_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Periodo 2</fullName>
        <actions>
            <name>Calcular_descuento_Periodo_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Periodo 3</fullName>
        <actions>
            <name>Calcular_descuento_Periodo_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_3__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento UCR</fullName>
        <actions>
            <name>Calcular_descuento_UCR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Precio__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe Dispositivo</fullName>
        <actions>
            <name>Calcular_importe_Dispositivo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Precio_Dispositivo__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Dispositivo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe Periodo 1</fullName>
        <actions>
            <name>Calcular_importe_Periodo_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe Periodo 2</fullName>
        <actions>
            <name>Calcular_importe_Periodo_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe Periodo 3</fullName>
        <actions>
            <name>Calcular_importe_Periodo_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Importe_Periodo_3__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento_Periodo_3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe UCR</fullName>
        <actions>
            <name>Calcular_importe_UCR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Centros_NOC__c.Precio__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Centros_NOC__c.Descuento__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
