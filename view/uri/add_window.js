if( $( '#selfmarks-window' ).length == 0 ) {
    $( 'head' ).append(
        '<link rel="stylesheet" href="#{SelfMarks::HOST}/uri/add_window.css" type="text/css" media="screen"/>'
    );
    var div = $( '#{@window_html}' );
    div.hide();
    $( 'body' ).prepend( div );
}
$( '#selfmarks-window' ).toggle( 'fast' );

