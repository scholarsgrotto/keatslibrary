# Technical Documentation

Brief notes on the technical principles used in creating *[Keats's Paradise Lost](https://keatslibrary.org/paradise-lost/)*.

## Files

A transcription of Keats's copy of *Paradise Lost*, along with Beth Lau's scholarly apparatus, is encoded in a single .xml file, which adheres to the [TEI (Text Encoding Initiative) Guidelines, P5](https://tei-c.org/guidelines/P5/). Details on the tags used in the master .xml files can be found in the [pl_encoding_principles.md](pl_encoding_principles.md) file.

Beth Lau's scholarly introduction is encoded in a separate TEI-adherent .xml file. These are the master files for the vast majority of the *Keats Paradise Lost* content. There are two exceptions. Beth Lau's bibliography was generated from a Zotero bibliographic database and further hand-edited, and the documentation and technical introduction are hand-coded markdown files. 

To create the user-friendly web version of the digital edition, the main text and introduction were converted to web format using XSLTs (eXtensible Stylesheet Language Transformations). The visual interface for the project, as of 2020, is constructred from a combination of html, PHP, CSS, and Javascript. 

Page scans of the physical volume are available on Notre Dame's institutional repository, CurateND. Volume one is [here](https://curate.nd.edu/show/7w62f764t1z), and volume two is [here](https://curate.nd.edu/show/x633dz0486k). These can be considered permanent locations for the page scans, with persistent identifiers for each of the page images. Use information can be found on those CurateND pages as well. 


## Conventions

Line numbers are not recorded in the .xml encoding.

*Keats's Paradise Lost* imperfectly follows a software versioning paradigm. That is, changes are recorded in sequentially-ordered releases, beginning with early versions ("beta-01," "RC-01" (release candidate 1), "RC-02," and "RC-03"), and continuing with "1.0" onwards. No attempt is made to follow any specification such as ["Semantic Versioning"](https://semver.org/) closely, but the general principle of making incremental changes easily trackable applies.

The most-recent numbered edition is recorded in the TEI header of the main .xml file, which is then reflected on the front-facing website. A brief description of all changes, with dates of release, are also recorded in the TEI header. The actual changes can be viewed and compared (in Github)[https://github.com/scholarsgrotto/keatslibrary].

It should also be noted what constitutes a "change." At least through RC-03, a change is considered an alteration to the main .xml source file, not an alteration to the interface of the web version. So for example, if the content and scholarly apparatus of *Keats's Paradise Lost* remained unchanged, but the decision were made to change the image banner at the top of [The Keats Library](https://keatslibrary.org) web page and style hyperlinks in bright gold instead of their default blue, the edition number would not increment, even though the web interface looks different.

Some might consider this controversial, arguing that interfaces do affect meaning and provide a snapshot of digital affordances at a particular point in history. This is a fair objection. One of the most venerable digital Romantic-era projects, [The William Blake Archive](http://www.blakearchive.org/), might be offered as a case in point, having carried visual marks of the early web days of the 1990s until a vast overhaul in 2016.[1] The "new" archive certainly provides a different encounter with Blake's texts, while the historic versions captured on the Internet Archive's Wayback Machine offer insight on the design thinking that went into scholarly projects for the early World Wide Web. To date (early 2020), separate changes to the appearance of the web front-end for *Keats's Paradise Lost* have been minor, and have usually been released concurrently with an updated master .xml file, so the question of signaling a new "wrapper" for unchanged content has not yet been raised. Should the need arise, the editors may consider introducing such a signal (a separate numbering system for the web design? or perhaps adding another number after 1.0, such as 1.0.1?).

As of early 2020, recommended best practice for citing *Keats's Paradise Lost* is to include the base url for the edition (https://keatslibrary.org/paradise-lost/), the version number at time of citation, and if especially concerned about visual appearance, the date of access. 

*Created 2020-01-30 by Daniel Johnson*

[1] (See http://www.blakearchive.org/staticpage/archiveataglance?p=planNEW)[http://www.blakearchive.org/staticpage/archiveataglance?p=planNEW]