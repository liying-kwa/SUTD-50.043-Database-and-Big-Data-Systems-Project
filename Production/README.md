# Production System

Installing
----------

Install and update using `pip`_:

.. code-block:: text

    pip install -U Flask
	pip install Flask-PyMongo
	pip install pymongo[srv]
	pip install pyrebase4
	pip install flask_login
	pip install flask-paginate


A Simple Example
----------------

.. code-block:: python

    from flask import Flask

    app = Flask(__name__)

    @app.route("/")
    def hello():
        return "Hello, World!"

.. code-block:: text

    $ env FLASK_APP=hello.py flask run
     * Serving Flask app "hello"
     * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)

