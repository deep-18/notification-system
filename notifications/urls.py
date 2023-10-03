from django.conf.urls.static import static
from django.urls import path
from notifications import views
from notification_system import settings
from django.contrib.auth.views import LogoutView

app_name = 'myapp'
urlpatterns = [
     path('', views.notification_list, name='index'),
     path('register/', views.register, name='register'),
     path('login/', views.user_login, name='login'),
     path('create_notification/', views.create_notification, name='create_notification'),
     path('mark_as_read/', views.mark_as_read, name='mark_as_read'),
     path('logout/', LogoutView.as_view(), name='logout')
]

# if settings.DEBUG:
#     urlpatterns += static(settings.MEDIA_URL,
#                           document_root=settings.MEDIA_ROOT)