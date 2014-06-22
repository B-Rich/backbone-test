from lib import appengine
from app.models.todo import Todo

class TodoListController(appengine.ListController):
	url = '/todos'
	model = Todo

class TodoItemController(appengine.ItemController):
	url = '/todos/([0-9]+)'
	model = Todo
