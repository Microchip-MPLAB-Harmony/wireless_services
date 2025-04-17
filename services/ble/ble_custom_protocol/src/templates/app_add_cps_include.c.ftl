#include "wireless/services/ble/cps/ble_cps_handler.h"
<#list 0..4 as i>
  <#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + i>
  <#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
  <#list 0..9 as j>
    <#assign CSS_CP_COMMAND_ID = "CSS_BOOL_SVC_" + i + "_CP_" + j + "_COMMAND">
    <#if CSS_CP_COMMAND_ID?eval == true>
#include "app_wls_cps_${CSS_SVC_NAME_VALUE?lower_case}${j}_action_handler.h"
    </#if>
  </#list>
</#list>