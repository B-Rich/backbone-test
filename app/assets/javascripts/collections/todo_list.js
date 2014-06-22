// Generated by CoffeeScript 1.6.2
var TodoList, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TodoList = (function(_super) {
  __extends(TodoList, _super);

  function TodoList() {
    _ref = TodoList.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TodoList.prototype.model = Todo;

  TodoList.prototype.url = '/todos';

  TodoList.prototype.comparator = function(todo) {
    return (new Date(todo.get('date'))).getTime();
  };

  return TodoList;

})(Backbone.Collection);
