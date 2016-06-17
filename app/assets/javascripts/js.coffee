$(document).on 'ready page:load', ->
  $('.js-tooltip').tooltip()
  $(document).on 'click', '.js-modal', ->
    that = $(this)
    modal = $(that.data('modal'))
    modal.modal('show')
    false



  $(document).on 'shown.bs.tab', ->
    $('.js-chart-raw').each ->
      el = $(this)
      el.highcharts(el.data('options'))
    # $(window).resize()
