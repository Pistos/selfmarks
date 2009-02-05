$( document ).ready( function() {
    $( '#page-search-box' ).focus( function() {
        $( '#page-search' ).addClass( 'focused' );
        if( $(this).val() == 'Search' ) {
            $(this).val( '' );
        }
    } );
    $( '#page-search-box' ).blur( function() {
        $( '#page-search' ).removeClass( 'focused' );
    } );
} );