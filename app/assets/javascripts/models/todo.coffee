class Todo extends Backbone.Model
	urlRoot: '/todos'
	
	# Function wrap prevents Date from evaluating
	defaults: ->
		content: ''
		done: false
		date: new Date
	
	toggleStatus: ->
		@save(completed: !@get('completed'))
