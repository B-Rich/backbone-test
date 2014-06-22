class TodoList extends Backbone.Collection
	model: Todo
	url: '/todos'
	
	comparator: (todo) ->
		(new Date(todo.get('date'))).getTime()
