adb shell am start -a android.intent.action.VIEW -d "https://darahat.dev/form/e861d390-654c-4e01-8837-09fa94fdb807" com.example.aiformbuilder

1.  Go to the App Signing page in your Google Play Console.
2.  Copy the SHA-256 certificate fingerprint for your production key.
3.  Add that new fingerprint to the sha256_cert_fingerprints list in your assetlinks.json file on your server.
