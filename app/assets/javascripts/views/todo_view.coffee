class TodoView extends Backbone.View
	className: 'todo'
	events:
		'change input': 'toggleStatus'
		'click .destroy': 'destroy'
	
	template: _.template( $('#todo-template').html() )
	
	initialize: ->
		@model.on('change', @render, @)
		@model.on('destroy', @remove, @)
	
	toggleStatus: ->
		@model.toggleStatus()
	
	destroy: ->
		@model.destroy()
	
	render: ->
		@$el.html( @template(@model.toJSON()) )
