const noble = require('@abandonware/noble');
const fs = require('fs')

let devices = []

noble.on('discover', (per)=> {
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
     //'services'      : per['services'    ] ,
     'mtu'           : per['mtu'         ] ,
     'state'         : per['state'       ] ,
    }

    devices.push(o.advertisement)
    console.table(o.advertisement);
    fs.writeFileSync('bt_devices.json', JSON.stringify(devices))    
})

noble.startScanning()

