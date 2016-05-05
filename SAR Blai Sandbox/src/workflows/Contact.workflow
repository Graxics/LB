<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aviso_propietarios_en_cuenta_y_contacto_distintos</fullName>
        <description>Aviso propietarios en cuenta y contacto distintos</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WF_contacto/Propietarios_cuenta_y_contacto_diferentes</template>
    </alerts>
</Workflow>
