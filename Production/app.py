from flask import Flask, render_template, request, url_for, redirect, session
from flask_pymongo import PyMongo
from flask_paginate import Pagination, get_page_parameter
from bson.objectid import ObjectId
from functools import wraps
import time

#import mysqlpython

app = Flask(__name__)

# TODO: Shift this into an external constant file 
app.config['MONGO_URI'] = 'mongodb+srv://temp-user:Cjzo1XnTvJin5tX1@dbbd.0m9ic.mongodb.net/project?retryWrites=true&w=majority'
app.secret_key = "secretkey"

try:
    mongo = PyMongo(app)
    database = mongo.db["metadata"]
    user_db = mongo.db["user"]

    # UNCOMMENT WHEN MySQL IS UP
    # mysql_db = mysqlpython.mysql_review()

except Exception as e:
    print(e)

# Routes
import routes

@app.route('/')
def index():
    # TODO: To define how we are going limit the entries
    books_list = database.find().limit(4)
    return render_template('index.html', books=books_list, query=None, pagination=None)

@app.route('/book/<asin>')
def book(asin):
    book = database.find_one({'asin': asin})
    # UNCOMMENT WHEN MySQL IS UP
    #review_text = mysql_db.get_review_by_asin(asin)
    return render_template('book.html', book=book) # add review_text into render_template

@app.route('/book/add_review/<asin>')
#@login_required
def add_review(asin):
    book = database.find_one({'asin': asin})
    #TODO: add this review into the database

    # retrieve new user review from the html input
    
    # UNCOMMENT ALL THESE WHEN MYSQL DB IS UP AND RUNNING
    #reviewText = request.form.get("reviewText")
    #summary = request.form.get("summary")
    #overall = request.form.get("overall") # should be an int from 1-5
    #helpful = [0,0] # first int is number of people who rated this review helpful, second int is total number of ratings
    
    # TODO: get reviewerName from user who is logged in
    # TODO: get reviewerID from user who is logged in
    '''
    new_book_review = {
        'asin': asin, 
        'helpful': helpful, 
        'overall': overall, 
        'reviewText': reviewText,
        'reviewTime': reviewTime,
        'reviewerID': reviewerID,
        'reviewerName': reviewerName,
        'summary': summary,
        'unixReviewTime': unixReviewTime
    }
    '''
    #mysql_db.insert_new_review(asin, helpful, overall, reviewText, reviewerID, reviewerName, summary)

    return_url = 'book' + '/' + asin
    return redirect(url_for(return_url))

@app.route('/add', methods=['POST'])
def add_book():
    # new_todo = request.form.get('new-todo')
    # database.insert_one({'text' : new_todo, 'complete' : False})
    return redirect(url_for('index'))

@app.route('/search', methods=['POST'])
def search():
    # 'asin': 'B000FA5S98'
    # search_item = database.find_one({'_id': ObjectId(oid)})
    # database.save(todo_item)
    search_input = request.form['search-book']
    return redirect(url_for('results', query = search_input))

@app.route('/search/<query>')
def results(query):
    per_page = 12
    page = request.args.get(get_page_parameter(), type=int, default=1)
    search_results = database.find({'$or': [{'title': {"$regex": query , "$options": "i"}}, {'author': {"$regex": query , "$options": "i"}}]}).skip((page - 1) * per_page).limit(per_page)
    pagination = Pagination(page=page, per_page=per_page ,total=search_results.count(), search=False, record_name='search_results')
    return render_template("index.html", books=search_results, query=query, pagination=pagination)

@app.route('/cat/<query>')
def category(query):
    per_page = 12
    page = request.args.get(get_page_parameter(), type=int, default=1)
    search_results = database.find({'genre': {"$regex": query , "$options": "i"}}).skip((page - 1) * per_page).limit(per_page)
    print(search_results)
    pagination = Pagination(page=page, per_page=per_page ,total=search_results.count(), search=False, record_name='search_results')
    return render_template("index.html", books=search_results, query=query, pagination=pagination)

@app.errorhandler(404)
def not_found(error):
    if request.method == 'POST':
        return redirect(url_for('index'))
    else:
        return render_template('not_found.html'), 404

def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged-in' in session:
            return f(*args, **kwargs)
        else:
            return render_template('index.html', show_login=True)

@app.route('/checksignedin')
def checksignedin():
    if 'logged-in' in session:
        return redirect(url_for('index'))
    else:
        return render_template('index.html', pagination=None, show_register=True)
if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)