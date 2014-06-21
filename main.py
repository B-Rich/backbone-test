import appengine

ndb = appengine.ndb


class Todo(appengine.Model):
	content = ndb.StringProperty()
	done = ndb.BooleanProperty()
	date = ndb.StringProperty()

class MainController(appengine.Controller):
	url = '/'
	template = 'index.html'

class TodoListController(appengine.ListController):
	url = '/todos'
	model = Todo

class TodoItemController(appengine.ItemController):
	url = '/todos/([0-9]+)'
	model = Todo


app = appengine.Application([

	# index.html
	MainController,

	# REST interface
	TodoListController,
	TodoItemController,

], debug=True)
