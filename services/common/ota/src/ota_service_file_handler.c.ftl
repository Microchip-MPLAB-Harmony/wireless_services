/*******************************************************************************
  OTA service File Handler Source File

  File Name:
    ota_service_file_handler.c

  Summary:
    This file contains source code necessary to handle the image and it's metadata.

  Description:
    This file contains source code necessary to handle the image and it's metadata.
 *******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *******************************************************************************/
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Include Files
// *****************************************************************************
// *****************************************************************************

#include "ota_service_file_handler.h"
#include "ota_service.h"
#include "definitions.h"

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Global objects
// *****************************************************************************
// *****************************************************************************
<#if DRIVER_USED == NVM_MEM_USED>
<#assign MEM_USED = NVM_MEM_USED>
</#if>

static uint8_t CACHE_ALIGN controlBlockBuffer[OTA_CONTROL_BLOCK_BUFFER_SIZE];
static uint8_t CACHE_ALIGN flash_data[DATA_SIZE];
static OTA_FILE_HANDLER_CONTEXT otaFileHandlerCtx;
static uint32_t ctrlBlkSize = OTA_CONTROL_BLOCK_BUFFER_SIZE;
static OTA_FILE_HANDLER_DATA otaFileHandlerData =
{
    .state = OTA_SERVICE_FH_STATE_INIT,
    .controlBlock = (OTA_CONTROL_BLOCK *)controlBlockBuffer
};

// *****************************************************************************
// *****************************************************************************
// Section: File Handler Local Functions
// *****************************************************************************
// *****************************************************************************

<#if DRIVER_USED == NVM_MEM_USED>
<#if OTA_SERVICE_HW_CRC_GEN?? && OTA_SERVICE_HW_CRC_GEN == true>
    <#lt>/* Function to Generate CRC using the device service unit peripheral on programmed data */
    <#lt>static uint32_t OTA_SERVICE_FH_CRCGenerate(uint32_t start_addr, uint32_t size)
    <#lt>{
    <#lt>    uint32_t crc  = 0xFFFFFFFFU;

    <#if OTA_SERVICE_CRC_PERIPH_USED?? && OTA_SERVICE_CRC_PERIPH_USED == "FCR">
        <#lt>    FCR_CRCCalculate(start_addr, size, 0xFFFFFFFFU, &crc);
    <#elseif OTA_SERVICE_CRC_PERIPH_USED?? && OTA_SERVICE_CRC_PERIPH_USED == "DSU">
        <#lt>    PAC_PeripheralProtectSetup (PAC_PERIPHERAL_DSU, PAC_PROTECTION_CLEAR);

        <#lt>    (void)DSU_CRCCalculate (start_addr, size, crc, &crc);

        <#lt>    PAC_PeripheralProtectSetup (PAC_PERIPHERAL_DSU, PAC_PROTECTION_SET);
    </#if>

    <#lt>    return crc;
    <#lt>}
<#else>
<#if __PROCESSOR?matches("PIC32M.*") == true>
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
    <#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
    </#if>
</#if>
/* Following MISRA-C rules are deviated in the below code block */
/* MISRA C-2012 Rule 11.6 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.6"  "H3_MISRAC_2012_R_11_6_DR_1"
</#if>
</#if>
    <#lt>/* Function to Generate CRC by reading the firmware programmed into internal flash */
    <#lt>static uint32_t OTA_SERVICE_FH_CRCGenerate(uint32_t start_addr, uint32_t size)
    <#lt>{
    <#lt>    uint32_t   i, j, value;
    <#lt>    uint32_t   crc_tab[256];
    <#lt>    uint32_t   crc = 0xFFFFFFFFU;
    <#lt>    uint8_t    data;

    <#lt>    for (i = 0U; i < 256U; i++)
    <#lt>    {
    <#lt>        value = i;

    <#lt>        for (j = 0U; j < 8U; j++)
    <#lt>        {
    <#lt>            if ((value & 1U) != 0U)
    <#lt>            {
    <#lt>                value = (value >> 1U) ^ 0xEDB88320U;
    <#lt>            }
    <#lt>            else
    <#lt>            {
    <#lt>                value >>= 1U;
    <#lt>            }
    <#lt>        }
    <#lt>        crc_tab[i] = value;
    <#lt>    }

    <#lt>    for (i = 0U; i < size; i++)
    <#lt>    {
    <#if __PROCESSOR?matches("PIC32M.*") == false>
        <#lt>        data = *(uint8_t *)(start_addr + i);
    <#else>
        <#lt>        data = *(uint8_t *)KVA0_TO_KVA1((start_addr + i));
    </#if>

    <#lt>        crc = crc_tab[(crc ^ data) & 0xffU] ^ (crc >> 8U);
    <#lt>    }

    <#lt>    return crc;
    <#lt>}
<#if __PROCESSOR?matches("PIC32M.*") == true>
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.6"
</#if>
/* MISRAC 2012 deviation block end */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
    <#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
    </#if>
</#if>
</#if>

</#if>
<#else>
static uint32_t OTA_SERVICE_FH_CRCGenerate(uint8_t *start_addr, uint32_t size, uint32_t crc)
{
    uint32_t   i, j, value;
    uint32_t   crc_tab[256];
    uint8_t    data;

    for (i = 0U; i < 256U; i++)
    {
        value = i;

        for (j = 0U; j < 8U; j++)
        {
            if ((value & 1U) != 0U)
            {
                value = (value >> 1U) ^ 0xEDB88320U;
            }
            else
            {
                value >>= 1U;
            }
        }
        crc_tab[i] = value;
    }

    for (i = 0U; i < size; i++)
    {
        data = start_addr[i];
        crc = crc_tab[(crc ^ data) & 0xffU] ^ (crc >> 8U);
    }

    return crc;
}
</#if>

<#if DRIVER_USED != NVM_MEM_USED>
static bool OTA_SERVICE_FH_WaitForXferComplete(void)
{
    bool status = false;

    OTA_MEM_TRANSFER_STATUS transferStatus = OTA_MEM_TRANSFER_ERROR_UNKNOWN;

    do
    {
        transferStatus = (OTA_MEM_TRANSFER_STATUS)${DRIVER_USED}_TransferStatusGet(otaFileHandlerData.handle);

    } while (transferStatus == OTA_MEM_TRANSFER_BUSY);

    if(transferStatus == OTA_MEM_TRANSFER_COMPLETED)
    {
        status = true;
    }

    return status;
}
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: File Handler Global Functions
// *****************************************************************************
// *****************************************************************************

<#if __PROCESSOR?matches("PIC32M.*") == false>
    <#lt>/* Trigger a reset */
    <#lt>void OTA_SERVICE_FH_TriggerReset(void)
    <#lt>{
    <#lt>    NVIC_SystemReset();
    <#lt>}
<#else>
    <#lt>/* Trigger a reset */
    <#lt>void OTA_SERVICE_FH_TriggerReset(void)
    <#lt>{
    <#lt>    /* Perform system unlock sequence */
    <#lt>    SYSKEY = 0x00000000U;
    <#lt>    SYSKEY = 0xAA996655U;
    <#lt>    SYSKEY = 0x556699AAU;

    <#lt>    RSWRSTSET = _RSWRST_SWRST_MASK;
    <#lt>    (void)RSWRST;
    <#lt>}
</#if>

bool OTA_SERVICE_FH_CtrlBlkRead(OTA_CONTROL_BLOCK *controlBlock, uint32_t length)
{
<#if DRIVER_USED != NVM_MEM_USED>
    uint32_t count;
    uint32_t blockSize;
    uint32_t otaMemoryStart;
    uint32_t otaMemorySize;
</#if>
    uint32_t appMetaDataAddress;
    bool     status = false;
    uint8_t  *ptrBuffer = (uint8_t *)controlBlock;

    if ((ptrBuffer != NULL) && (length == ctrlBlkSize))
    {
<#if DRIVER_USED != NVM_MEM_USED>
        otaMemoryStart    = otaFileHandlerData.geometry.blockStartAddress;

        otaMemorySize     = (otaFileHandlerData.geometry.read_blockSize * otaFileHandlerData.geometry.read_numBlocks);

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
        blockSize = otaFileHandlerData.geometry.erase_blockSize;
<#else>
        blockSize = otaFileHandlerData.geometry.write_blockSize;
</#if>

        appMetaDataAddress  = ((otaMemoryStart + otaMemorySize) - BUFFER_SIZE(blockSize, ctrlBlkSize));

        for (count = 0U; count < length; count += OTA_CONTROL_BLOCK_PAGE_SIZE)
        {
            if (${DRIVER_USED}_Read(otaFileHandlerData.handle, ptrBuffer, OTA_CONTROL_BLOCK_PAGE_SIZE, appMetaDataAddress) != true)
            {
                status = false;
                break;
            }

            status = OTA_SERVICE_FH_WaitForXferComplete();
            appMetaDataAddress += OTA_CONTROL_BLOCK_PAGE_SIZE;
            ptrBuffer += OTA_CONTROL_BLOCK_PAGE_SIZE;
        }
<#else>
        appMetaDataAddress  = (FLASH_END_ADDRESS - ctrlBlkSize);
        (void)${MEM_USED}_Read((void *)ptrBuffer, ctrlBlkSize, appMetaDataAddress);
        status = true;
</#if>
    }

    return status;
}

bool OTA_SERVICE_FH_CtrlBlkWrite(OTA_CONTROL_BLOCK *controlBlock, uint32_t length)
{
    uint32_t count;
<#if DRIVER_USED != NVM_MEM_USED>
    uint32_t blockSize;
    uint32_t otaMemoryStart;
    uint32_t otaMemorySize;
</#if>
    uint32_t appMetaDataAddress;
    bool     status = false;
    uint8_t  *ptrBuffer = (uint8_t *)controlBlock;

    if ((ptrBuffer != NULL) && (length == ctrlBlkSize))
    {
<#if DRIVER_USED != NVM_MEM_USED>
        otaMemoryStart    = otaFileHandlerData.geometry.blockStartAddress;

        otaMemorySize     = (otaFileHandlerData.geometry.read_blockSize * otaFileHandlerData.geometry.read_numBlocks);

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
        blockSize = otaFileHandlerData.geometry.erase_blockSize;
<#else>
        blockSize = otaFileHandlerData.geometry.write_blockSize;
</#if>

        appMetaDataAddress  = ((otaMemoryStart + otaMemorySize) - BUFFER_SIZE(blockSize, ctrlBlkSize));

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
        (void)${DRIVER_USED}_SectorErase(otaFileHandlerData.handle, appMetaDataAddress);

        status = OTA_SERVICE_FH_WaitForXferComplete();
</#if>

        for (count = 0U; count < length; count += OTA_CONTROL_BLOCK_PAGE_SIZE)
        {
            if (${DRIVER_USED}_PageWrite(otaFileHandlerData.handle, ptrBuffer, appMetaDataAddress) != true)
            {
                status = false;
                break;
            }

            status = OTA_SERVICE_FH_WaitForXferComplete();
            appMetaDataAddress += OTA_CONTROL_BLOCK_PAGE_SIZE;
            ptrBuffer += OTA_CONTROL_BLOCK_PAGE_SIZE;
        }
<#else>
        appMetaDataAddress  = (FLASH_END_ADDRESS - ctrlBlkSize);

        <#if core.CoreArchitecture != "MIPS">
        // Lock region size is always bigger than the row size
        ${MEM_USED}_RegionUnlock(appMetaDataAddress);

        while(${MEM_USED}_IsBusy() == true)
        {

        }
        </#if>

        /* Erase the Current sector */
        (void)${.vars["${MEM_USED?lower_case}"].ERASE_API_NAME}(appMetaDataAddress);

        while(${MEM_USED}_IsBusy() == true)
        {

        }

        for (count = 0; count < length; count += OTA_CONTROL_BLOCK_PAGE_SIZE)
        {
            (void)${.vars["${MEM_USED?lower_case}"].WRITE_API_NAME}((void *)ptrBuffer, appMetaDataAddress);

            while(${MEM_USED}_IsBusy() == true)
            {

            }
            appMetaDataAddress += OTA_CONTROL_BLOCK_PAGE_SIZE;
            ptrBuffer += OTA_CONTROL_BLOCK_PAGE_SIZE;
        }

        status = true;
</#if>
    }

    return status;
}

OTA_SERVICE_FH_STATE OTA_SERVICE_FH_StateGet(void)
{
    return otaFileHandlerData.state;
}

void OTA_SERVICE_FH_Tasks(void)
{
    /* Check the application's current state. */
    switch (otaFileHandlerData.state)
    {
        case OTA_SERVICE_FH_STATE_INIT:
        {
            otaFileHandlerData.nFlashBytesWritten = 0U;
            otaFileHandlerData.nFlashBytesFreeSpace = DATA_SIZE;
            otaFileHandlerData.totalBytesWritten = 0U;
            otaFileHandlerData.controlBlock->ActiveImageNum = 0U;
            otaFileHandlerCtx.fileHeader = &otaFileHandlerData.fileHeader;
<#if DRIVER_USED != NVM_MEM_USED>
            if (${DRIVER_USED}_Status(${DRIVER_USED}_INDEX) == SYS_STATUS_READY)
            {
                otaFileHandlerData.handle = ${DRIVER_USED}_Open(${DRIVER_USED}_INDEX, DRV_IO_INTENT_READWRITE);

                if (otaFileHandlerData.handle != DRV_HANDLE_INVALID)
                {
                    if (${DRIVER_USED}_GeometryGet(otaFileHandlerData.handle, (void *)&otaFileHandlerData.geometry) != true)
                    {
                        otaFileHandlerData.state = OTA_SERVICE_FH_STATE_ERROR;
                        break;
                    }
                    otaFileHandlerData.state = OTA_SERVICE_FH_STATE_MSG_RECV;
                }
            }
<#else>
            otaFileHandlerData.state = OTA_SERVICE_FH_STATE_MSG_RECV;
</#if>
            break;
        }

        case OTA_SERVICE_FH_STATE_MSG_RECV:
        {
            uint32_t receivedBytes;

            otaFileHandlerCtx.buffer = &flash_data[otaFileHandlerData.nFlashBytesWritten];
            otaFileHandlerCtx.size = otaFileHandlerData.nFlashBytesFreeSpace;
            receivedBytes = OTA_SERVICE_Transport_FHMsgReceive(&otaFileHandlerCtx);

            if (receivedBytes != 0U)
            {
                otaFileHandlerData.nFlashBytesWritten += receivedBytes;
                otaFileHandlerData.nFlashBytesFreeSpace -= receivedBytes;

                if ((otaFileHandlerData.nFlashBytesWritten >= DATA_SIZE)
                ||  ((otaFileHandlerData.initData == true) && ((otaFileHandlerData.nFlashBytesWritten + otaFileHandlerData.totalBytesWritten) >= otaFileHandlerData.fileHeader.imageSize)))
                {
                    if (otaFileHandlerData.initData == false)
                    {
                        otaFileHandlerData.initData = true;
<#if DRIVER_USED != NVM_MEM_USED>
                        otaFileHandlerData.memoryAddress = otaFileHandlerData.fileHeader.loadAddress;
<#else>
                        otaFileHandlerData.memoryAddress = otaFileHandlerData.fileHeader.programAddress;
</#if>
                    }

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
<#if DRIVER_USED != NVM_MEM_USED>
                    if (0U == (otaFileHandlerData.memoryAddress % otaFileHandlerData.geometry.erase_blockSize))
<#else>
                    if (0U == (otaFileHandlerData.memoryAddress % ERASE_BLOCK_SIZE))
</#if>
                    {
                        otaFileHandlerData.state = OTA_SERVICE_FH_STATE_ERASE;
                    }
                    else
                    {
                        otaFileHandlerData.state = OTA_SERVICE_FH_STATE_WRITE;
                    }
<#else>
                    otaFileHandlerData.state = OTA_SERVICE_FH_STATE_WRITE;
</#if>
                }
            }
            break;
        }

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
        case OTA_SERVICE_FH_STATE_ERASE:
        {
<#if DRIVER_USED != NVM_MEM_USED>
            /* Erase the Current sector */
            (void)${DRIVER_USED}_SectorErase(otaFileHandlerData.handle, otaFileHandlerData.memoryAddress);
<#else>
            <#if core.CoreArchitecture != "MIPS">
            // Lock region size is always bigger than the row size
            ${MEM_USED}_RegionUnlock(otaFileHandlerData.memoryAddress);

            while(${MEM_USED}_IsBusy() == true)
            {

            }
            </#if>

            /* Erase the Current sector */
            (void)${.vars["${MEM_USED?lower_case}"].ERASE_API_NAME}(otaFileHandlerData.memoryAddress);
</#if>

            otaFileHandlerData.state = OTA_SERVICE_FH_STATE_ERASE_WAIT;

            break;
        }
</#if>

        case OTA_SERVICE_FH_STATE_WRITE:
        {
<#if DRIVER_USED != NVM_MEM_USED>
            (void)${DRIVER_USED}_PageWrite(otaFileHandlerData.handle, &flash_data[0], otaFileHandlerData.memoryAddress);
<#else>
            (void)${.vars["${MEM_USED?lower_case}"].WRITE_API_NAME}((void *)&flash_data[0], otaFileHandlerData.memoryAddress);
</#if>
            otaFileHandlerData.nFlashBytesWritten = 0U;
            otaFileHandlerData.nFlashBytesFreeSpace = DATA_SIZE;
            otaFileHandlerData.memoryAddress += DATA_SIZE;
            otaFileHandlerData.totalBytesWritten += DATA_SIZE;
            otaFileHandlerData.state = OTA_SERVICE_FH_STATE_WRITE_WAIT;
            break;
        }

<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
        case OTA_SERVICE_FH_STATE_ERASE_WAIT:
</#if>
        case OTA_SERVICE_FH_STATE_WRITE_WAIT:
        {
<#if DRIVER_USED != NVM_MEM_USED>
            OTA_MEM_TRANSFER_STATUS transferStatus;
            transferStatus = (OTA_MEM_TRANSFER_STATUS)${DRIVER_USED}_TransferStatusGet(otaFileHandlerData.handle);
            if (transferStatus == OTA_MEM_TRANSFER_COMPLETED)
<#else>
            if (${MEM_USED}_IsBusy() == false)
</#if>
            {
<#if OTA_MEM_ERASE_ENABLE?? && OTA_MEM_ERASE_ENABLE == true>
                if (otaFileHandlerData.state == OTA_SERVICE_FH_STATE_ERASE_WAIT)
                {
                    otaFileHandlerData.state = OTA_SERVICE_FH_STATE_WRITE;
                }
                else
                {
                    if (otaFileHandlerData.totalBytesWritten >= otaFileHandlerData.fileHeader.imageSize)
                    {
                        otaFileHandlerData.state = OTA_SERVICE_FH_STATE_VERIFY;
                    }
                    else
                    {
                        otaFileHandlerData.state = OTA_SERVICE_FH_STATE_MSG_RECV;
                    }
                }
<#else>
                if (otaFileHandlerData.totalBytesWritten >= otaFileHandlerData.fileHeader.imageSize)
                {
                    otaFileHandlerData.state = OTA_SERVICE_FH_STATE_VERIFY;
                }
                else
                {
                    otaFileHandlerData.state = OTA_SERVICE_FH_STATE_MSG_RECV;
                }
</#if>
            }
            break;
        }

        case OTA_SERVICE_FH_STATE_VERIFY:
        {
            uint32_t crc32;
            uint32_t *received_crc32 = (void *)otaFileHandlerData.fileHeader.signature;
<#if DRIVER_USED != NVM_MEM_USED>
            uint32_t dataSize = DATA_SIZE;
            uint32_t imageSize = 0U;

            otaFileHandlerData.memoryAddress = otaFileHandlerData.fileHeader.loadAddress;
            crc32 = 0xFFFFFFFFU;
            while (imageSize < otaFileHandlerData.fileHeader.imageSize)
            {

                (void)${DRIVER_USED}_Read(otaFileHandlerData.handle, &flash_data[0], dataSize, otaFileHandlerData.memoryAddress);

                (void)OTA_SERVICE_FH_WaitForXferComplete();

                crc32 = OTA_SERVICE_FH_CRCGenerate(&flash_data[0], dataSize, crc32);

                otaFileHandlerData.memoryAddress += dataSize;
                imageSize += dataSize;

                if ((otaFileHandlerData.fileHeader.imageSize - imageSize) < dataSize)
                {
                    dataSize = (otaFileHandlerData.fileHeader.imageSize - imageSize);
                }
            }
<#else>

            crc32 = OTA_SERVICE_FH_CRCGenerate(otaFileHandlerData.fileHeader.programAddress, otaFileHandlerData.fileHeader.imageSize);
</#if>

            if (crc32 == *received_crc32)
            {
                otaFileHandlerData.state = OTA_SERVICE_FH_STATE_CB_WRITE;
            }
            else
            {
                otaFileHandlerData.state = OTA_SERVICE_FH_STATE_IDLE;
            }
            break;
        }

        case OTA_SERVICE_FH_STATE_CB_WRITE:
        {
<#if DRIVER_USED != NVM_MEM_USED>
            (void)OTA_SERVICE_FH_CtrlBlkRead(otaFileHandlerData.controlBlock, ctrlBlkSize);

            otaFileHandlerData.controlBlock->ActiveImageNum++;
            if (otaFileHandlerData.controlBlock->ActiveImageNum >= ${NUM_OF_APP_IMAGE}U)
            {
                otaFileHandlerData.controlBlock->ActiveImageNum = 0U;
            }
<#else>
            otaFileHandlerData.controlBlock->ActiveImageNum = 0U;
</#if>
            otaFileHandlerData.controlBlock->versionNum = 0U;
            otaFileHandlerData.controlBlock->blockUpdated = 1U;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].imageType = otaFileHandlerData.fileHeader.imageType;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].status = otaFileHandlerData.fileHeader.status;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].programAddress = otaFileHandlerData.fileHeader.programAddress;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].jumpAddress = otaFileHandlerData.fileHeader.jumpAddress;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].loadAddress = otaFileHandlerData.fileHeader.loadAddress;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].imageSize = otaFileHandlerData.fileHeader.imageSize;
            otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].signaturePresent = 1U;
            (void)memcpy(otaFileHandlerData.controlBlock->appImageInfo[otaFileHandlerData.controlBlock->ActiveImageNum].signature, otaFileHandlerData.fileHeader.signature, sizeof(otaFileHandlerData.fileHeader.signature));

            if (OTA_SERVICE_FH_CtrlBlkWrite(otaFileHandlerData.controlBlock, ctrlBlkSize) == false)
            {
                otaFileHandlerData.state = OTA_SERVICE_FH_STATE_ERROR;
            }
            else
            {
                otaFileHandlerData.state = OTA_SERVICE_FH_STATE_IDLE;
            }
            break;
        }

        case OTA_SERVICE_FH_STATE_IDLE:
        {
            break;
        }

        case OTA_SERVICE_FH_STATE_ERROR:
        default:
        {
            // Do nothing
            break;
        }
    }
}
