const axios = require('axios').default;

class PushNotificationController {

    async sendNotification(title, body, fcmToken) {
        if (!title || !body || !fcmToken) return;

        axios.post('https://fcm.googleapis.com/fcm/send',
            {
                notification: {
                    body,
                    title
                },
                priority: 'high',
                data: {
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    id: "1",
                    status: "done"
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
    }

}

module.exports = new PushNotificationController();