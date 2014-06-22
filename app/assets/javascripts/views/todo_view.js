// Generated by CoffeeScript 1.6.2
var TodoView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TodoView = (function(_super) {
  __extends(TodoView, _super);

  function TodoView() {
    _ref = TodoView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TodoView.prototype.className = 'todo';

  TodoView.prototype.events = {
    'change input': 'toggleStatus',
    'click .destroy': 'destroy'
  };

  TodoView.prototype.template = _.template('<button class="destroy">&times;</button>' + '<h3 class="' + '<% if(done) print("done") %>">' + '<input type="checkbox"' + '<% if(done) print("checked") %>/>' + '<a href="/todos/<%= id %>"><%= content %></a></h3>');

  TodoView.prototype.initialize = function() {
    this.model.on('change', this.render, this);
    return this.model.on('destroy', this.remove, this);
  };

  TodoView.prototype.toggleStatus = function() {
    return this.model.toggleStatus();
  };

  TodoView.prototype.destroy = function() {
    return this.model.destroy();
  };

  TodoView.prototype.render = function() {
    return this.$el.html(this.template(this.model.toJSON()));
  };

  return TodoView;

})(Backbone.View);
