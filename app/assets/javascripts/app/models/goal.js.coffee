class App.Goal extends Spine.Model
  @configure 'Goal', 'name'
  @extend Spine.Model.Ajax
  @hasMany 'targets', 'App.Target'
  @hasMany 'entries', 'Entry'