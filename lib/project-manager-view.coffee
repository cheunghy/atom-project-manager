{$, $$, SelectListView, View} = require 'atom'

module.exports =
class ProjectManagerView extends SelectListView
  projectManager: null
  activate: ->
    new ProjectManagerView

  initialize: (serializeState) ->
    super
    @addClass('project-manager overlay from-top')

  serialize: ->

  getFilterKey: ->
    'title'

  destroy: ->
    @detach()

  toggle: (projectManager) ->
    @projectManager = projectManager # Better fix for this???
    if @hasParent()
      @detach()
    else
      @attach()

  attach: ->
    @storeFocusedElement()

    if @previouslyFocusedElement[0] and @previouslyFocusedElement[0] isnt document.body
      @eventElement = @previouslyFocusedElement
    else
      @eventElement = atom.workspaceView
    @keyBindings = atom.keymap.keyBindingsMatchingElement(@eventElement)

    projects = []
    for title, path of atom.config.get('project-manager')
      projects.push({title, path}) if path
    @setItems(projects)

    atom.workspaceView.append(@)
    @focusFilterEditor()

  viewForItem: ({title, path}) ->
    $$ ->
      @li class: 'project', 'data-project-title': title, =>
        @div class: 'pull-right', =>
        @span class: 'icon icon-chevron-right'
        @span title

  confirmed: ({title}) ->
    @cancel()
    @projectManager.openProject(title)