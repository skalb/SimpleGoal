class App.Goal extends Spine.Model
  @configure 'Goal', 'name', 'goal_id'

  @extend Spine.Model.Ajax

  @hasMany 'targets', 'App.Target'
  @hasMany 'entries', 'App.Entry'
