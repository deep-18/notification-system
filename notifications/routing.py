# notifications/routing.py

from django.urls import re_path

from . import consumers
print(consumers.NotificationConsumer.as_asgi())
websocket_urlpatterns = [
    re_path(r'ws/notifications/$', consumers.NotificationConsumer.as_asgi()),
]
