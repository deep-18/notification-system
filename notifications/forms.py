from django import forms
from .models import Notification
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User

class RegistrationForm(UserCreationForm):
    email = forms.EmailField(max_length=254, required=True, help_text='Enter a valid email address.')

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']

class NotificationForm(forms.ModelForm):
    class Meta:
        model = Notification
        fields = ['message']

class LoginForm(AuthenticationForm):
    class Meta:
        fields = ['username', 'password']