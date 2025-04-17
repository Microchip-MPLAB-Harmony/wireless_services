<#if booleanappcode ==  true>
<#if PROFILE_ANP?? && PROFILE_ANP.ANP_BOOL_SERVER == true>
APP_WLS_ANPS_KeyLongPress();
</#if>
<#if PROFILE_ANP?? && PROFILE_ANP.ANP_BOOL_CLIENT == true>
APP_WLS_ANPC_KeyLongPress();
</#if>
</#if>