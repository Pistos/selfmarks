function load_js( uri ) {
    var script  = document.createElement( 'SCRIPT' );
    script.type = 'text/javascript';
    script.src  = uri;
    document.getElementsByTagName('head')[0].appendChild( script );
}

( function() {
    load_js( 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js' );
    load_js( '#{SelfMarks::HOST}/selfmarks.js?' );
} )();
