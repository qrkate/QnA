$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', editQuestion )
})

function editQuestion(event){
 event.preventDefault()

 const questionId = $(this).data('questionId')

 $(this).toggle()
 $('#edit-question-' + questionId).toggle()
}
