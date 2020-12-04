from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin


class LoginForm(FlaskForm):
    username = StringField('Username')
    password = PasswordField('Password')
    submit = SubmitField('Submit')

    


db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
