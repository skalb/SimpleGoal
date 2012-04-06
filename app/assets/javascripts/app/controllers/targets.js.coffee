$ = jQuery.sub()
Target = App.Target

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Target.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('targets/new')

  back: ->
    @navigate '/targets'

  submit: (e) ->
    e.preventDefault()
    target = Target.fromForm(e.target).save()
    @navigate '/targets', target.id if target

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Target.find(id)
    @render()
    
  render: ->
    @html @view('targets/edit')(@item)

  back: ->
    @navigate '/targets'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/targets'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Target.find(id)
    @render()

  render: ->
    @html @view('targets/show')(@item)

  edit: ->
    @navigate '/targets', @item.id, 'edit'

  back: ->
    @navigate '/targets'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Target.bind 'refresh change', @render
    Target.fetch()
    
  render: =>
    targets = Target.all()
    # @html @view('targets/index')(targets: targets)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/targets', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/targets', item.id
    
  new: ->
    @navigate '/targets/new'
    
class App.Targets extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/targets/new':      'new'
    '/targets/:id/edit': 'edit'
    '/targets/:id':      'show'
    '/targets':          'index'
    
  default: 'index'
  className: 'stack targets'