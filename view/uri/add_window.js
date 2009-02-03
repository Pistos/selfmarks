if( $( '#selfmarks-window' ).length == 0 ) {
    var div = $( '#{@window_html}' );
    div.hide();
    $( 'body' ).append( div );
}
$( '#selfmarks-window' ).slideToggle( 'normal' );

