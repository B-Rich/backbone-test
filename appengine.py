import os
import re
import json

import webapp2
import jinja2

from google.appengine.ext import ndb


# Jinja2 variables
template_dir = os.path.join(os.path.dirname(__file__))
jinja_env    = jinja2.Environment(loader = jinja2.FileSystemLoader(template_dir))


def render_str(template, **params):
	"""Return a rendered Jinja2 template."""
	return jinja_env.get_template(template).render(params)

def set_jinja2_options(**kw):
	"""Change any Jinja2 settings.
	
	See the Jinja2 documentation for details: http://jinja.pocoo.org/docs/
	
	"""
	global jinja_env
	jinja_env = jinja2.Environment(loader = jinja2.FileSystemLoader(template_dir), **kw)

def set_templates_location(*path):
	"""Change the default location of the templates.
	
	Multiple arguments are used to support os.path.join.
	
	"""
	global template_dir
	template_dir = os.path.join(os.path.dirname(__file__), *path)
	set_jinja2_options()


class Application(webapp2.WSGIApplication):
	"""Application class."""

	def __init__(self, controllers, **kw):
		super(Application, self).__init__([(c.url,c) for c in controllers],**kw)


class Model(ndb.Model):
	"""Model class.
	Some rails-flavor methods are included as well.
	"""

	@classmethod
	def all(cls):
		"""Get all the model's entities from the datastore."""
		return cls.query().fetch()

	@classmethod
	def find(cls, _id):
		"""Get the entity by the given id."""
		return ndb.Key(cls, _id).get()

	@classmethod
	def create(cls, **kw):
		"""Create a new instance of the model and return it."""
		new_entity = cls(**kw)
		new_entity.put()
		return new_entity

	def destroy(self):
		"""Destroy the entity."""
		self.key.delete()

	def get_id(self):
		return self.key.id()
	
	def to_dict(self):
		keys = self.__class__._properties.keys()
		properties_dict = {k:getattr(self,k) for k in keys}
		id_dict = {'id': self.get_id()}
		return dict(id_dict.items() + properties_dict.items())
	
	@classmethod
	def get_resources(cls):
		"""Overridable."""
		return cls.all()

	def json(self):
		return json.dumps(self.to_dict())


class Controller(webapp2.RequestHandler):
	template = None
	url = None

	def render(self, template, **params):
		"""Render a jinja2 template and write it to the response."""
		self.response.out.write(render_str(template, **params))

	def get(self):
		self.render(self.template)


class ListController(webapp2.RequestHandler):
	model = None
	url = None

	def get(self):
		resources = [i.to_dict() for i in self.model.get_resources()]
		self.request.headers['Content-Type'] = 'application/json'
		self.response.out.write(json.dumps(resources))

	def post(self):
		data = json.loads(self.request.body)
		entity = self.model.create(**data)
		self.request.headers['Content-Type'] = 'application/json'
		self.response.out.write(entity.json())


class ItemController(webapp2.RequestHandler):
	model = None
	url = None
	
	def get(self, _id):
		entity = self.model.get_by_id(int(_id))
		if entity:
			self.request.headers['Content-Type'] = 'application/json'
			self.response.out.write(entity.json())
		else:
			self.error(404)
	
	def put(self, _id):
		entity = self.model.get_by_id(int(_id))
		if entity:
			data = json.loads(self.request.body)
			for key in data:
				setattr(entity, key, data[key])
			entity.put()
			self.request.headers['Content-Type'] = 'application/json'
			self.response.out.write(entity.json())
		else:
			self.error(404)
	
	def delete(self, _id):
		resource = self.model.get_by_id(int(_id))
		resource.destroy()

