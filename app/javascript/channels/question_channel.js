import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    let question = document.querySelector('.question')

    if (question) {
      let id = question.id.split('-')[1]
      this.perform('follow', { id: id })
    }
  },

  disconnected() {
  },

  received(data) {
    if (data.user_id === gon.user_id) return
    if (data.commentable_type) {
      $(`#${data.commentable_type.toLowerCase()}-${data.commentable_id}`).find(".comments").append(data.comment)
    }

    $(".answers").append(data.answer)
  }
});
