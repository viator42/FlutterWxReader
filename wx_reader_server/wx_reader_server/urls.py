"""wx_reader_server URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views

urlpatterns = [
    # path('admin/', admin.site.urls),
    path('app/news/', views.listNews, name='listNews'),
    path('app/news/detail/', views.newsDetail, name='newsDetail'),
    path('app/book/detail/', views.bookDetail, name='bookDetail'),
    path('app/book/comment/', views.bookComment, name='bookComment'),
    path('app/book/category/', views.bookCategory, name='bookCategory'),
    path('app/book/category/books/', views.categoryBooks, name='categoryBooks'),
    path('app/book/recommend/', views.bookRecommend, name='bookRecommend'),
    path('app/book/guessYouLike/', views.guessYouLike, name='guessYouLike'),
    path('app/explorer/', views.explorer, name='explorer'),
    path('app/user/login/', views.userLogin, name='userLogin'),
]
