<#if booleanappcode == true>
<#-- Common variables across different conditions -->
<#if wlsbletrspss??>
<#-- For TRSP_CLIENT configuration ( for CLIENT configuration but not both together, central_trp_uart and central_trp_codedPhy) -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && !(wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && numberoflinks <=1>
${WLS_BLE_COMMENT}
void uart_cb(SERCOM_USART_EVENT event, uintptr_t context)
{
APP_Msg_T appMsg;   
// If RX data from UART reached threshold (previously set to 1)
if (event == SERCOM_USART_EVENT_READ_THRESHOLD_REACHED)
{
    // Read 1 byte data from UART
    SERCOM0_USART_Read(&uart_data, 1);

    appMsg.msgId = APP_MSG_UART_CB;
    OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);     
}
}

void APP_UartCBHandler()
{
    // Send the data from UART to connected device through Transparent service
    BLE_TRSPC_SendData(conn_handle, 1, &uart_data);     
}
</#if>
<#-- For TRSP_CLIENT configuration central multilink -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && !(wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)>
${WLS_BLE_COMMENT}
void uart_cb(SERCOM_USART_EVENT event, uintptr_t context)
{
APP_Msg_T   appMsg;     
// If RX data from UART reached threshold (previously set to 1)
if( event == SERCOM_USART_EVENT_READ_THRESHOLD_REACHED )
{
    // Read 1 byte data from UART
    SERCOM0_USART_Read(&uart_data, 1);
    appMsg.msgId = APP_MSG_UART_CB;
    OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);       
}
}

void APP_UartCBHandler()
{
    // Send the data from UART to connected device through Transparent service
    BLE_TRSPC_SendData(conn_hdl[i], 1, &uart_data);
    i++;
    if(i==no_of_links) i = 0; //reset link index    
}
</#if>
<#-- For SS_TRSP_BOOL_SERVER configuration ( for SS_TRSP_BOOL_SERVER configuration but not both together, peripheral_trp_uart and peripheral_trp_codedPhy) -->
<#if wlsbletrspss.SS_TRSP_BOOL_SERVER == true && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true) && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
${WLS_BLE_COMMENT}
void uart_cb(SERCOM_USART_EVENT event, uintptr_t context)
{
APP_Msg_T   appMsg;  
// If RX data from UART reached threshold (previously set to 1)
if( event == SERCOM_USART_EVENT_READ_THRESHOLD_REACHED )
{
    // Read 1 byte data from UART
    SERCOM0_USART_Read(&uart_data, 1);
    appMsg.msgId = APP_MSG_UART_CB;
    OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);     
}
}

void APP_UartCBHandler()
{
    // Send the data from UART to connected device through Transparent service
    BLE_TRSPS_SendData(conn_handle, 1, &uart_data);      
}
</#if>
<#-- For both TRSP_CLIENT and TRSP_SERVER configuration (multilink and multirole) -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true>
${WLS_BLE_COMMENT}
void uart_cb(SERCOM_USART_EVENT event, uintptr_t context)
{
APP_Msg_T   appMsg;   
// If RX data from UART reached threshold (previously set to 1)
if( event == SERCOM_USART_EVENT_READ_THRESHOLD_REACHED )
{
    // Read 1 byte data from UART
    SERCOM0_USART_Read(&uart_data, 1);

    appMsg.msgId = APP_MSG_UART_CB;
    OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);     
}
}

void APP_UartCBHandler()
{
    // Send the data from UART to connected device through Transparent service
    BLE_TRSPC_SendData(conn_hdl[i], 1, &uart_data);
    i++;
    if(i==no_of_links) i = 0; //reset link index    
}
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false  && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
${WLS_BLE_COMMENT}
static void APP_ConfigBleBuiltInSrv(void) 
{
    GATTS_GattServiceOptions_T gattServiceOptions;

    /* GATT Service option */
    gattServiceOptions.enable = 1;
    GATTS_ConfigureBuildInService(&gattServiceOptions);
}
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true &&  WLS_BLE_GAP_ADV_TYPE == 2>
${WLS_BLE_COMMENT}
void RGB_LED_GPIO_Initialize ( void )
{
    CFG_REGS->CFG_CFGCON0CLR = CFG_CFGCON0_JTAGEN_Msk;
 
          /* PORTA Initialization */
    /* PORTB Initialization */


    /* PPS Input Remapping */

    /* PPS Output Remapping */
    
    GPIOA_REGS->GPIO_TRISSET = 0xFFFF; //Set all pins as input

    /*  PB  */
    GPIOB_REGS->GPIO_ANSELSET = 0x0040; //PB6 ANSEL for Temp sensor
    GPIOB_REGS->GPIO_TRISSET = 0xFFFF;  //Set all pins as input
    GPIOB_REGS->GPIO_CNPUSET = 0xF886;  //Pull up: PRB 1, 2, 7, 11, 12 , 13 ,14 , 15
    GPIOB_REGS->GPIO_CNPDSET = 0x0029;  //Pull down RB0,3,5 for LED
}
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == false>
${WLS_BLE_COMMENT}
void GPIO_LED_Initialize ( void )
{
    CFG_REGS->CFG_CFGCON0CLR = CFG_CFGCON0_JTAGEN_Msk;
          /* PORTA Initialization */
    /* PORTB Initialization */


    /* PPS Input Remapping */

    /* PPS Output Remapping */
 /*  PA  */
    GPIOA_REGS->GPIO_TRISSET = 0xFFFF; //Set all pins as input

    /*  PB  */
    GPIOB_REGS->GPIO_ANSELSET = 0x0040; //PB6 ANSEL for Temp sensor
    GPIOB_REGS->GPIO_TRISSET = 0xFFFF;  //Set all pins as input
    GPIOB_REGS->GPIO_CNPUSET = 0xF886;  //Pull up: PRB 1, 2, 7, 11, 12 , 13 ,14 , 15
    GPIOB_REGS->GPIO_CNPDSET = 0x0029;  //Pull down RB0,3,5 for LED

}
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true  || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true >
${WLS_BLE_COMMENT}
void APP_BLE_PairedDevUpdate()
{
    BLE_GAP_AdvParams_T             advParam;
    memset(&g_extPairedDevInfo, 0, sizeof(APP_ExtPairedDevInfo_T));
    APP_WLS_BLE_GetExtPairedDevInfoFromFlash(&g_extPairedDevInfo);
    memset(&g_pairedDevInfo.addr, 0, sizeof(BLE_GAP_Addr_T));
    g_pairedDevInfo.bPeerDevIdExist=APP_WLS_BLE_GetPairedDeviceId(&g_pairedDevInfo.peerDevId);
    if (g_pairedDevInfo.bPeerDevIdExist)
    {
        g_pairedDevInfo.bAddrLoaded =APP_WLS_BLE_GetPairedDeviceAddr(&g_pairedDevInfo.addr);
    }
    else
    {
        g_pairedDevInfo.bAddrLoaded =false;
    }
    g_pairedDevInfo.bPaired=g_pairedDevInfo.bAddrLoaded;

    (void)memset(&advParam, 0, sizeof(BLE_GAP_AdvParams_T));
    advParam.intervalMin = APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN;     /* Advertising Interval Min */
    advParam.intervalMax = APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX;     /* Advertising Interval Max */
    //Windows/ Android/ iOS support the reconnection using ADV_IND. So using ADV_IND for pairing and reconnection.
    advParam.type = BLE_GAP_ADV_TYPE_ADV_IND;        /* Advertising Type */
    advParam.advChannelMap = BLE_GAP_ADV_CHANNEL_ALL;        /* Advertising Channel Map */
    if (g_pairedDevInfo.bPaired)//Paired already
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_SCAN_CONNECT;     /* Advertising Filter Policy */
    }
    else
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_DEFAULT;     /* Advertising Filter Policy */
    }
    BLE_GAP_SetAdvParams(&advParam);
    
    
    
    
    //Configure Device Address-Random Static Address and local IRK
    if (!g_pairedDevInfo.bPaired)//Not paired yet
    {
        //Set a new IRK
        APP_WLS_BLE_SetLocalIRK();

        APP_WLS_BLE_GenerateRandomStaticAddress(&g_extPairedDevInfo.localAddr);
    }
    BLE_GAP_SetDeviceAddr(&g_extPairedDevInfo.localAddr);
    
    
     //If paired device exists, set resolving list
    if (g_pairedDevInfo.bPaired)//Paired already
    {
        APP_WLS_BLE_SetFilterAcceptList(true);
        if (g_extPairedDevInfo.bConnectedByResolvedAddr)
        {
            APP_WLS_BLE_SetResolvingList(true);
        }
    }
    APP_WLS_RegisterPdsCb();
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
    BLE_DIS_Add();
</#if>    
}
</#if>
</#if>
			
			
