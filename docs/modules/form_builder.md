adb shell am start -a android.intent.action.VIEW -d "https://darahat.dev/form/12a7d23d-d0fb-4c15-b19d-5993bcda2dab" com.example.aiformbuilder

1.  Go to the App Signing page in your Google Play Console.
2.  Copy the SHA-256 certificate fingerprint for your production key.
3.  Add that new fingerprint to the sha256_cert_fingerprints list in your assetlinks.json file on your server.
