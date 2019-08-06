# -*- coding: utf-8 -*-

from django.db import models

# 消息
class News(models.Model):
    title = models.CharField(max_length=128, null=False)
    brief = models.CharField(max_length=512, null=True)
    content = models.TextField()
    img = models.CharField(max_length=128)

# 图书
class Book(models.Model):
    name = models.CharField(max_length=128, null=False)
    author = models.CharField(max_length=128, null=False)
    rank = models.DecimalField(max_digits=4, decimal_places=2, null=False, default=0.0)
    star = models.IntegerField(null=False, default=0)
    fav = models.IntegerField(null=False, default=0)
    brief = models.TextField(null=True)
    originalPrice = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    price = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    content = models.TextField(null=True)
    cateory = models.IntegerField(null=False, default=0)
    cover = models.CharField(null=True, max_length=128)
    ad = models.CharField(null=True, max_length=512)

class Category(models.Model):
    name = models.CharField(max_length=32, null=False)
    desp = models.CharField(max_length=256, null=True)

class BookComment(models.Model):
    book = models.IntegerField(null=False, default=0)
    content = models.TextField(null=False)
    like = models.IntegerField(null=False, default=0)
    author = models.TextField(null=True, default='匿名用户')
    headimg = models.CharField(null=True, max_length=128, default='')

class User(models.Model):
    tel = models.CharField(null=False, max_length=32)
    password = models.CharField(null=False, max_length=512)
    nickname = models.CharField(null=True, max_length=64, default='新用户')
    headimg = models.CharField(null=True, max_length=128, default='')
    desp = models.CharField(null=True, max_length=256)
    signing = models.CharField(null=True, max_length=256)

