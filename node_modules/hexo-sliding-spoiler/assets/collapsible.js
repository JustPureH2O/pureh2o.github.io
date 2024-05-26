(function (document) {
    [].forEach.call(document.getElementsByClassName('collapsible'), function(panel) {
        panel.getElementsByClassName('collapsible-title')[0].onclick = function() {
            panel.classList.toggle("collapsed");
            panel.classList.toggle("expanded");
        }
    });
})(document);