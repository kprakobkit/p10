$(document).ready(function() {
  $('.scheduled_recipes').on('click', '.delete', function(event) {
    event.preventDefault();
    deleteUrl = "/recipes/delete/" + $(this).parent().attr('id');
    Server.deleteRequest(deleteUrl);
  });
});

var Server = (function(){
  function deleteRequest(deleteUrl) {
    var ajaxRequest = $.ajax({
      url: deleteUrl,
      type: "POST" 
    }).done(View.removeListElement);
  };

  return {
    deleteRequest: deleteRequest
  };
})();

var View = (function(){
  function removeListElement(response_data) {
    $list = 'li#' + response_data.yummly_id;
    $($list).remove()
  };

  return {
    removeListElement: removeListElement
  };
})();

