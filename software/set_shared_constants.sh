#!/usr/bin/env zsh

# Single source of truth for UUIDs and Passswords that will be shared accross the software suite. Run uuidgen to make uuid.

SERVICE_UUID="0e2bd58b-72c5-47ea-ab2a-04ce94908a6d"
PASSWORD="RY812"
COMMAND_INPUT_CHARACTERISTIC_UUID="409a87f8-726d-49dc-8c1b-187e5fbedc4b"
PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID="f8433557-305a-45b9-9ed3-4d0d74abc11d"


SWIFT_FILE_CODE="let SERVICE_UUID=\"$SERVICE_UUID\" \nlet PASSWORD=\"$PASSWORD\" \nlet COMMAND_INPUT_CHARACTERISTIC_UUID=\"$COMMAND_INPUT_CHARACTERISTIC_UUID\" \nlet PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID=\"$PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID\""
CPP_FILE_CODE="$(echo $SWIFT_FILE_CODE | sed 's/let/#define/g' | sed 's/=/ /g')"
JS_FILE_CODE="{\n$(echo $SWIFT_FILE_CODE | sed 's/let /  "/g' | sed 's/=/":/g' | sed 's/" /",/g' )\n}"

echo "Swift"
echo $SWIFT_FILE_CODE
echo "C++"
echo $CPP_FILE_CODE
echo "JS"
echo $JS_FILE_CODE

# 1. ios app

# playground 
echo $SWIFT_FILE_CODE > simple-ios-keyfob/playgrounds/carkey-app.swiftpm/SecretConstants.swift 
# xc project
echo $SWIFT_FILE_CODE > simple-ios-keyfob/xcode/carkey-app/carkey-app/SecretConstants.swift 



# 2. companion-esp32

echo $CPP_FILE_CODE > companion-esp32/src/SecretConstants.h

echo $JS_FILE_CODE > companion-esp32/ble_tests/nodejs/SecretConstants.json

