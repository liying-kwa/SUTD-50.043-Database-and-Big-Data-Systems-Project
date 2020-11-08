from flask import Flask, render_template
from app import app
from models import User

@app.route('/account/signup', methods=['POST'])
def signup():
    return User().signup()

@app.route('/account', methods=['GET'])
def account():
    return render_template('signup.html')

@app.route('/user/login', methods=['POST'])
def login():
    return User().login()

@app.route('/user/signout')
def signout():
    return User().signout()

@app.route('/signin')
def signin():
    return render_template('login.html')