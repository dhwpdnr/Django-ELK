from django.urls import path
from .views import ClientErrorAPI, ServerErrorAPI

urlpatterns = [
    path('400', ClientErrorAPI.as_view(), name='client-error-api'),
    path('500', ServerErrorAPI.as_view(), name='server-error-api'),
]
