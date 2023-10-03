# notifications/consumers.py

import json
from channels.generic.websocket import AsyncWebsocketConsumer

class NotificationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()

    async def disconnect(self, close_code):
        pass

    async def receive(self, text_data):
        data = json.loads(text_data)
        message_type = data['type']

        if message_type == 'notification':
            # Handle incoming notification data here
            notification_message = data['message']

            # Send a response back to the client (optional)
            await self.send(json.dumps({
                'type': 'response',
                'message': 'Notification received.',
            }))
