$(document).on 'ready page:load', ->
  $('#post-tags').tagit
    fieldName:   'post[tag_list]'
    singleField: true
    tagLimit: 10
    availableTags: gon.available_tags
    
  if gon.post_tags?
    for tag in gon.post_tags
      $('#post-tags').tagit 'createTag', tag