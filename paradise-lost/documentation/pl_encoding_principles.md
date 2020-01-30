# Encoding principals

This document briefly summarizes the TEI (Text Encoding Initiative) encoding practices used to create *(Keats's Paradise Lost)[https://keatslibrary.org/paradise-lost/]*. It is not exhaustive documentation, but is meant to give enough detail that future editors could, by reading in concert with the encoded files, apply the same encoding scheme to their own work. 

This documentation will also serve as historical evidence of engagement with the *Guidelines* at a specific moment in time, for a specific use case. It is clear to the current editor that lessons learned from encoding *Keats's Paradise Lost* could be used to develop more elegant and interoperable practices for encoding marginalia, to broad benefit.

These principles apply to both the `keatspl.xml` and `introduction.xml` files; where differences in usage exist, they are described below.

## General principles

Inverted commas for quotations and references to shorter works, such as poetry, are explicitly keyed, even though their presence could be considered immanent within the appropriate tags. For example, one might argue that an XSLT script should supply the appropriate marks when a quotation is wrapped in `<q>` tags. However, there were a number of complications programmatically -- squaring quotation marks with MLA (Modern Language Association) style punctuation rules, for example, or negotiating nested quotations -- and editorially. For example, Keats might not uniformly use inverted commas when making a quotation. Therefore, the editor deemed explicit typographic reproduction of marks the most expedient practice. 

There is no way to typographically represent italics for titles of larger works such as books, however. Therefore, styling for underlining is supplied by XSLT. Attribute values, as described in the [Tag Usage](#tag-usage) section below, distinguish for the XSLT which references need quotation marks, and which need underlining. 

## Tag usage

`<anchor/>` is a self-closing tag used to mark an end point in the poetry where Keats stops marking, say, an underline or a vertical marginal line. An `@xml:id` attribute is used for linking `<mod/>` tags to the `<anchor/>`, as described in the [Referencing system section](#referencing-system).

`<change>` is used in the TEI header to indicate edits to the given XML file. The `@n` attribute indicates version -- for example "RC-01" means "Release Candidate 1". The `@when` attributes is an ISO 8601 compatible date, indicating when the given version revision was completed. The `@who` attribute indicates the initials of who made the edit. The identity of the editor is made explicit in the nested `<name>` tag.

`<date>` is used in the TEI header to indicate the year of publication of both the electronic edition *Keats's Paradise Lost* and the original print publication it is based on. The `@when` attribute also captures the year.

`<desc>` is used as a technical description of where Keats' handwriting appears on a given page. It is nested under a `<note>` tag. The attribute `@type` indicates what kind of description is being given, which is a superfluity as every `@type` currently is "noteLocation".

`<div>` is the container that holds each book of the *Paradise Lost*. The `@type` attribute specifies that the `<div>` is for a "book" and the `@n` attribute species the book number.

`<emph>` indicates some kind of marking in the text, which is specied by the `@rend` attribute. Single underline is indicated by the attribute value "su", italics by the value "italic".

`<hi>` is used to indicate distinct textual appearances in the introduction, including "sup" for superscript and "block-quotation" for indented long quotations.

`<l>` marks a metrical line in the text. Occasionally, Keats in his marginalia cites a line of poetry. In these cases, the `<l>` tag is given an `@xml:id` according to [the referencing system described below](#referencing_system). In two cases, Keats marks an asterisk (*) on the left side of a line of poetry. To record this, an `<l>` tag is given a `@rend` attribute of "starred".

`<mod/>` is the means of encoding Keats's markup of Milton's text. A self-enclosing tag, `<mod/>` uses the `@spanto` attribute to point to the `<@xml:id>` of the self-closing `<anchor>` tag that indicates the end-point of Keats's marking. The type of marking is indicated by the `@rend` attribute. Values of `@rend` can include "su" for single underline, "du" for double underline, "lvs" for left vertical single marginal line, "lvd" for left vertical double marginal line, "lvt" for left vertical triple marginal line, and "rvs" for right vertical single marginal line.

`<name>` identifies a person, and is used primarily in the header for the editors of the current digital edition. There is one instance in the text itself, however, in which `<name>` is used to identify "Confusion" in the line "the work Confusion named" (on misnumbered page 177 of volume 2). The reason `<name>` is used here and here alone, rather than on all the names mentioned in *Paradise Lost*, is that Confusion was italicized. Elsewhere in the poem, when text is italicized, the italicization is indicated with a `@rend` attribute on the appropriate structural unit, such as `<p>` or `<q>`. Thus, rather than tag "Confusion" as an undifferentiated block of text with something like <ab> or <emph>, we decided to tag it with its function in the text -- a name -- in order to apply the `@rend` attribute of "italic". The `@ref` attribute is used with `<name>` to connect an ORCID identifier with an editor.

`<note>` is the tag used to mark Keats's marginal annotations, as well as Professor Beth Lau's scholarly annotations. Given the depth of both kinds of `<note>`, they are used in "stand off" fashion for *Paradise Lost* proper -- that is, they are placed at the end of the `.xml` file, and point to the content they describe through the `@target` attribute. The `@target` in a `<note>` tag points to an `@xml:id` in either a page (`<pb>`) or a line of poetry (`<l>`). The `@type` attribute can be "editorial" or "marginal", indicating its function, and the `@resp` attribute indicates, in shorthand the person responsible for the note content: Beth Lau, John Keats, or in one case, Charles Dilke. In the introduction XML file, however, `<note>` tags are used "in line" -- that is, placed right next to the content they describe. 

`<p>` indicates a paragraph. It may contain a `@rend` attribute specifying "italic" when the entire paragraph is italicized.

`<pb/>` is the page beginning (or historically, "page break") tag. It is self-closing, meaning it indicates the point at which one page switches to the next, rather than function as a container for a page. Each `<pb/>` has an `@xml:id` attribute, constructed as described in the [referencing system section](#referencing-system) below. Each `<pb/>` has an `@n` attribute for page number; when no page number is given or inferred, `@n` will contain the page function plus "l" or "r" for left (or verso) and right (or recto), respectively, as in "paratextl". Each `<pb/>` has a `@facs` attribute that contains the ID number of the page's associated scanned image, stored in the institional repository at the University of Notre Dame, CurateND. A `<pb/>` may have a `@type` attribute if the whole page serves a particular function, such as "title" or "argument". Near the end of volume two, the printer accidentally misnumbers the pages, jumping from 168 to 171. The `@n` attribute matches what is incorrectly printed, while the `@ana` tag indicates what the page number logically should have been. In this case, the page `@type` is "misnumbered."

`<q>` is used for quotations. The `@rend` attribute indicates any stylization on the quotation, such as underlining or italics. Each `<q>` has an `@xml:id` attribute, constructed as described in the [referencing system section](#referencing-system) below. If a quotation cannot be contained in a single `<q>` tag -- when it crosses two lines (`<l>`) of poetry, which would create overlapping tags, for example -- multiple `<q>` tags are used to stich together a single quotation with the aid of `@next` and `@prev`attributes (which point to the appropriate `@xml:id` of the corresponding `<q>`). The `@source` attribute points to the `@xml:id` of either the page (`<pb>`) or the poetry line(s) (`<l>`) the quotation is referencing. Punctuation, such as periods and commas, that would appear inside quotation marks in MLA style are retained inside `<q>` tags.

`<ref>` indicates a reference to a location in the text, whether a line, a page, or one of Keats's marginal notes, etc. The `@target` attribute points to the appropriate location.

`<title>` functions as its name indicates, describing both titles within *Paradise Lost*, the title of the digital edition itself, and titles of other works referenced in the notes. A `<title>` may contain a `@type` attribute, which is used to indicate relationship to other titles ("sub" for "subtitle") or function (such as "poem" or "preface" title). A `<title>` may contain a `@rend` attribute when styled in italics.

## Referencing system

The project needed a standardized way of referencing different parts of the text. In TEI, this referencing is achieved by defining an identifier using the `@xml:id` attribute, which can then be referenced by a number of pointer attributes, such as `@spanto`. *Keats's Paradise Lost* uses two basic conventions for referencing different parts of the text: one for page-level identifiers, one for text-level identifiers. 

Each page, which is indicated by a self-closing `<pb>` tag, is given an `@xml:id` with the following formula:

> 'kpl' (standing for "Keats Paradise Lost") + volume number + "." + page number. So for example, page 1 of volume 1 is given the `@xml:id` "kpl1.5". 

Unnumbered pages are a special case. They are identified by their page function (instead of number), and if necessary, a sequential number. So one will entries such as "kpl1.cover", "kpl1.front-endpaper1", and "kpl1.front-endpaper2".

Identifiers in the text, which can appear in `<anchor>`, `<l>`, `<mod>`, and `<q>` tags, are given an `@xml:id` with the following formula: 

>'kpl' + volume number + "." + 3-digit page number + 4-digit line number + possible optional notations of "l" or "eol"

The first three components are identical with the page-level convention. Practice changes wtih the 3-digit page number, however. In order to facilitate processing and sorting, the page number is given trailing zeros when need. Thus, instead of "5" or "76", we would have "005" and "076". The same principle applies to the 4-digit line number, in which "552" would be rendered "0552." The reason page numbers claim only 3 digitals and line numbers 4, is because page numbers will always be less than 1000, whereas line numbers do exceed 1000. So for example, the `@xml:id` "kpl2.058.0184" indicates *Keats Paradise Lost* volume 2, page 58, line 184. 

The characters "l" and "eol" are appended to the end of an `@xml:id` in special circumstances. In the rare case that a line of poetry is specifically referenced by Keats, that line (`l`) will get an "l" added to the end of the identifier: for example, "kpl2.061.0287l". For the more common case when Keats draws vertical lines in the margin, an `<anchor>` is placed at the very end of the last line of poetry judged to be "marked" by the vertical line. In that case, the `@xml:id` on the `<anchor>` has the letters "eol" appended to the end, as in "kpl2.119.0293eol". This practice makes sorting different kinds of markup by Keats much easier in XSLT.

*Created 2020-01-30 by Daniel Johnson*