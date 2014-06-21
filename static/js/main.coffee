class Todo extends Backbone.Model
	urlRoot: '/todos'
	
	# Function wrap prevents Date from evaluating
	defaults: ->
		done: false
		date: new Date
	
	toggleStatus: ->
		if @get 'done'
			@set 'done':false
		else
			@set 'done':true
			
		@save()


class TodoList extends Backbone.Collection
	model: Todo
	url: '/todos'
	
	comparator: (todo) ->
		(new Date(todo.get 'date')).getTime()


class TodoView extends Backbone.View
	className: 'todo'
	events:
		'change input': 'toggleStatus'
		'click .destroy': 'destroy'
	
	# Feo
	template: _.template '<button class="destroy">&times;</button>' +
	    '<h3 class="' +
		'<% if(done) print("done") %>">' +
		'<input type="checkbox"' +
		'<% if(done) print("checked") %>/>' +
		'<a href="/todos/<%= id %>"><%= content %></a></h3>'
	
	initialize: ->
		@model.on 'change', @render, @
		@model.on 'destroy', @remove, @
	
	toggleStatus: ->
		@model.toggleStatus()
	
	destroy: ->
		@model.destroy()
	
	render: ->
		@$el.html this.template(@model.toJSON())


class NewTodoView extends Backbone.View
	id: 'new-todo'
	events:
		'click button': 'addTodo'
	
	template: '<form method="post"><input id="text"/>' +
		'<button type="submit">+</button></form>',
	
	initialize: ->
		@collection.on 'add', @clearInput, @
	
	addTodo: (evt) ->
		evt.preventDefault()
		
		# create() is not used since it wont't load the id
		todo = new Todo(content: @$('#text').val())
		ctx = @
		todo.save {},
			success: ->
				ctx.collection.add todo
	
	clearInput: ->
		@$('#text').val ''
	
	render: ->
		@$el.html this.template


class TodoListView extends Backbone.View
	id: 'todos'
	
	initialize: ->
		@collection.on 'add', @appendTodo, @
		@collection.on 'reset', @addAll, @
	
	appendTodo: (todo) ->
		todoView = new TodoView(model:todo)
		todoView.render()
		@$el.append todoView.el
	
	addAll: ->
		
		# Calling sort() here seems to fix the comparator 
		# But it still doesn't work on the first load
		@collection.sort()
		
		@collection.forEach @appendTodo, @
	
	render: ->
		@addAll()


TodoRouter = new (Backbone.Router.extend
	routes:
		'todos/:id': 'show'
		'': 'index'
	
	initialize: ->
		@todoList = new TodoList
	
	start: ->
		Backbone.history.start(pushState: true)
		$(document).on 'click', 'a:not([data-bypass])', (evt) ->
			href = $(@).attr 'href'
			protocol = @protocol + '//';
			
			if href.slice(protocol.length) != protocol
				evt.preventDefault()
				Backbone.history.navigate(href, trigger:true)
	
	index: ->
		newTodoView = new NewTodoView(collection: this.todoList)
		todoListView = new TodoListView(collection: this.todoList)
		
		newTodoView.render()
		todoListView.render()
		
		$('#app').html newTodoView.el
		$('#app').append todoListView.el
		
		this.todoList.fetch()
	
	show: (url_id) ->
		todo = new Todo(id: url_id)
		todo.fetch
			success: ->
				todoView = new TodoView(model: todo)
				todoView.render()
				$('#app').html todoView.el
)


$ -> TodoRouter.start()
