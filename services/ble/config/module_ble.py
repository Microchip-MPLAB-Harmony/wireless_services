# coding: utf-8
##############################################################################
# Copyright (C) 2019-2020 Microchip Technology Inc. and its subsidiaries.
#
# Subject to your compliance with these terms, you may use Microchip software
# and any derivatives exclusively with Microchip products. It is your
# responsibility to comply with third party license terms applicable to your
# use of third party software (including open source software) that may
# accompany Microchip software.
#
# THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
# EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
# WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
# PARTICULAR PURPOSE.
#
# IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
# INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
# WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
# BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
# FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
# ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
# THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
##############################################################################

def loadModule():
    print('Load Module: Harmony Wireless services')

    pic32cx_bz2_family = {'WBZ451'}

    pic32cx_bz3_family = {'WBZ351'}

    processor = Variables.get('__PROCESSOR')
    print('processor={}'.format(processor))

    if( processor in pic32cx_bz2_family or processor in pic32cx_bz3_family):
        print('family selected{}'.format(processor))
        # ble config service
        print("##############Processor Selected###########################")
        execfile(Module.getPath() + '/services/ble/ble_config/config/module_ble_config_service.py')
        execfile(Module.getPath() + '/services/ble/ble_custom_protocol/config/ble_custom_protocol_module.py')
        execfile(Module.getPath() + '/services/ble/trsp/config/module_trsp_service.py')
        execfile(Module.getPath() + '/services/ble/anp/config/module_anp_service.py')
        execfile(Module.getPath() + '/services/ble/hogp/config/module_hogp_service.py')
        execfile(Module.getPath() + '/services/ble/pxp/config/module_pxp_service.py')
        execfile(Module.getPath() + '/services/ble/ancs/config/module_ancs_service.py')
    else:
        print("no processor selected")


loadModule()