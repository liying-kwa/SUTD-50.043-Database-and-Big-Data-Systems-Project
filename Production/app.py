from flask import Flask, render_template, request, url_for, redirect
from flask_pymongo import PyMongo
from bson.objectid import ObjectId

app = Flask(__name__)

# TODO: Shift this into an external constant file 
app.config['MONGO_URI'] = 'mongodb+srv://temp-user:Cjzo1XnTvJin5tX1@dbbd.0m9ic.mongodb.net/project?retryWrites=true&w=majority'
app.secret_key = "secretkey"

try:
    mongo = PyMongo(app)
    database = mongo.db["metadata"]
    user_db = mongo.db["user"]
    
except Exception as e:
    print(e)

# Routes
import routes

@app.route('/')
def index():
    # TODO: To define how we are going limit the entries
    books_list = database.find().limit(10)
    return render_template('index.html', books=books_list, query=None)

@app.route('/books')
def books():
    books_list = database.find().limit(50)
    return render_template('index.html', books=books_list, query=None)

@app.route('/book/<asin>')
def book(asin):
    print(asin)
    book = database.find_one({'asin': asin})
    return render_template('book.html', book=book)      

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
    search_results = database.find({'asin': {"$regex": query , "$options": "i"}}).limit(10)
    print(query)
    return render_template("index.html", books=search_results, query=query)

@app.errorhandler(404)
def not_found(error):
    if request.method == 'POST':
        return redirect(url_for('index'))
    else:
        return render_template('not_found.html'), 404

if __name__ == '__main__':
    app.run(host='127.0.0.1', debug=True)