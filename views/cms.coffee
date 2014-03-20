for_each_markdown_region=(func)->
  func(markdown) for markdown in $(".md")
  null

display_html=(id, data)->
  for targets in $("#"+id)
    targets.innerHTML = data
  null

get_markdown_ajax=(markdown)->
  $.ajax "/md/#{markdown.id}",
    type:"GET"
    dataType:"html"
    success:(data, status, jqxhr)->
      display_html(markdown.id, data)
      null
    error:(data, status, jqxhr)->
      alert("error loading markdown")
      null
  null

get_plaintext_ajax=(markdown)->
  $.ajax "/markdown/#{markdown.id}",
    type:"GET"
    dataType:"html"
    success:(data, status, jqxhr)->
      display_html(markdown.id, data)
    error:(data, status, jqxhr)->
      alert("error loading markdown")
      null
  null

set_editing_style=(markdown)->
  markdown.classList.add "editing"
  markdown.contentEditable= "true"
  markdown.onfocus= ->
    @classList.remove "editing"
    @classList.add "pre"
    get_plaintext_ajax(markdown)
    null
  markdown.onblur = ->
    @classList.add "editing"
    @classList.remove "pre"
    get_markdown_ajax(markdown)
  null

toggle_edit_ui= ->
  for_each_markdown_region (set_editing_style)
  null

window.toggle_edit_ui = toggle_edit_ui

$(document).ready ->
  for_each_markdown_region (get_markdown_ajax)
  null
