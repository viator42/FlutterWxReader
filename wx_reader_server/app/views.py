from django.shortcuts import render
from django.http import HttpResponse
import json
from app.models import *

'''
(done
'''
def listNews(request):
    if request.method == 'GET':
        page = request.GET.get('page')
        news_list = []

        offset = 10
        start = int(page) * offset

        newsObjs = News.objects.all()[start: start + offset]
        for newsObj in newsObjs:
            news = resolveNewsModel(newsObj)

            news_list.append(news)

    return HttpResponse(json.dumps(news_list))

'''
(done
'''
def newsDetail(request):
    result = {}
    result['success'] = False

    if request.method == 'GET':
        id = request.GET.get('id')

        newsObj = News.objects.get(id=id)
        if(newsObj != None):
            news = resolveNewsModel(newsObj)
            news['content'] = newsObj.content

            result['news'] = news
            result['success'] = True
        else:
            result['success'] = False
            result['msg'] = '加载失败'

    return HttpResponse(json.dumps(result))

'''
(done
'''
def bookDetail(request):
    result = {}
    result['success'] = False

    if request.method == 'GET':
        id = request.GET.get('id')

        bookObj = Book.objects.get(id=id)
        if(bookObj != None):
            result['success'] = True
            result['book'] = resolveBookModel(bookObj)

    return HttpResponse(json.dumps(result))

'''
图书评论
'''
def bookComment(request):
    result = []
    if request.method == 'GET':
        book = request.GET.get('book')
        bookCommentObjs = BookComment.objects.filter(book=book)
        for bookCommentObj in bookCommentObjs:
            item = {}
            item['id'] = bookCommentObj.id
            item['author'] = bookCommentObj.author
            item['headimg'] = '/static/img/headimg/' + bookCommentObj.headimg
            item['content'] = bookCommentObj.content
            item['like'] = bookCommentObj.like
            item['book'] = bookCommentObj.book

            result.append(item)

    return HttpResponse(json.dumps(result))

'''
(done
'''
def bookCategory(request):
    if request.method == 'GET':
        category_list = []

        categoryObjs = Category.objects.all()
        for categoryObj in categoryObjs:
            category = {}
            category['id'] = categoryObj.id
            category['name'] = categoryObj.name
            category['desp'] = categoryObj.desp

            category_list.append(category)

    return HttpResponse(json.dumps(category_list))

'''
(done
'''
def categoryBooks(request):
    book_list = []

    if request.method == 'GET':
        category = request.GET.get('category')
        page = request.GET.get('page')

        offset = 10
        start = int(page) * offset

        if category != '0':
            bookObjs = Book.objects.filter(cateory=category)[start: start + offset]
        else:
            bookObjs = Book.objects.all()[start: start + offset]

        for bookObj in bookObjs:
            book = resolveBookModel(bookObj)
            book_list.append(book)

    return HttpResponse(json.dumps(book_list))

'''
(donw
'''
def guessYouLike(request):
    book_list = []

    if request.method == 'GET':
        book_list = getRecommend()

    return HttpResponse(json.dumps(book_list))

'''
探索tab （done
'''
def explorer(request):
    result = {}
    if request.method == 'GET':
        pop = {}
        pop['title'] = '总有一个瞬间让我们热泪盈眶'
        pop['subtitle'] = '好书现时免费送'
        pop['background'] = '/static/img/panda.jpg'
        pop['url'] = 'https://www.baidu.com'

        result['pop'] = pop

        recommend = getRecommend()
        result['recommend'] = recommend

    result['showcase'] = getShowCases()

    return HttpResponse(json.dumps(result))

def bookRecommend(request):
    book_list = []

    if request.method == 'GET':
        book_list = getRecommend()

    return HttpResponse(json.dumps(book_list))

# 用户登录 (done
def userLogin(request):
    result = {}

    result['success'] = False
    result['msg'] = '登录失败'

    if request.method == 'POST':
        tel = request.POST.get('tel')
        password = request.POST.get('password')

        userObj = User.objects.get(tel=tel)
        if userObj != None:
            if userObj.password == password:
                result['user'] = resolveUserModel(userObj)
                result['success'] = True
            else:
                result['success'] = False
                result['msg'] = '密码错误'
        else:
            result['success'] = False
            result['msg'] = '用户不存在'

    return HttpResponse(json.dumps(result))

#------------------------------

def getBookCoverPath(url):
    return '/static/img/cover/'+ url

def getNewsImgPath(url):
    return '/static/img/news/'+ url

def resolveBookModel(bookObj):
    book = {}

    book['id'] = bookObj.id
    book['name'] = bookObj.name
    book['author'] = bookObj.author
    book['rank'] = float(bookObj.rank)
    book['star'] = bookObj.star
    book['fav'] = bookObj.fav
    book['brief'] = bookObj.brief
    book['originalPrice'] = float(bookObj.originalPrice)
    book['price'] = float(bookObj.price)
    book['content'] = bookObj.content
    book['cateory'] = bookObj.cateory
    book['cover'] = getBookCoverPath(bookObj.cover)
    book['ad'] = bookObj.ad

    return book

def resolveNewsModel(newsObj):
    news = {}

    news['id'] = newsObj.id
    news['title'] = newsObj.title
    news['brief'] = newsObj.brief
    news['img'] = getNewsImgPath(newsObj.img)

    return news

def getRecommend():
    book_list = []

    bookObjs = Book.objects.all()[0:4]
    for bookObj in bookObjs:
        book = resolveBookModel(bookObj)
        book_list.append(book)

    return book_list

def getShowCases():
    showcases = []

    bookObjs = Book.objects.all()[0:3]
    for bookObj in bookObjs:
        showcase = {}

        showcase['banner'] = getBookCoverPath(bookObj.cover)
        showcase['leading'] = getBookCoverPath(bookObj.cover)
        showcase['title'] = bookObj.name
        showcase['subtitle'] = bookObj.brief
        showcase['trailing'] = bookObj.ad

        showcases.append(showcase)

    return showcases

def resolveUserModel(userObj):
    user = {}

    user['id'] = userObj.id
    user['tel'] = userObj.tel
    user['nickname'] = userObj.nickname
    user['headimg'] = '/static/img/headimg/' + userObj.headimg
    user['desp'] = userObj.desp
    user['signing'] = userObj.signing

    return user