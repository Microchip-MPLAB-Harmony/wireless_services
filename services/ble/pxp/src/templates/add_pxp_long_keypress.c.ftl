<#if booleanappcode ==  true>
<#if PROFILE_PXP?? && PROFILE_PXP.PXP_BOOL_SERVER == true>
        APP_WLS_PXPR_KeyLongPress();
</#if>
<#if PROFILE_PXP?? && PROFILE_PXP.PXP_BOOL_CLIENT == true>
        APP_WLS_PXPM_KeyLongPress();
</#if>
</#if>