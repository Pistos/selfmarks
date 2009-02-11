function unique_strings( a ) {
    var r = new Array();
    o:for(var i = 0, n = a.length; i < n; i++) {
        for(var x = 0, y = r.length; x < y; x++) {
            if(r[x]==a[i]) continue o;
        }
        r[r.length] = a[i];
    }
    return r;
}

if( $( '#selfmarks-window' ).length == 0 ) {
    $( 'head' ).append(
        '<link rel="stylesheet" href="#{Selfmarks::HOST}/uri/add_window.css" type="text/css" media="screen"/>'
    );
    var div = $( '#{@window_html}' );
    div.hide();
    $( 'body' ).prepend( div );

    if( $( '#selfmarks-tags' ).val() == '' ) {
        var tags = $( "a[rel=tag]", document ).map(
            function( idx, tag ) { return(tag.innerHTML); }
        );
        var tags_text = unique_strings( tags ).join( ' ' );
        $( '#selfmarks-tags' ).val( tags_text );
    }
}
$( '#selfmarks-window' ).toggle( 'fast' );

$( '#selfmarks-submit' ).live( 'click', function() {
    var uri = $( '#selfmarks-uri' ).val();
    var title = $( '#selfmarks-title' ).val();
    var tags = $( '#selfmarks-tags' ).val();
    var notes = $( '#selfmarks-notes' ).val();
    $.getJSON(
        '#{Selfmarks::HOST}/uri/add_window_add?jsoncallback=?',
        {   uri   : uri,
            title : title,
            tags  : tags,
            notes : notes },
        function( json ) {
            if( json[ 'error' ] ) {
                $( '#selfmarks-error' ).append( 'Bookmarking error: ' + json[ 'error' ] );
            } else if( json[ 'success' ] == 'success' ) {
                $( '#selfmarks-message' ).append( 'Successfully bookmarked URI.' );
                setTimeout( function() {
                    $( '#selfmarks-window' ).toggle( 'slow' ); },
                    2000 );
            }
        } );
    return false;
} );

$( '#selfmarks-cancel' ).live( 'click', function() {
    $( '#selfmarks-window' ).hide( 'fast' );
} );