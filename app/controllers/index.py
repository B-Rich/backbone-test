from lib import appengine

class MainController(appengine.Controller):
	url = '/'
	template = 'index.html'
