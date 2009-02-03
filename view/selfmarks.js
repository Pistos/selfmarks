if( $( '#selfmarks-window' ).length == 0 ) {
    var div = $( '#{@window_html}' );
    $( 'body' ).append( div );
}

$( '#selfmarks-window' ).hide( 'normal' );
$( '#selfmarks-window' ).show( 'normal' );
