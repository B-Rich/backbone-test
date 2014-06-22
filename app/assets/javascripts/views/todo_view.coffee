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
		@model.on('change', @render, @)
		@model.on('destroy', @remove, @)
	
	toggleStatus: ->
		@model.toggleStatus()
	
	destroy: ->
		@model.destroy()
	
	render: ->
		@$el.html(this.template @model.toJSON())
