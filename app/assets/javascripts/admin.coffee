#= require dragula.js
#= require_self


$(document).on 'ready page:load', ->
  $('.js-tier-drag').each ->
    dragula [this],
      moves: (el, container, handle) ->
        handle.tagName == 'A' || handle.tagName == 'I'
    .on 'drop', (el, container, source) ->
      ids = $(container).find('tr').map((el)-> $(this).data('id')).toArray()
      tier = $(container).data('tier')

      $.ajax
        method: 'POST'
        url: '/admin/resources/tags/resort'
        data:
          tier: tier
          ids: ids

