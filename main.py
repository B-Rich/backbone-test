from lib.appengine import Application
from lib.utils import get_controllers


# Get all controllers in the specified modules
controllers = get_controllers([
	'index',
	'todo',
])

app = Application(controllers, debug=True)
