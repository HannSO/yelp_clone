$(document).ready(function(){
  $('.endorsements-link').on('click', function(event){
    event.preventDefault();

    var endorsementCount = $(this).siblings('endorsements_count');

    $.post(this.href, function(response){
      endorsement.text(response.new_endorsement_count);
    });
  });
});
