const admin = require('firebase-admin/app');
const serviceAccountkey=require('./service_key.json');
admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccountkey),
        projectId: "to-do-list-272",


        //databaseUrl is needed for realtime database
   //     databaseURL: "https://to-do-list-272.firebaseio.com"
        
        

    }



);
admin.messaging().send({
    token: "device token",
    data: {
      hello: "world",
    },
    // Set Android priority to "high"
    android: {
      priority: "high",
    },
    // Add APNS (Apple) config
    apns: {
      payload: {
        aps: {
          contentAvailable: true,
        },
      },
      headers: {
        "apns-push-type": "background",
        "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
        "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
      },
    },
  });