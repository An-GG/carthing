const fs = require('fs')
const noble = require('@abandonware/noble');
const SecretConstants = require("./SecretConstants.json");
const normalized_uuid = SecretConstants.SERVICE_UUID.replaceAll('-', '');

console.log("SecretConstants.js");
console.table(SecretConstants);
console.log(normalized_uuid);
console.log("------");
console.log("");

let devices = []


async function bt_unlock_lock_confirm_serial() {


    noble.on('discover', async (per)=> {
        if (!per.advertisement.serviceUuids) {
            return
        }
        console.log(
            " uuid: \t\t"+per.uuid+
            " signal: \t\t"+per.rssi+
            " name: \t"+per.advertisement.localName+
            " < "
        );

        let o  = {
            'id'            : per['id'          ] ,
            'uuid'          : per['uuid'        ] ,
            'address'       : per['address'     ] ,
            'addressType'   : per['addressType' ] ,
            'connectable'   : per['connectable' ] ,
            'scannable'     : per['scannable'   ] ,
            'advertisement' : per['advertisement'],
            'rssi'          : per['rssi'        ] ,
            'services'      : per['services'    ] ,
            'mtu'           : per['mtu'         ] ,
            'state'         : per['state'       ] ,
        }

        devices.push(o.advertisement)
        if (per.advertisement.serviceUuids.includes(normalized_uuid)) {
            console.table(o.advertisement);
            console.table(o);
            await per.connectAsync();
            let res = await per.discoverAllServicesAndCharacteristicsAsync();
            console.table(res);
            console.table(per);
            return
        }
    })

    noble.startScanning()

}


bt_unlock_lock_confirm_serial();
