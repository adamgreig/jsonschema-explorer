$('#--load-schema').bind('click', function(event) {
    var url = $('#--schema-url').val();
    $.getJSON(url, function(data) {
        var root = $('#--root');
        root.empty();
        root.append("<h1>"+data.title+"</h1>");
        root.append(data.description);
        root.append("<div id='--top-properties' />");
        var topprops = $('#--top-properties');
        for(property in data.properties) {
            topprops.append("<p>"+data.properties[property].title+"</p>");
        }
    });
});
if(location.hash) {
    $('#--schema-url').val(location.hash.replace('#', ''));
    $('#--load-schema').click();
}
