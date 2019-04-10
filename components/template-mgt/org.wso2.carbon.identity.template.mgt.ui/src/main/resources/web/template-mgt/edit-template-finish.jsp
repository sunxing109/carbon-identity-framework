<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.template.mgt.ui.client.TemplateManagementServiceClient" %>
<%@ page import="org.wso2.carbon.identity.template.mgt.ui.dto.UpdateTemplateRequestDTO" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="java.util.ResourceBundle" %>

<%--
  ~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied. See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%
    String httpMethod = request.getMethod();
    if (!"post".equalsIgnoreCase(httpMethod)) {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return;
    }
    
    String templateName = request.getParameter("templateName");
    String oldTemplateName = request.getParameter("oldTemplateName");
    String description = request.getParameter("template-description");
    String templateScript = request.getParameter("scriptTextArea");
    
    if (templateName != null && !"".equals(templateName)) {
        
        String BUNDLE = "org.wso2.carbon.identity.template.mgt.ui.i18n.Resources";
        ResourceBundle resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale());
        
        UpdateTemplateRequestDTO updateTemplateRequestDTO = new UpdateTemplateRequestDTO();
        updateTemplateRequestDTO.setTemplateName(templateName);
        updateTemplateRequestDTO.setDescription(description);
        updateTemplateRequestDTO.setTemplateScript(templateScript);
        
        try {
            
            String currentUser = (String) session.getAttribute("logged-user");
            TemplateManagementServiceClient serviceClient = new TemplateManagementServiceClient(currentUser);
            
            serviceClient.updateTemplate(oldTemplateName, updateTemplateRequestDTO);
            
        } catch (Exception e) {
            String message = resourceBundle.getString("alert.error.while.updating.template") + " : " + e.getMessage();
            CarbonUIMessage.sendCarbonUIMessage(message, CarbonUIMessage.ERROR, request, e);
%>

<script>
    location.href = "get-template.jsp?templateName=<%=Encode.forUriComponent(oldTemplateName)%>"
</script>
<%
        }
    }
%>

<script>
    location.href = 'list-templates.jsp';
</script>
