from django.shortcuts import render

# Create your views here.
from django.shortcuts import render, redirect
# from .models import Notification
# from .forms import NotificationForm
import json
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from .forms import RegistrationForm, LoginForm
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from .models import Notification
from django.contrib.auth.models import User

def register(request):
    if request.method == 'POST':
        form = RegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)  # Automatically log in the user after registration
            return redirect('/')  # Redirect to the home page or any desired page
    else:
        form = RegistrationForm()
    return render(request, 'notifications/register.html', {'form': form})

def user_login(request):
    if request.method == 'POST':
        form = LoginForm(request, request.POST)
        if form.is_valid():
            login(request, form.get_user())
            return redirect('/')  # Redirect to the home page or any desired page after login
    else:
        form = LoginForm()
    return render(request, 'notifications/login.html', {'form': form})

@login_required
def notification_list(request):
    notifications = Notification.objects.filter(user=request.user)
    # for i in notifications:
    #     print(i.is)
        # i.is_read = True
    # notifications.save()
    return render(request, 'notifications/notification.html', {'notifications': notifications})

def mark_as_read(request):
    print(request.POST)
    id = request.POST.get('id')
    print(id)
    Notification.objects.filter(id=id).update(is_read=True)
    return redirect('/')
# def mark_as_read(request, notification_id):
#     notification = Notification.objects.get(id=notification_id)
#     notification.is_read = True
#     notification.save()
#     return redirect('notification_list')

# def send_notification(request):
#     if request.method == 'POST':
#         form = NotificationForm(request.POST)
#         if form.is_valid():
#             notification = form.save(commit=False)
#             notification.user = request.user
#             notification.save()
#             return redirect('notification_list')
#     else:
#         form = NotificationForm()
#     return render(request, 'notifications/send_notification.html', {'form': form})
@login_required
def create_notification(request):
    if request.method == 'POST':
        message = request.POST.get('message')
        user_fetched = request.POST.get('user')
        print(request.POST)
        print(user_fetched)
        user = User.objects.get(username=user_fetched)

        if message:
            # Create the notification
            notification = Notification.objects.create(user=user, message=message)

            # Trigger real-time notification broadcast to connected clients
           
            # channel_layer = get_channel_layer()

            # Group name based on the user's ID
           
            # group_name = f"user_{user.id}"

            # Send the notification data to the group
           
            # async_to_sync(channel_layer.group_add)(group_name, group_name)
            # async_to_sync(channel_layer.group_send)(
            #     group_name,
            #     {
            #         'type': 'notification',
            #         'notification_id': notification.id,
            #         'message': notification.message,
            #         'timestamp': notification.timestamp.isoformat(),
            #     }
            # )

            # async_to_sync(channel_layer.group_discard)(group_name, group_name)

            return JsonResponse({'success': True})
        else:
            return JsonResponse({'success': False, 'message': 'Message cannot be empty'})
    Users = User.objects.all()
    return render(request, 'notifications/create_notification.html',{'users': Users})
