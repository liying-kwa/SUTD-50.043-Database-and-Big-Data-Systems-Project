from flask import Flask, render_template, request, url_for, redirect, session, jsonify
from flask_pymongo import PyMongo
from flask_paginate import Pagination, get_page_parameter
from bson.objectid import ObjectId
from functools import wraps
from mongofirebase import get_ssh_address
import datetime

#import mysqlpython

app = Flask(__name__)

mongo_username = "user"
mongo_password = "password"
metadata_ssh = get_ssh_address('metadata')
logs_ssh = get_ssh_address('logs')
app.secret_key = "secretkey"

try:
    metadata_db = PyMongo(app, uri='mongodb://'+ mongo_username + ':' + mongo_password  + '@'+ metadata_ssh +':27017/myMongodb?authSource=admin').db["new_kindle_metadata"]
    user_db = PyMongo(app, uri='mongodb://'+ mongo_username + ':' + mongo_password  + '@'+ logs_ssh +':27017/myMongodb?authSource=admin').db["user"]
    logs_db = PyMongo(app, uri='mongodb://'+ mongo_username + ':' + mongo_password + '@'+ logs_ssh +':27017/myMongodb?authSource=admin').db["logs_collection"]
    # metadata_db = PyMongo(app, uri='mongodb+srv://temp-user:Cjzo1XnTvJin5tX1@dbbd.0m9ic.mongodb.net/project').db['metadata']
    # user_db = PyMongo(app, uri='mongodb+srv://temp-user:Cjzo1XnTvJin5tX1@dbbd.0m9ic.mongodb.net/project').db['user']
    # logs_db = PyMongo(app, uri='mongodb+srv://temp-user:Cjzo1XnTvJin5tX1@dbbd.0m9ic.mongodb.net/project').db['logs']
    # UNCOMMENT WHEN MySQL IS UP
    # mysql_db = mysqlpython.mysql_review()
except Exception as e:
    print(e)

# Routes
import routes

def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged-in' in session:
            return f(*args, **kwargs)
        else:
            return render_template('index.html', show_login=True)

@app.route('/')
def index():
    # TODO: To define how we are going limit the entries
    books_list = metadata_db.find({'title': {"$regex": 'Hadoop' , "$options": "i"}}).limit(4)
    return render_template('index.html', books=books_list, query=None, pagination=None)

@app.route('/book/<asin>')
def book(asin):
    book = metadata_db.find_one({'asin': asin})
    # UNCOMMENT WHEN MySQL IS UP
    #review_text = mysql_db.get_review_by_asin(asin)
    if 'logged-in' in session:
        logs_db.insert_one({"user": session['user']['email'], "action":"view", "content": book['title'], "datetime": datetime.datetime.now()})
        print("Logged")
    return render_template('book.html', book=book) # add review_text into render_template

@app.route('/book/add_review/<asin>', methods=['POST'])
#@login_required
def add_review(asin):
    # retrieve new user review from the html input
    reviewText = request.form.get("Comment")
    summary = request.form.get("Title")
    print("Inside add review")

    if(reviewText == ""):
        return jsonify({"error": "Comment cannot be empty"}), 401
    if(summary == ""):
        return jsonify({"error": "Title cannot be empty"}), 401
    #overall = request.form.get("overall") # should be an int from 1-5
    helpful = [0,0] # first int is number of people who rated this review helpful, second int is total number of ratings
    
    print(reviewText, summary)

    # TODO: get reviewerName from user who is logged in
    # TODO: get reviewerID from user who is logged in
    if 'logged-in' in session:
        reviewerID = session['user']['_id']
        reviewerName = session['user']['name']
        logs_db.insert_one({"user": session['user']['email'], "action":"add_review", "content": reviewText, "datetime": datetime.datetime.now()})
        print("ReviewerID:", reviewerID)
        print("ReviewerName:", reviewerName)

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

    return jsonify({"success": "Added new review"}), 200

@app.route('/add', methods=['POST'])
def add_book():
    # new_todo = request.form.get('new-todo')
    # metadata_db.insert_one({'text' : new_todo, 'complete' : False})
    return redirect(url_for('index'))

@app.route('/search', methods=['POST'])
def search():
    # 'asin': 'B000FA5S98'
    # search_item = metadata_db.find_one({'_id': ObjectId(oid)})
    # metadata_db.save(todo_item)
    search_input = request.form['search-book']
    if 'logged-in' in session:
        logs_db.insert_one({"user": session['user']['email'], "action":"search", "content": search_input, "datetime": datetime.datetime.now()})
        print("Logged")
    return redirect(url_for('results', query = search_input))

@app.route('/search/<query>')
def results(query):
    per_page = 12
    page = request.args.get(get_page_parameter(), type=int, default=1)
    search_results = metadata_db.find({'$or': [{'title': {"$regex": query , "$options": "i"}}, {'author': {"$regex": query , "$options": "i"}}]}).skip((page - 1) * per_page).limit(per_page)
    pagination = Pagination(page=page, per_page=per_page ,total=search_results.count(), search=False, record_name='search_results')
    return render_template("index.html", books=search_results, query=query, pagination=pagination)

@app.route('/genre/<query>')
def category(query):
    per_page = 12
    page = request.args.get(get_page_parameter(), type=int, default=1)
    search_results = metadata_db.find({'genre': {"$regex": query , "$options": "i"}}).skip((page - 1) * per_page).limit(per_page)
    pagination = Pagination(page=page, per_page=per_page ,total=search_results.count(), search=False, record_name='search_results')
    return render_template("index.html", books=search_results, query=None, pagination=pagination)

@app.route('/logs', methods=['GET'])
def logs():
    logs = logs_db.find().sort('datetime', -1)
    return render_template('logs.html', logs=logs)

@app.errorhandler(404)
def not_found(error):
    if request.method == 'POST':
        return redirect(url_for('index'))
    else:
        return render_template('not_found.html'), 404

@app.route('/checksignedin')
def checksignedin():
    if 'logged-in' in session:
        return redirect(url_for('index'))
    else:
        return render_template('index.html', pagination=None, show_register=True)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port='80', debug=True)