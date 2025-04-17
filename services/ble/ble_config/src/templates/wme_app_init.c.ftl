<#if booleanappcode ==true>
${WLS_BLE_COMMENT}
<#-- For TRSP_CLIENT configuration ( for central_trp_uart ) -->
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false  && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true)>
            //appData.appQueue = xQueueCreate( 10, sizeof(APP_Msg_T) );
            // Enable UART Read
            SERCOM0_USART_ReadNotificationEnable(true, true);
            // Set UART RX notification threshold to be 1
            SERCOM0_USART_ReadThresholdSet(1);
            // Register the UART RX callback function
            SERCOM0_USART_ReadCallbackRegister(uart_cb, (uintptr_t)NULL);
       
            // Scanning Enabled
            BLE_GAP_SetScanningEnable(true, BLE_GAP_SCAN_FD_ENABLE, BLE_GAP_SCAN_MODE_OBSERVER, APP_BLE_SCAN_DURATION);
            // Output the status string to UART
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scanning \r\n");
</#if>
<#if WLS_BLE_GAP_SCAN == true && WLS_BLE_BOOL_GAP_EXT_SCAN == true>
    <#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true >
        <#if WLS_BLE_GAP_EXT_SCAN_PHY == "1" || WLS_BLE_GAP_EXT_SCAN_PHY == "2">
        <#-- For TRSP_CLIENT configuration ( for central_trp_codedPhy ) -->
            BLE_GAP_ExtConnCentralInit();  /* Enable Extended Central */
            SERCOM0_USART_ReadNotificationEnable(true, true);
            SERCOM0_USART_ReadThresholdSet(1);
            SERCOM0_USART_ReadCallbackRegister(uart_cb, (uintptr_t)NULL);

            BLE_GAP_ExtScanningEnable_T extScan;
            extScan.duration = APP_BLE_EXTSCAN_DURATION;
            extScan.enable = true;
            extScan.filterDuplicates = BLE_GAP_SCAN_FD_DISABLE;
            extScan.period = APP_BLE_EXTSCAN_PERIOD; 
            BLE_GAP_SetExtScanningEnable(BLE_GAP_SCAN_MODE_OBSERVER, &extScan);
            // Output the status string to UART
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n\r\n------Scanning...\r\n");
        </#if>
    <#else>
     <#-- For TRSP_CLIENT configuration ( for central_ext_scan) -->
            uint16_t ret;
            BLE_GAP_ExtScanningEnable_T extScan;
            extScan.duration = APP_BLE_EXTSCAN_DURATION; 
            extScan.enable = true; 
            extScan.filterDuplicates = BLE_GAP_SCAN_FD_DISABLE;
            extScan.period = APP_BLE_EXTSCAN_PERIOD;
            GPIO_PinClear(GPIO_PIN_RB3);
            // ret = BLE_GAP_SetExtScanningParams(${BLE_STACK_LIB.GAP_EXT_SCAN_FILT_POLICY}, &scanParams);
            ret = BLE_GAP_SetExtScanningEnable(BLE_GAP_SCAN_MODE_OBSERVER, &extScan);
            if (ret == MBA_RES_SUCCESS)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"ExtAdv Scan Enable Success\r\n");
    </#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false  && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true)>
<#-- For TRSP_SERVER configuration ( for peripheral_trp_uart ) -->
                BLE_GAP_Addr_T devAddr;
            devAddr.addrType = BLE_GAP_ADDR_TYPE_PUBLIC;
            devAddr.addr[0] = 0xA1;
            devAddr.addr[1] = 0xA2;
            devAddr.addr[2] = 0xA3;
            devAddr.addr[3] = 0xA4;
            devAddr.addr[4] = 0xA5;
            devAddr.addr[5] = 0xA6;
            // Configure device address
            BLE_GAP_SetDeviceAddr(&devAddr);

            // Register call back when data is available on UART for Peripheral Device to send
            // Enable UART Read
            SERCOM0_USART_ReadNotificationEnable(true, true);
            // Set UART RX notification threshold to be 1
            SERCOM0_USART_ReadThresholdSet(1);
            // Register the UART RX callback function
            SERCOM0_USART_ReadCallbackRegister(uart_cb, (uintptr_t)NULL);
            BLE_GAP_SetAdvEnable(0x01, 0x00);
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Advertising\r\n");
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
<#-- For TRSP_CLIENT configuration ( for peripheral_trp_codedPhy ) -->
            BLE_GAP_Addr_T devAddr;
            devAddr.addrType = BLE_GAP_ADDR_TYPE_PUBLIC;
            devAddr.addr[0] = 0xA1;
            devAddr.addr[1] = 0xA2;
            devAddr.addr[2] = 0xA3;
            devAddr.addr[3] = 0xA4;
            devAddr.addr[4] = 0xA5;
            devAddr.addr[5] = 0xA6;
            
                // Configure device address
                BLE_GAP_SetDeviceAddr(&devAddr);
			// Enable UART Read
            SERCOM0_USART_ReadNotificationEnable(true, true);
            // Set UART RX notification threshold to be 1
            SERCOM0_USART_ReadThresholdSet(1);
            // Register the UART RX callback function
            SERCOM0_USART_ReadCallbackRegister(uart_cb, (uintptr_t)NULL);

            
            // Enable Ext Adv
 
            BLE_GAP_ExtAdvEnableParams_T extAdvEnableParam;
            extAdvEnableParam.advHandle = APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE; 
            extAdvEnableParam.duration = APP_BLE_EXTADVENBALEPARAM_DURATION; 
            extAdvEnableParam.maxExtAdvEvts = APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS; 
            ret = BLE_GAP_SetExtAdvEnable(true, 0x01,  &extAdvEnableParam);
            if (ret == MBA_RES_SUCCESS)
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n\r\n------Ext Advertising...\r\n");  
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && !wlsbletrspss?? && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == false> 
<#-- For ext_adv -->    
            GPIO_LED_Initialize();
            RTC_Timer32Start();
            BLE_GAP_ExtAdvEnableParams_T extAdvEnableParam;
            extAdvEnableParam.advHandle = APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE; 
            extAdvEnableParam.duration = APP_BLE_EXTADVENBALEPARAM_DURATION; 
            extAdvEnableParam.maxExtAdvEvts = APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS; 
            ret = BLE_GAP_SetExtAdvEnable(true, 0x01,  &extAdvEnableParam);
            if (ret == MBA_RES_SUCCESS)
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n\r\n------Ext Advertising...\r\n");  
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
<#-- For TRSP_CLIENT configuration ( for multilink and multirole ) -->
            //appData.appQueue = xQueueCreate( 10, sizeof(APP_Msg_T) );
            // Enable UART Read
            SERCOM0_USART_ReadNotificationEnable(true, true);
            // Set UART RX notification threshold to be 1
            SERCOM0_USART_ReadThresholdSet(1);
            // Register the UART RX callback function
            SERCOM0_USART_ReadCallbackRegister(uart_cb, (uintptr_t)NULL);
              BLE_GAP_SetScanningEnable(true, BLE_GAP_SCAN_FD_ENABLE, BLE_GAP_SCAN_MODE_OBSERVER, APP_BLE_SCAN_DURATION);
            // Output the status string to UART
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scanning \r\n");
</#if>
<#if  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !wlsbleanpss?? && !wlsblepxpss??>
            BLE_GAP_SetScanningEnable(true, BLE_GAP_SCAN_FD_ENABLE, BLE_GAP_SCAN_MODE_OBSERVER, APP_BLE_SCAN_DURATION);
            // Output the status string to UART
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scanning \r\n");
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_GAP_ADV_TYPE == 0 && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && !wlsbletrspss?? && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false && !wlsblepxpss?? && !wlsblehogp?? && !wlsbleanpss?? && !wlsbleancsss??>
	        // Start Advertisement
            BLE_GAP_Addr_T devAddr;
            devAddr.addrType = BLE_GAP_ADDR_TYPE_PUBLIC;
            devAddr.addr[0] = 0xA1;
            devAddr.addr[1] = 0xA2;
            devAddr.addr[2] = 0xA3;
            devAddr.addr[3] = 0xA4;
            devAddr.addr[4] = 0xA5;
            devAddr.addr[5] = 0xA6;
                
            // Configure device address
            BLE_GAP_SetDeviceAddr(&devAddr);
            BLE_GAP_SetAdvEnable(0x01, 0x00);
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Advertising\r\n");
</#if> 
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_GAP_EXT_ADV == true && !wlsbletrspss?? && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
 <#--( for two set adv set ) -->
         // Enable Ext Adv
            BLE_GAP_ExtAdvEnableParams_T extAdvEnableParam[2];
            extAdvEnableParam[0].advHandle = APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE_1; 
            extAdvEnableParam[0].duration = APP_BLE_EXTADVENBALEPARAM_DURATION; 
            extAdvEnableParam[0].maxExtAdvEvts = APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS; 
            
            extAdvEnableParam[1].advHandle = APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE_2; 
            extAdvEnableParam[1].duration = APP_BLE_EXTADVENBALEPARAM_DURATION;
            extAdvEnableParam[1].maxExtAdvEvts = APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS; 
            ret = BLE_GAP_SetExtAdvEnable(true, 2,  extAdvEnableParam);
            if (ret == MBA_RES_SUCCESS)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n\r\n------2 Set Advertising...\r\n"); 
            else
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_GAP_SetExtAdvEnable Err:0x%x\r\n", ret);
</#if>  
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_GAP_ADV_TYPE == 2 && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
 <#--( legacy adv ) -->
            BLE_GAP_Addr_T devAddr;
            devAddr.addrType = BLE_GAP_ADDR_TYPE_PUBLIC;
            devAddr.addr[0] = 0xA1;
            devAddr.addr[1] = 0xA2;
            devAddr.addr[2] = 0xA3;
            devAddr.addr[3] = 0xA4;
            devAddr.addr[4] = 0xA5;
            devAddr.addr[5] = 0xA6;

            // Configure device address
            BLE_GAP_SetDeviceAddr(&devAddr);

            if (!(RTC_REGS->MODE0.RTC_CTRLA & RTC_MODE0_CTRLA_ENABLE_Msk))
            {
                RTC_Timer32Start();
            }

            BLE_GAP_SetAdvEnable(0x01, 0);
            RGB_LED_GPIO_Initialize();
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\nAdvertising");
</#if>
<#if wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) 
        || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
            bool bPaired;
            uint8_t devId;
            appData.state = APP_STATE_SERVICE_TASKS;
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true || 
        wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
        uint16_t ret;
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true  || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
            APP_BLE_PairedDevUpdate();        	
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
        || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true 
        || wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) 
        || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
            APP_KEY_Init();
            APP_KEY_MsgRegister(APP_KeyFunction);
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
        || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true 
        || wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) 
        || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
            APP_LED_Init();
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
#ifdef PIC32BZ2 
            APP_WLS_LED_Start();
#endif
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
        || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
		    APP_WLS_BLE_EnableAdvDirect(g_pairedDevInfo.bPaired);	
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true>
            // ANPS set supported new alert categories.
            BLE_ANPS_SetSuppNewCat(0x3FF);
            // ANPS set supported unread alert categories.
            BLE_ANPS_SetSuppUnreadCat(0x3FF);
</#if>
<#if wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) 
        || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
            APP_WLS_BLE_InitConfig();
            bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
            APP_CONN_Init();
            APP_CONN_TimeOutActionRegister(APP_WLS_BLE_ConnTimeoutAction
);	
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
            ret = APP_WLS_BLE_ScanEnable(bPaired ? APP_DEVICE_STATE_WITH_BOND_SCAN: APP_DEVICE_STATE_SCAN);
            if (ret != MBA_RES_SUCCESS)
            {
            }
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true>
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"ANPC init\n");
		
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
            APP_WLS_BLE_EnableAdv(bPaired ? APP_DEVICE_STATE_ADV_DIR: APP_DEVICE_STATE_ADV);		
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
			// when WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL is enabled 
			RTC_Timer32Start();
			/* Configure build-in GATT Services*/
            APP_ConfigBleBuiltInSrv();
			APP_LED_Init();
			APP_WLS_BLE_UpdateLocalName(0, NULL);
            APP_WLS_BLE_InitConnList();
            APP_ADV_Init();

            APP_WLS_TRP_Init();
            APP_WLS_TRPS_Init();
           SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_Throughput APP Initialized.\r\n");
</#if>
</#if>