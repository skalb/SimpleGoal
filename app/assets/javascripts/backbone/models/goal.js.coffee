class SimpleGoal.Models.Goal extends Backbone.Model
  paramRoot: 'goal'

  defaults:
    name: null

class SimpleGoal.Collections.GoalsCollection extends Backbone.Collection
  model: SimpleGoal.Models.Goal
  url: '/goals'
