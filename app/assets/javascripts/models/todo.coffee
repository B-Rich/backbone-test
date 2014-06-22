class Todo extends Backbone.Model
	urlRoot: '/todos'
	
	# Function wrap prevents Date from evaluating
	defaults: ->
		done: false
		date: new Date
	
	toggleStatus: ->
		if @get('done')
			@set('done':false)
		else
			@set('done':true)
			
		@save()
