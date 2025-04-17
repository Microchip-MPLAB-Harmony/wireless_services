<#if CSS_BOOL_APP_CODE_ENABLE == true>
            SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"\r\n=====BLE CPS DEMO APP======\r\n");
</#if>
            BLE_CPS_Init();
<#list 0..4 as i>
  <#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + i>
  <#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
  <#list 0..9 as j>
    <#assign CSS_CP_COMMAND_ID = "CSS_BOOL_SVC_" + i + "_CP_" + j + "_COMMAND">
    <#if CSS_CP_COMMAND_ID?eval == true>
            APP_WLS_CPS_${CSS_SVC_NAME_VALUE?upper_case}${j}_CallbackRegisterInit();
    </#if>
  </#list>
</#list>