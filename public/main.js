$( document ).ready( function() {
    $( '#page-search-box' ).focus( function() {
        $( '#page-search' ).addClass( 'focused' );
        if( $(this).val() == 'Search' ) {
            $(this).val( '' );
        }
    } );
    $( '#page-search-box' ).blur( function() {
        $( '#page-search' ).removeClass( 'focused' );
        if( $(this).val() == '' ) {
            $(this).val( 'Search' );
        }
    } );

    $( 'a.delete' ).click( function() {
        var link = $(this);
        $.getJSON(
            link.attr( 'href' ),
            function( json ) {
                if( json.success ) {
                    link.closest( '.bookmark' ).slideUp();
                    var c = parseInt( $( '#bookmark-count' ).text() );
                    $( '#bookmark-count' ).text( c - 1 );
                } else {
                    alert( 'Failed to delete bookmark!' );
                }
            } );
        return false;
    } );

    $( '.flash' ).hide();
    $( '.flash' ).fadeIn( 2000 );
} );