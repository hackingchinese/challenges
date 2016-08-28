# Turbolinks.enableProgressBar()

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

$(document).on 'click', '.js-fetch-url', (event) ->
  setError = (e) ->
    error_div = $('.js-error-result')
    if e? and e
      error_div.html """
      <div class='alert alert-danger'>#{e}</div>
      """
    else
      error_div.html ""

  el = $(this)
  form = el.closest('form')
  event.preventDefault()
  el.html """
    <i class='fa fa-fw fa-spinner fa-spin'></i>
  """
  id = window.location.pathname.match(/stories\/(\d+)/)
  $.ajax
    method: 'POST'
    url: el.attr('href')
    data:
      url: form.find('#resources_story_url').val()
      id: id && id[1]
    error: (xhr,textResponse,error) ->
    success: (data) ->
      setError null
      form.find('input[name*=title]').val(data.title)
      form.find('textarea[name*=description]').val(data.description)
      form.find('input[name*=image_cache]').val(data.image_cache)
      el.html("Fetch again")
      if data.image_cache != null
        img = $("<img class='story-fetcher-preview' src=''/>")
        img.attr('src', "/uploads/tmp/#{data.image_cache}")
        $('.js-image-preview').html(img)
