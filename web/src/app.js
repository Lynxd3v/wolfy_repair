window.addEventListener('message',function (event) {
    let e = event.data
    const p = $('#progressbar')
    const container = $('#container')

    if (e.type === 'startProgressBar') {
        container.fadeIn(500).css('display','flex')
        p.css('width','0%')

        p.animate({
            width: '100%'
        }, {
            duration : Number(e.duration),
            easing : 'linear',
            complete: function () {
                container.fadeOut(500)
            }
        })
    }

    if (e.type === 'stopProgressBar') {
        p.stop()
        container.fadeOut(500)
    }
})