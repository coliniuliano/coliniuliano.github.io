# coliniuliano.ca

Personal site and project portfolio, built with [Jekyll](https://jekyllrb.com) and
deployed by Cloudflare Pages. Based on the [Poole](https://github.com/poole/poole) theme,
heavily modified.

## Running locally

Needs Ruby 3.2 or newer (Jekyll 4.4 pulls in `sass-embedded`, which requires it). Stick to
3.4.x: that is the only line Jekyll's own CI tests, and it matches what Cloudflare's build
image uses.

```bash
bundle install
bundle exec jekyll serve
```

The site is served at <http://localhost:4000> and rebuilds on file changes (restart after
editing `_config.yml`). Output goes to `_site/`, which is gitignored.

## Hosting

Live at <https://www.coliniuliano.ca> (coliniuliano.com redirects there), published by
**Cloudflare Pages**, set up in May 2022 — the `Gemfile` was added for that build (commit
`dc3d41b`). Which branch it watches, the build command, and the Ruby version all live in
the Cloudflare dashboard rather than in this repo, so a Jekyll or Ruby bump here needs the
dashboard to keep up. Cloudflare injects its own analytics beacon into every page; Google
Analytics comes from `ga_analytics` in `_config.yml`.

`baseurl` is empty because the site sits at the domain root. `url` is informational only —
nothing in the templates uses it.

GitHub Pages is also still switched on for the repo, serving an older copy of the same
content at <https://coliniuliano.github.io>. Nothing points at it. The `gh-pages` branch is
a leftover from the Poole fork and is unused.

## Structure

```
index.html              Home page: all projects grouped by year, newest first
404.html
_config.yml             Site settings, collections, layout defaults
_projects/              One Markdown file per project (the `projects` collection)
_data/galleries/        Image lists for the gallery include, one YAML file per gallery
_layouts/               default.html, page-gallery.html
_includes/              head.html, masthead.html, gallery.html
_sass/                  Partials imported by styles.scss
styles.scss             Compiled to styles.css by Jekyll's built-in Sass
assets/                 Per-project image folders (plus thumbs/), favicon, headshot
bin/                    Image resizing and thumbnail scripts
```

## Adding a project

Create `_projects/<slug>.md`. Pages in `_projects` get the `page-gallery` layout
automatically, so only front matter and content are needed:

```markdown
---
title: Electronic Catan LCD Tiles
image: catan-tiles/thumbs/four-tiles.png
status: Completed
date: 2022-01-01
---

Short intro shown as the excerpt on the home page.<!-- more -->

The rest of the write-up.
```

- `image` is a path under `assets/`, usually a thumbnail.
- `status` is rendered as a pill; `In Progress`, `Completed`, `Stalled`, and `Cancelled`
  have styles in `_sass/_custom.scss` (the class is the value lowercased and hyphenated).
  It can also be a list to show multiple pills.
- `date` only drives the year heading and sort order on the home page.
- `<!-- more -->` (`excerpt_separator`) splits the home page excerpt from the full write-up.

## Galleries

Drop images in `assets/<project>/`, generate thumbnails into `assets/<project>/thumbs/`,
then list them in `_data/galleries/<project>-<gallery>.yml`:

```yaml
- file: tile-pcb.jpg
  description: An assembled hex PCB
```

Include it in a project page with:

```liquid
{% include gallery.html id="catan-tiles" gallery="hardware" %}
```

`id` is the `assets/` folder; `gallery` is the suffix on the data file name and can be
omitted for a single gallery at `_data/galleries/<project>.yml`. Thumbnails link to the full-size image in a
lightbox.

### Image prep

`bin/` holds helpers that need [ImageMagick](https://imagemagick.org)
(`brew install imagemagick`). They can be run from anywhere, and both default to every
`assets/<project>/` folder, or take specific folders as arguments:

- `bin/resize-and-strip.sh` — caps images at 1280px and strips embedded profiles, in place
- `bin/create-thumbnails.sh` — writes 250x250 thumbnails into `assets/<project>/thumbs/`

Both only rewrite files that actually need it, so re-running them leaves everything else
byte-identical and git stays quiet. `DRY_RUN=1` reports without writing anything.

Thumbnail output is not stable across ImageMagick versions, so an existing thumbnail is
never rebuilt just because its source has a newer timestamp. Use `STALE=1` after replacing
a source image, or `FORCE=1` to rebuild the lot. `create-thumbnails.sh` also lists
thumbnails whose source image is gone.

`bin/generate-thumbnails.bat` is an old Windows version of both scripts, unmaintained and
not idempotent.

## License

Poole is MIT licensed; see [LICENSE.md](LICENSE.md). Site content and project write-ups are
not.
