if( $( '#selfmarks-window' ).length == 0 ) {
    $( 'head' ).append(
        '<link rel="stylesheet" href="#{SelfMarks::HOST}/uri/add_window.css" type="text/css" media="screen"/>'
    );
    var div = $( '#{@window_html}' );
    div.hide();
    $( 'body' ).prepend( div );
}
$( '#selfmarks-window' ).toggle( 'fast' );

$( '#selfmarks-submit' ).live( 'click', function() {
    var uri = $( '#selfmarks-uri' ).val();
    var title = $( '#selfmarks-title' ).val();
    var tags = $( '#selfmarks-tags' ).val();
    var notes = $( '#selfmarks-notes' ).val();
    $.getJSON(
        '#{SelfMarks::HOST}/uri/add?jsoncallback=?',
        {   uri   : uri,
            title : title,
            tags  : tags,
            notes : notes } );
    return false;
} );