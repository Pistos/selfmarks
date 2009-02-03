if( $( '#selfmarks-window' ).length == 0 ) {
    $( 'head' ).append(
        '<link rel="stylesheet" href="#{SelfMarks::HOST}/selfmarks.css" type="text/css" media="screen"/>'
    );
    var div = $( '#{@window_html}' );
    div.hide();
    $( 'body' ).append( div );
}
$( '#selfmarks-window' ).toggle( 'fast' );

