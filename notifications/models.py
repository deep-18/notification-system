# Create your models here.
from django.db import models
from django.contrib.auth.models import User

class Notification(models.Model):
    id = models.IntegerField(primary_key=True, blank=False, null=False, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.CharField(max_length=255)
    is_read = models.BooleanField(default=False)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

