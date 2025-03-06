$(document).ready(function () {
    var stocks = $('#stock').data('stocks');
    $('#stock').autocomplete({
        source: stocks
    });
});