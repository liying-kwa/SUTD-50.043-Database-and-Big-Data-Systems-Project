from flask import Flask, jsonify, request
from passlib.hash import pbkdf2_sha256
from app import user_db
import uuid

class User:

    def signup(self):

        # Creates the user object
        user = {
            "_id": uuid.uuid4().hex,
            "name": request.form.get('name'),
            "email": request.form.get('email'),
            "password": request.form.get('password')
        }

        print("New user signing up")
        return jsonify(user), 200

        # Encrypt the password
        #user['password'] = pbkdf2_sha256.encrypt(user['password'])
        
        '''
        # Check for existing email address
        if user_db.users.find_one({"email": user['email']}):
            print("Email already in use")
            return jsonify({"error": "Email address already in use"}), 400

        if user_db.insert_one(user):
            return jsonify(user), 200


        print("Signup failed")
        return jsonify({"error": "Signup failed"}), 400
        '''