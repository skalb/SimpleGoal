$ = jQuery.sub()
Goal = App.Goal

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Goal.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('goals/new')

  back: ->
    @navigate '/goals'

  submit: (e) ->
    e.preventDefault()
    goal = Goal.fromForm(e.target).save()
    @navigate '/goals', goal.id if goal

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Goal.find(id)
    @render()
    
  render: ->
    @html @view('goals/edit')(@item)

  back: ->
    @navigate '/goals'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/goals'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Goal.find(id)
    @render()

  render: ->
    @html @view('goals/show')(@item)
    window.graphGoal(@item)

  edit: ->
    @navigate '/goals', @item.id, 'edit'

  back: ->
    @navigate '/goals'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Goal.bind 'refresh change', @render
    Goal.fetch()
    
  render: =>
    goals = Goal.all()
    @html @view('goals/index')(goals: goals)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/goals', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/goals', item.id
    
  new: ->
    @navigate '/goals/new'
    
class App.Goals extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/goals/new':      'new'
    '/goals/:id/edit': 'edit'
    '/goals/:id':      'show'
    '/goals':          'index'
    
  default: 'index'
  className: 'stack goals'