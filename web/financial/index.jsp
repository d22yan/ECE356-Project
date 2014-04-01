<%-- 
    Document   : legal
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>

<generic:page-template title="Financial" tabbed="true">
    <jsp:body>
         <generic:tab-template id="doctor-tab" label="Doctors" isActive="true">
            <jsp:body>
                <generic:doctor-table></generic:doctor-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-tab" label="Patients">
           <jsp:body>
               <generic:patient-table></generic:patient-table>
           </jsp:body>
       </generic:tab-template> 
    </jsp:body>
</generic:page-template>