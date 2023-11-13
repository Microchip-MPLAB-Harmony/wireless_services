"""*****************************************************************************
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
*****************************************************************************"""

unSupportedFamilies = ["SAM9", "SAMA5", "SAMA7"]

#Define OTA Service component names
WirelessSystemServicesComponents = [
    {"name":"ota_service", "label": "OTA Service", "dependency":["MEMORY", "Wireless"], "condition":"True"},
]

def loadModule():

    # Do not add OTA Service Component for unsupported families
    coreFamily   = ATDF.getNode( "/avr-tools-device-file/devices/device" ).getAttribute( "family" )
    if ((any(x == coreFamily for x in unSupportedFamilies) == True)):
        return
    print("Error!!!")
    print("Load Module: OTA_Service")

    for WirelessSystemServicesComponent in WirelessSystemServicesComponents:

        #check if component should be created
        if eval(WirelessSystemServicesComponent['condition']):
            Name        = WirelessSystemServicesComponent['name']

            displayPath = "/Wireless System Services/"


            Label       = WirelessSystemServicesComponent['label']
            filePath  = "config/" + Name + ".py"
            Component = Module.CreateComponent(Name, Label, displayPath, filePath )
            depIdPrefix = "ota_service_"


            if "dependency" in WirelessSystemServicesComponent:
                for dep in WirelessSystemServicesComponent['dependency']:

                    depId           = depIdPrefix + dep + "_dependency"
                    depDisplayName  = dep
                    depGeneric      = False
                    depRequired     = True

                    if (dep == "MEMORY"):
                        depDisplayName = "MEMORY (NVM)"

                    if ((Name == "ota_service") and (dep == "MEMORY")) == False:
                        Component.addDependency(depId, dep, depDisplayName, depGeneric, depRequired)

                    if ((Name == "ota_service") and (dep == "MEMORY")):
                        # Requires two Dependencies of same type (MEMORY)
                        Component.addDependency(depIdPrefix + dep + "_dependency_OTA", dep, "MEMORY (OTA)", False, True)

        Component.setDisplayType("OTA Service")
