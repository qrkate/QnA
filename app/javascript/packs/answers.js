$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', editAnswer )
})

function editAnswer(event){
 event.preventDefault()

 const answerId = $(this).data('answerId')

 $(this).toggle()
 $('#edit-answer-' + answerId).toggle()
}
