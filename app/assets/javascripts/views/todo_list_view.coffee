class TodoListView extends Backbone.View
	id: 'todos'
	
	initialize: ->
		@collection.on('add', @appendTodo, @)
		@collection.on('reset', @addAll, @)
	
	appendTodo: (todo) ->
		todoView = new TodoView(model:todo)
		todoView.render()
		@$el.append(todoView.el)
	
	addAll: ->
		
		# Calling sort() here seems to fix the comparator 
		# But it still doesn't work on the first load
		@collection.sort()
		
		@collection.forEach(@appendTodo, @)
	
	render: ->
		@addAll()
