<#if booleanappcode ==  true>
<#if PROFILE_ANP?? && PROFILE_ANP.ANP_BOOL_SERVER == true>
			APP_WLS_ANPS_KeyShortPress();
</#if>
<#if PROFILE_ANP?? && PROFILE_ANP.ANP_BOOL_CLIENT == true>
			APP_WLS_ANPC_KeyShortPress();
</#if>
</#if>