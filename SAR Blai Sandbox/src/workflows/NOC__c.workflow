<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AprobaciOn_NOC2</fullName>
        <description>Aprobación NOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Aprobacion</template>
    </alerts>
    <alerts>
        <fullName>Aprobacion_NOC</fullName>
        <description>Aprobación NOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Aprobacion</template>
    </alerts>
    <alerts>
        <fullName>CORREO_LA_NOC_TARIFA_ESTA_APROBADA</fullName>
        <description>CORREO LA NOC TARIFA ESTA APROBADA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Solicitud_de_aprobaci_n</template>
    </alerts>
    <alerts>
        <fullName>Enviar_Email_a_propietario_cuenta_por_nuevo_NOC_aprobada</fullName>
        <description>Enviar Email a propietario cuenta por nuevo NOC aprobada</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Aprobacion</template>
    </alerts>
    <alerts>
        <fullName>Enviar_Email_a_propietario_cuenta_por_nuevo_NOC_aprobada2</fullName>
        <description>Enviar Email a propietario cuenta por nuevo NOC aprobada</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Aprobacion</template>
    </alerts>
    <alerts>
        <fullName>Finalizaci_n</fullName>
        <description>Finalización</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>brmerce@sarquavitae.es</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Finalizacion_NOC2</template>
    </alerts>
    <alerts>
        <fullName>Rechazo_NOC</fullName>
        <ccEmails>cristina.andinach@konozca.com</ccEmails>
        <description>Rechazo NOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_NOCs/Rechazo</template>
    </alerts>
    <alerts>
        <fullName>Rechazo_NOC2</fullName>
        <description>Rechazo NOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sqsos@sarquavitae.es</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WF_NOCs/Rechazo</template>
    </alerts>
    <alerts>
        <fullName>alerta_email_aprovacion_NOC_tarifa</fullName>
        <description>alerta email aprovacion NOC tarifa</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Solicitud_de_aprobaci_n</template>
    </alerts>
    <fieldUpdates>
        <fullName>Actualizaci_n_Estado_Cam0pa_a_Creada</fullName>
        <field>Estado_Campana__c</field>
        <literalValue>Creada</literalValue>
        <name>Actualización Estado Cam0paña (Creada)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizacion_Estado_Campa_a_Cerrada</fullName>
        <field>Estado_Campana__c</field>
        <literalValue>Cerrada</literalValue>
        <name>Actualización Estado Campaña (Cerrada)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_campo_Estado_campa_a</fullName>
        <field>Estado_Campana__c</field>
        <literalValue>Abierta</literalValue>
        <name>Actualizar campo Estado campaña</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_descuento</fullName>
        <field>Descuento_aplicado__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp;  NOT(ISBLANK( Nueva_Tarifa__c )) ,
1-( Precio_propuesto__c /   Nueva_Tarifa__r.Precio__c  ),
1-( Precio_propuesto__c /  Tarifa_oficial__c ))</formula>
        <name>Actualizar descuento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Actualizar estado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo2</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo3</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Pendiente</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo4</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Pendiente</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo5</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_flujo6</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Actualizar estado flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_estado_rechazo</fullName>
        <field>Estado_Flujo__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Actualizar estado rechazo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_fecha_fin_flujo</fullName>
        <field>Fecha_fin_flujo__c</field>
        <formula>Today()</formula>
        <name>Actualizar fecha fin flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_fecha_fin_flujo2</fullName>
        <field>Fecha_fin_flujo__c</field>
        <formula>Today()</formula>
        <name>Actualizar fecha fin flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_fecha_fin_flujo3</fullName>
        <field>Fecha_fin_flujo__c</field>
        <formula>TODAY()</formula>
        <name>Actualizar fecha fin flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_fecha_fin_flujo4</fullName>
        <field>Fecha_fin_flujo__c</field>
        <formula>TODAY()</formula>
        <name>Actualizar fecha fin flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_idContrato</fullName>
        <field>Id_contrato__c</field>
        <formula>Oportunidad_renegociada__r.Id_contrato__c</formula>
        <name>Actualizar idContrato</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_1</fullName>
        <field>Importe_Mes_1__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1-  Descuento_Mes_1__c ), 
Tarifa_oficial__c * (1-  Descuento_Mes_1__c ))</formula>
        <name>Actualizar importe descuento Mes 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_2</fullName>
        <field>Importe_Mes_2__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1- Descuento_Mes_2__c ), 
Tarifa_oficial__c * (1- Descuento_Mes_2__c ))</formula>
        <name>Actualizar importe descuento Mes 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_3</fullName>
        <field>Importe_Mes_3__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1- Descuento_Mes_3__c ), 
Tarifa_oficial__c * (1- Descuento_Mes_3__c ))</formula>
        <name>Actualizar importe descuento Mes 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_4</fullName>
        <field>Importe_Mes_4__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1- Descuento_Mes_4__c ), 
Tarifa_oficial__c * (1- Descuento_Mes_4__c ))</formula>
        <name>Actualizar importe descuento Mes 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_5</fullName>
        <field>Importe_Mes_5__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1- Descuento_Mes_5__c ), 
Tarifa_oficial__c * (1- Descuento_Mes_5__c ))</formula>
        <name>Actualizar importe descuento Mes 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_importe_descuento_Mes_6</fullName>
        <field>Importe_Mes_6__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK(Nueva_Tarifa__c )), 
Nueva_Tarifa__r.Precio__c * (1- Descuento_Mes_6__c ), 
Tarifa_oficial__c * (1- Descuento_Mes_6__c ))</formula>
        <name>Actualizar importe descuento Mes 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_precio_propuesto</fullName>
        <field>Precio_propuesto__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos;  &amp;&amp;  NOT(ISBLANK(Nueva_Tarifa__c )),  
 Nueva_Tarifa__r.Precio__c  * (1- Descuento_aplicado__c ),
 Tarifa_oficial__c * (1- Descuento_aplicado__c ))</formula>
        <name>Actualizar precio propuesto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaridContrato</fullName>
        <field>Id_contrato__c</field>
        <formula>idContratoOp__c</formula>
        <name>Actualizar_idContrato</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Importe_3</fullName>
        <field>Descuento_Mes_2__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-(  Importe_Mes_2__c / Nueva_Tarifa__r.Precio__c ), 
1-(  Importe_Mes_2__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Mes_1</fullName>
        <field>Descuento_Mes_1__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-(  Importe_Mes_1__c / Nueva_Tarifa__r.Precio__c ), 
1-(  Importe_Mes_1__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Mes_3</fullName>
        <field>Descuento_Mes_3__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-( Importe_Mes_3__c / Nueva_Tarifa__r.Precio__c ), 
1-( Importe_Mes_3__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Mes_4</fullName>
        <field>Descuento_Mes_4__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-( Importe_Mes_4__c / Nueva_Tarifa__r.Precio__c ), 
1-( Importe_Mes_4__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Mes_5</fullName>
        <field>Descuento_Mes_5__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-( Importe_Mes_5__c / Nueva_Tarifa__r.Precio__c ), 
1-( Importe_Mes_5__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_descuento_Mes_6</fullName>
        <field>Descuento_Mes_6__c</field>
        <formula>IF( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal_Renegociado&apos; &amp;&amp; NOT(ISBLANK( Nueva_Tarifa__c )) , 
1-( Importe_Mes_6__c / Nueva_Tarifa__r.Precio__c ), 
1-( Importe_Mes_6__c / Tarifa_oficial__c ))</formula>
        <name>Calcular descuento Mes 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcular_importe_fianza</fullName>
        <field>Importe_Fianza_a_cobrar__c</field>
        <formula>Nueva_tarifa_oficial__c * Fianza_a_cobrar__c</formula>
        <name>Calcular importe fianza</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESTADO_APROBADO</fullName>
        <description>ESTADO FLUJO A APROBADO</description>
        <field>Estado_Flujo__c</field>
        <literalValue>Aprobado</literalValue>
        <name>ESTADO APROBADO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESTADO_RECHAZADO</fullName>
        <description>ESTADO FLUJO A RECHAZADO</description>
        <field>Estado_Flujo__c</field>
        <literalValue>Rechazado</literalValue>
        <name>ESTADO RECHAZADO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Visibildad_NOC</fullName>
        <field>Visibilidad_Centros_1__c</field>
        <formula>if( RecordType.DeveloperName=&apos;NOC_11_Descuento_Personal&apos;, Oportunidad__r.Centro2__r.IdNAV__c , Oportunidad_renegociada__r.Centro2__r.IdNAV__c)</formula>
        <name>Visibildad NOC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>actualizar_numero_plazas_libres</fullName>
        <field>Numero_de_plazas_libres__c</field>
        <formula>Numero_de_plazas__c</formula>
        <name>actualizar numero plazas libres</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>frcha_fin_flujo</fullName>
        <field>Fecha_fin_flujo__c</field>
        <formula>today()</formula>
        <name>frcha fin flujo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualización Estado Campaña %28Abierta%29</fullName>
        <actions>
            <name>Actualizar_campo_Estado_campa_a</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name=&apos;NOC 9 Comunicaciones, presentaciones y campañas&apos; &amp;&amp;  Fecha_inicio__c &lt;=today()  &amp;&amp;  Fecha_fin__c &gt;=today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualización Estado Campaña %28Cerrada%29</fullName>
        <actions>
            <name>Actualizacion_Estado_Campa_a_Cerrada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>RecordType.Name  = &apos;NOC 9 Comunicaciones, presentaciones y campañas&apos; &amp;&amp;  Fecha_fin__c  &lt;  TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualización Estado Campaña %28Creada%29</fullName>
        <actions>
            <name>Actualizaci_n_Estado_Cam0pa_a_Creada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name=&apos;NOC 9 Comunicaciones, presentaciones y campañas&apos; &amp;&amp; Fecha_inicio__c &gt;today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto</fullName>
        <actions>
            <name>Actualizar_precio_propuesto</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Descuento_aplicado__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes1</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_1__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes2</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_2__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes3</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_3__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes4</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_4__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes5</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_5__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar precio propuesto Mes6</fullName>
        <actions>
            <name>Actualizar_importe_descuento_Mes_6</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Descuento_Mes_6__c ))  &amp;&amp;   (RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos; ||  RecordType.Name=&apos;NOC 11 Descuento Personal Renegociado&apos;)  &amp;&amp; IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;, NOT( ISNULL( Oportunidad__r.Precio__c )), NOT(ISNULL( Oportunidad_renegociada__r.Precio__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar_idContrato</fullName>
        <actions>
            <name>ActualizaridContrato</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NOC__c.idContratoOp__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Aiso enviar convenio original firmado</fullName>
        <actions>
            <name>Recordatorio_Enviar_convenio_firmado</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name=&apos;NOC 12 Convenios&apos; &amp;&amp;  ISPICKVAL( Estado_Flujo__c , &apos;Aprobado&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Aviso finalización NOC</fullName>
        <active>false</active>
        <formula>(RecordType.Name = &apos;NOC 11 Descuento General Centro&apos; || RecordType.Name = &apos;NOC 9 Comunicaciones, presentaciones y campañas&apos;) &amp;&amp; NOT(ISBLANK(Fecha_fin__c)) &amp;&amp; ISPICKVAL(Estado_Flujo__c , &apos;Aprobado&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Finalizaci_n</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NOC__c.Fecha_fin__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Aviso finalización NOC %2811 Personal Renegociada%29</fullName>
        <active>true</active>
        <formula>RecordType.Name = &apos;NOC 11 Descuento Personal Renegociado&apos; &amp;&amp; NOT(ISBLANK(Fecha_fin__c)) &amp;&amp; ISPICKVAL(Estado_Flujo__c , &apos;Aprobado&apos;) &amp;&amp; ISNULL(Oportunidad_renegociada__r.Fecha_de_Alta__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Finalizaci_n</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NOC__c.Fecha_fin__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Aviso finalización NOC %2811 Personal%29</fullName>
        <active>true</active>
        <formula>RecordType.Name = &apos;NOC 11 Descuento Personal Puntual&apos; &amp;&amp; NOT(ISBLANK(Fecha_fin__c)) &amp;&amp; ISPICKVAL(Estado_Flujo__c , &apos;Aprobado&apos;) &amp;&amp; ISNULL(Oportunidad__r.Fecha_de_Alta__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Finalizaci_n</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NOC__c.Fecha_fin__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Aviso finalización NOC %28Convenios%29</fullName>
        <active>false</active>
        <formula>RecordType.Name=&apos;NOC 12 Convenios&apos; &amp;&amp; NOT(ISBLANK(Fecha_fin__c))  &amp;&amp;  ISPICKVAL(Estado_Flujo__c , &apos;Aprobado&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Finalizaci_n</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NOC__c.Fecha_fin__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Calcular descuento</fullName>
        <actions>
            <name>Actualizar_descuento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Precio_propuesto__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 1</fullName>
        <actions>
            <name>Calcular_descuento_Mes_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_1__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 2</fullName>
        <actions>
            <name>Calcular_descuento_Importe_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_2__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 3</fullName>
        <actions>
            <name>Calcular_descuento_Mes_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_3__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 4</fullName>
        <actions>
            <name>Calcular_descuento_Mes_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_4__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 5</fullName>
        <actions>
            <name>Calcular_descuento_Mes_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_5__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular descuento Importe 6</fullName>
        <actions>
            <name>Calcular_descuento_Mes_6</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Importe_Mes_6__c ))  &amp;&amp;  IF( RecordType.Name=&apos;NOC 11 Descuento Personal Puntual&apos;,  NOT( ISNULL( Oportunidad__r.Precio__c )),  NOT(ISNULL(  Oportunidad_renegociada__r.Precio__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcular importe fianza</fullName>
        <actions>
            <name>Calcular_importe_fianza</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NOC__c.Fianza_a_cobrar__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>NOC__c.Nueva_tarifa_oficial__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>NOC__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NOC 11 Descuento Personal Renegociado</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Nuevo colectivo TA</fullName>
        <actions>
            <name>Nuevo_colectivo</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NOC__c.Estado_Flujo__c</field>
            <operation>equals</operation>
            <value>Aprobado</value>
        </criteriaItems>
        <criteriaItems>
            <field>NOC__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NOC 12 Convenios</value>
        </criteriaItems>
        <criteriaItems>
            <field>NOC__c.Id_Recomendador_T24__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Visibilidad NOC 11</fullName>
        <actions>
            <name>Visibildad_NOC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NOC__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NOC 11 Descuento Personal Puntual,NOC 11 Descuento Personal Renegociado</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Nuevo_colectivo</fullName>
        <assignedToType>owner</assignedToType>
        <description>Se ha aprobado un convenio con un nuevo colectivo. Recuerde crearlo en Tele24W y asociarle el IdT24 en Salesforce</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Nuevo colectivo</subject>
    </tasks>
    <tasks>
        <fullName>Recordatorio_Enviar_convenio_firmado</fullName>
        <assignedToType>owner</assignedToType>
        <description>El convenio ya ha sido aprobado. Recuerde enviar una copia del convenio original firmado al Departamento de Servicios Jurídicos</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Recordatorio: Enviar convenio firmado</subject>
    </tasks>
    <tasks>
        <fullName>prova</fullName>
        <assignedTo>sarquavitae@konozca.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>4</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>NOC__c.Fecha_Fin_6__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>prova</subject>
    </tasks>
</Workflow>
