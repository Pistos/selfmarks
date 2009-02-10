CmdUtils.CreateCommand({
  name: "selfmark",
  homepage: "http://manveru.net",
  author: { name: "Michael Fellinger", email: "m.fellinger@gmail.com"},
  contributors: ["Michael Fellinger", "Pistos"],
  license: "MIT",
  description: "Tags the current site using Selfmarks",
  icon: "#{Selfmarks::HOST}/favicon.ico",
  help: "Save the current URI to Selfmarks with the tags input by the user. Any selected text on the page will be recorded as the note.",

  takes: {note: noun_arb_text},
  modifiers: {
    tagged: noun_arb_text,
    titled: noun_arb_text
  },

  preview: function(pblock, note, mods){
    var params = this.post_params(note, mods);

    html =  "<p>title: " + params.title + "</p>";
    html += "<p>tags: "  + params.tags  + "</p>";
    html += "<p>note: "  + params.notes + "</p>";

    pblock.innerHTML = html;
  },

  execute: function(note, mods){
    var params = this.post_params(note, mods);
    var response = jQuery.post("#{Selfmarks::HOST}/uri/add", params);
  },

  post_params: function(note, mods){
    var doc  = Application.activeWindow.activeTab.document;
    var uri  = Utils.url(doc.documentURI);
    var tags = mods.tagged.text

    if( ! tags ){
      tags = jQuery( "a[rel=tag]", doc ).map(
        function( idx, tag ) { return(tag.innerHTML); } );
      tags = this.unique_tags( tags ).join( ' ' );
    }

    CmdUtils.log( tags );

    var params = {
      uri   : uri.asciiSpec,
      title : mods.titled.text || doc.title,
      notes : note.text,
      tags  : tags
    };

     return params;
  },

  unique_tags: function(a){
    var r = new Array();
    o:for(var i = 0, n = a.length; i < n; i++) {
      for(var x = 0, y = r.length; x < y; x++) {
        if(r[x]==a[i]) continue o;
      }
      r[r.length] = a[i];
    }
    return r;
  }
});
