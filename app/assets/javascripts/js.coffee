$(document).on 'ready page:load', ->
  $('.js-tooltip').tooltip()

  $('.js-chart-raw').each ->
    el = $(this)
    console.log el.data()
    el.highcharts(el.data('options'))
