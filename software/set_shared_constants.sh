#!/usr/bin/env bash

# Single source of truth for UUIDs and Passswords that will be shared accross the software suite. Run uuidgen to make uuid.

SERVICE_UUID="0e2bd58b-72c5-47ea-ab2a-04ce94908a6d"
PASSWORD="RY812"







# 1. ios app

# playground 
echo "let SERVICE_UUID=\"$SERVICE_UUID\"" > simple-ios-keyfob/playgrounds/carkey-app.swiftpm/SecretConstants.swift 
echo "let PASSWORD=\"$SERVICE_UUID\"" >> simple-ios-keyfob/playgrounds/carkey-app.swiftpm/SecretConstants.swift 

# xc project
echo "let SERVICE_UUID=\"$SERVICE_UUID\"" > simple-ios-keyfob/xcode/carkey-app/carkey-app/SecretConstants.swift 
echo "let PASSWORD=\"$SERVICE_UUID\"" >> simple-ios-keyfob/xcode/carkey-app/carkey-app/SecretConstants.swift 



# 2. companion-esp32

echo "#define SERVICE_UUID \"$SERVICE_UUID\"" > companion-esp32/src/SecretConstants.h
echo "#define PASSWORD \"$PASSWORD\"" >> companion-esp32/src/SecretConstants.h



