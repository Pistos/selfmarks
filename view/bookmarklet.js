function load_js( uri, id ) {
    var script_tag = document.getElementById( id );
    if( script_tag ) {
        script_tag.parentNode.removeChild( script_tag );
    }

    /* To force browser cache update */
    $.get( uri );

    var script  = document.createElement( 'SCRIPT' );
    script.type = 'text/javascript';
    script.src  = uri;
    script.id   = id;
    document.getElementsByTagName('head')[0].appendChild( script );
}

( function() {
    load_js( 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js', 'selfmarks-jquery' );
    var href = '#{Selfmarks::HOST}/uri/add_window.js?uri=' + encodeURIComponent( window.location.href ) +
        '&title=' + encodeURIComponent( document.title );
    load_js( href, 'selfmarks-javascript' );
} )();
