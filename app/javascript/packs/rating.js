$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(event) {
        let id = event.detail[0]['id']
        let type = event.detail[0]['type']
        let rating = event.detail[0]['rating']

        $('#' + type + '_' + id).html(rating)
    })
})
