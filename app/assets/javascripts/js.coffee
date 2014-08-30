$(document).on 'ready page:load', ->
  $('.js-tooltip').tooltip()

  $('.js-chart-raw').each ->
    el = $(this)
    el.highcharts(el.data('options'))
