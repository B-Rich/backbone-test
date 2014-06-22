class NewTodoView extends Backbone.View
	id: 'new-todo'
	events:
		'click button': 'addTodo'
	
	template: '<form method="post"><input id="text"/>' +
		'<button type="submit">+</button></form>',
	
	initialize: ->
		@collection.on('add', @clearInput, @)
	
	addTodo: (evt) ->
		evt.preventDefault()
		
		# create() is not used since it wont't load the id
		todo = new Todo(content: @$('#text').val())
		ctx = @
		todo.save {},
			success: ->
				ctx.collection.add(todo)
	
	clearInput: ->
		@$('#text').val('')
	
	render: ->
		@$el.html(this.template)
