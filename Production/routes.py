from flask import Flask, render_template
from app import app
from models import User

@app.route('/account/signup', methods=['POST'])
def signup():
    print("signup new one")
    return User().signup()

@app.route('/account')
def account():
    return render_template('signup.html')
