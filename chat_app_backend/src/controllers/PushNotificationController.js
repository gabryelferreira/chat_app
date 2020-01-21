const axios = require('axios').default;

class PushNotificationController {

    async send(title, body, fcmToken, data) {
        if (!title || !body || !fcmToken) return;
        try {
            axios.post('https://fcm.googleapis.com/fcm/send',
                {
                    notification: {
                        body,
                        title
                    },
                    priority: 'high',
                    data: {
                        ...data,
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        sound: "default",
                    },
                    to: fcmToken
                },
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `key=${process.env.FCM_SERVER_TOKEN}`,
                    }
                }
            )
        } catch (e) {
            console.log("error push notification");
            console.log(e);
        }
    }

}

module.exports = new PushNotificationController();
