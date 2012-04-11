class SimpleGoal.Models.Goal extends Backbone.Model
  paramRoot: 'goal'

  defaults:
    name: null
    id: null

  boot: ->
    @targets = new SimpleGoal.Collections.TargetsCollection([], {goal_url: this.url()});
    @entries = new SimpleGoal.Collections.EntriesCollection([], {goal_url: this.url()});

class SimpleGoal.Collections.GoalsCollection extends Backbone.Collection
  model: SimpleGoal.Models.Goal
  url: '/goals'
