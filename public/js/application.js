$(document).ready(function() {
  Controller.initialize();
});

var Controller = (function(){
  function bindDeleteButton(){ 
    $('.scheduled_recipes').on('click', '.delete', function(event) {
      event.preventDefault();
      deleteUrl = "/recipes/delete/" + $(this).attr('id');
      Server.deleteRequest(deleteUrl);
    });
  };

  function initialize() {
    bindDeleteButton();
  };

  return {
    initialize: initialize
  };
})();


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
    $list = 'div#' + response_data.yummly_id;
    $($list).remove()
  };

  return {
    removeListElement: removeListElement
  };
})();

