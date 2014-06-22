class TodoRouter extends Backbone.Router
	routes:
		'todos/:id': 'show'
		'': 'index'
	
	start: ->
		Backbone.history.start(pushState: true)
		
		# PushState for all `a` elements without data-bypass
		$(document).on 'click', 'a:not([data-bypass])', (evt) ->
			href = $(@).attr 'href'
			protocol = @protocol + '//';
			
			if href.slice(protocol.length) != protocol
				evt.preventDefault()
				Backbone.history.navigate(href, trigger:true)
	
	index: ->
		todoList = new TodoList
		todoList.fetch success: ->
			newTodoView = new NewTodoView(collection: todoList)
			todoListView = new TodoListView(collection: todoList)
			
			newTodoView.render()
			todoListView.render()
			
			$('#app').html(newTodoView.el)
			$('#app').append(todoListView.el)
	
	show: (url_id) ->
		todo = new Todo(id: url_id)
		todo.fetch
			success: ->
				todoView = new TodoView(model: todo)
				todoView.render()
				$('#app').html todoView.el
