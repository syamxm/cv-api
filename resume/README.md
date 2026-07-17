# Resume builder

Both resume PDFs render from a single content source: `data.json`. Edit that
file, rebuild, and the two versions never diverge.

## Files

- `data.json` — all resume content (contact, summary, skills, experience, projects, education, languages)
- `build.js` — builds `Ahmad_Syamim_Resume.pdf` (two-column, human/portfolio version) using the site's `public/resume.css` design, rendered with Puppeteer
- `ats.typ` — Typst template for `Ahmad_Syamim_Resume_ATS.pdf` (single-column, ATS-safe: linear reading order, embedded font, ligatures disabled)
- `resume-a.html` — generated intermediate for the two-column build (not committed)

## Build

Requires Node (Puppeteer downloads its own Chromium) and the
[Typst CLI](https://github.com/typst/typst/releases) on PATH.

```sh
cd resume
npm install
npm run build          # both versions
npm run build:human    # Ahmad_Syamim_Resume.pdf only
npm run build:ats      # Ahmad_Syamim_Resume_ATS.pdf only
```

## Verify ATS text layer

```sh
pdftotext Ahmad_Syamim_Resume_ATS.pdf -
```

Should show clean linear text with no `�` replacement characters.
