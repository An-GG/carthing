#!/usr/bin/env bash

# Single source of truth for UUIDs and Passswords that will be shared accross the software suite. Run uuidgen to make uuid.

SERVICE_UUID="0e2bd58b-72c5-47ea-ab2a-04ce94908a6d"
PASSWORD="RY812"







# ios app

# playground 
echo "let SERVICE_UUID=\"$SERVICE_UUID\"" > simple-ios-keyfob/playgrounds/carkey-app.swiftpm/SecretConstants.swift 
echo "let PASSWORD=\"$SERVICE_UUID\"" >> simple-ios-keyfob/playgrounds/carkey-app.swiftpm/SecretConstants.swift 

# xc project
echo "let SERVICE_UUID=\"$SERVICE_UUID\"" > simple-ios-keyfob/xcode/carkey-app/carkey-app/SecretConstants.swift 
echo "let PASSWORD=\"$SERVICE_UUID\"" >> simple-ios-keyfob/xcode/carkey-app/carkey-app/SecretConstants.swift 




