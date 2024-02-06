// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#show: doc => poster(
  $if(title)$ title: [$title$], $endif$
  // TODO: use Quarto's normalized metadata.
  $if(poster-authors)$ authors: [$poster-authors$], $endif$
  $if(departments)$ departments: [$departments$], $endif$
  $if(size)$ size: "$size$", $endif$

  // Institution logo.
  $if(institution-logo)$ univ_logo: "$institution-logo$", $endif$

  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  $if(footer-text)$ footer_text: [$footer-text$], $endif$

  // Any URL, like a link to the conference website.
  $if(footer-url)$ footer_url: [$footer-url$], $endif$

  // Emails of the authors.
  $if(footer-emails)$ footer_email_ids: [$footer-emails$], $endif$

  // Color of the footer.
  $if(footer-color)$ footer_color: "$footer-color$", $endif$

  // DEFAULTS
  // ========
  // For 3-column posters, these are generally good defaults.
  // Tested on 36in x 24in, 48in x 36in, and 36in x 48in posters.
  // For 2-column posters, you may need to tweak these values.
  // See ./examples/example_2_column_18_24.typ for an example.

  // Any keywords or index terms that you want to highlight at the beginning.
  $if(keywords)$ keywords: ($for(keywords)$"$it$"$sep$, $endfor$), $endif$

  // Number of columns in the poster.
  $if(num-columns)$ num_columns: $num-columns$, $endif$

  // University logo's scale (in %).
  $if(univ-logo-scale)$ univ_logo_scale: $univ-logo-scale$, $endif$

  // University logo's column size (in in).
  $if(univ-logo-column-size)$ univ_logo_column_size: $univ-logo-column-size$, $endif$

  // Title and authors' column size (in in).
  $if(title-column-size)$ title_column_size: $title-column-size$, $endif$

  // Poster title's font size (in pt).
  $if(title-font-size)$ title_font_size: $title-font-size$, $endif$

  // Authors' font size (in pt).
  $if(authors-font-size)$ authors_font_size: $authors-font-size$, $endif$

  // Footer's URL and email font size (in pt).
  $if(footer-url-font-size)$ footer_url_font_size: $footer-url-font-size$, $endif$

  // Footer's text font size (in pt).
  $if(footer-text-font-size)$ footer_text_font_size: [$footer-text-font-size$], $endif$

  doc,
)
