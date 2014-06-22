from lib import appengine

# Shortcut for ndb library
ndb = appengine.ndb

class Todo(appengine.Model):
	content = ndb.StringProperty()
	done = ndb.BooleanProperty()
	date = ndb.StringProperty()
