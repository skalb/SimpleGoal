class App.Entry extends Spine.Model
  @configure 'Entry', 'value', 'date', 'goal_id'
  @extend Spine.Model.Ajax
  @belongsTo 'goal', 'Goal'

  @url: "/entries"