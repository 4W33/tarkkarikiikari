$(function() {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide(); 
        }
    }
    display(false)
    window.addEventListener("message", function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true ) {
                display(true)
            } else  {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://tarkkarikiikari/exit', JSON.stringify({}));
            return;
        }
    };
    $("#close").click(function() {$.post('https://tarkkarikiikari/exit', JSON.stringify({}));return})
    $("#kiikari").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'kiikari'}));return})
    $("#kiikaripois").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'kiikaripois'}));return})
    $("#lampokamera").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'tv'}));return})
    $("#lampokamerapois").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'tvpois'}));return})
    $("#yonako").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'yonako'}));return})
    $("#yonakopois").click(function () {$.post('https://tarkkarikiikari/kiikariasetukset', JSON.stringify({type: 'yonakopois'}));return})
})