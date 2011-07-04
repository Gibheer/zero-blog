$('a').live('click', function(e){
  e.preventDefault();
  $('#content').load($(this).attr('href') + ' #content');
})
