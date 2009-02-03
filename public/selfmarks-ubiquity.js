CmdUtils.CreateCommand({
  name: "selfmark",
  homepage: "http://manveru.net",
  author: { name: "Michael Fellinger", email: "m.fellinger@gmail.com"},
  contributors: ["Michael Fellinger", "Pistos"],
  license: "MIT",
  description: "Tags the current site using SelfMarks",
  icon: "#{SelfMarks::HOST}/favicon.ico",
  help: "Save the current URI to SelfMarks with the tags input by the user. Any selected text on the page will be recorded as the note.",

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
    var response = jQuery.post("#{SelfMarks::HOST}/uri/add", params);
  },

  post_params: function(note, mods){
    var doc =  Application.activeWindow.activeTab.document;
    var uri = Utils.url(doc.documentURI);

    var params = {
      uri: uri.asciiSpec,
      title: mods.titled.text || doc.title,
      notes: note.text,
      tags: mods.tagged.text
    };

    return params;
  }
});
