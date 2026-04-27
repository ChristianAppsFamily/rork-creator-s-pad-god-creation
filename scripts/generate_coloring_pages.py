import json
from pathlib import Path
from PIL import Image, ImageDraw

W, H = 1536, 2048
TW, TH = 384, 512

OUT = Path("assets/coloring-pages")
SVG_DIR = OUT / "svg"
THUMB_DIR = OUT / "thumbnails"
SVG_DIR.mkdir(parents=True, exist_ok=True)
THUMB_DIR.mkdir(parents=True, exist_ok=True)

pages = [
    (1, "Creation Animals", "creation-animals", "Friendly creation animals together in a calm field.", "Genesis 1:24-25", "free", "3-6"),
    (2, "Noah's Ark", "noahs-ark", "Noah's ark resting safely with simple clouds and land.", "Genesis 6:14-16", "free", "3-6"),
    (3, "Daniel and the Lions", "daniel-and-the-lions", "Daniel standing safely beside lions.", "Daniel 6:16-23", "free", "5-9"),
    (4, "Garden of Eden", "garden-of-eden", "A peaceful Eden garden with trees and open spaces.", "Genesis 2:8-9", "premium", "5-9"),
    (5, "Adam and Eve with Garden Animals", "adam-and-eve-with-garden-animals", "Adam and Eve with gentle garden animals.", "Genesis 2:19-25", "premium", "8-12"),
    (6, "Garden Animal Friends", "garden-animal-friends", "Friendly animals in a simple garden scene.", "Genesis 2:19", "premium", "3-6"),
    (7, "Noah Loading the Ark", "noah-loading-the-ark", "Noah guiding animals toward the ark.", "Genesis 6:19-20", "premium", "5-9"),
    (8, "Rainbow After the Flood", "rainbow-after-the-flood", "Ark and rainbow after the flood waters.", "Genesis 9:13-16", "premium", "3-6"),
    (9, "Samson and the Lion", "samson-and-the-lion", "Samson and lion in a simple open field.", "Judges 14:5-6", "premium", "8-12"),
    (10, "David the Shepherd", "david-the-shepherd", "David with shepherd staff and sheep.", "1 Samuel 16:11-13", "premium", "3-6"),
    (11, "Jonah and the Great Fish", "jonah-and-the-great-fish", "Jonah and a great fish above waves.", "Jonah 1:17", "premium", "5-9"),
    (12, "Baby Moses in the Basket", "baby-moses-in-the-basket", "Baby Moses in a basket on the river.", "Exodus 2:3-6", "premium", "3-6"),
    (13, "Moses and the Burning Bush", "moses-and-the-burning-bush", "Moses before the burning bush.", "Exodus 3:2-4", "premium", "5-9"),
    (14, "Elijah and the Ravens", "elijah-and-the-ravens", "Elijah and ravens bringing food.", "1 Kings 17:4-6", "premium", "5-9"),
    (15, "Balaam and the Donkey", "balaam-and-the-donkey", "Balaam with his donkey on the path.", "Numbers 22:27-31", "premium", "8-12"),
    (16, "Joseph and the Colorful Coat", "joseph-and-the-colorful-coat", "Joseph in a patterned robe with broad sections.", "Genesis 37:3", "premium", "3-6"),
    (17, "Queen Esther", "queen-esther", "Queen Esther with a simple crown.", "Esther 4:14-16", "premium", "5-9"),
    (18, "Ruth in the Fields", "ruth-in-the-fields", "Ruth gathering grain in the fields.", "Ruth 2:2-3", "premium", "5-9"),
    (19, "Joshua and Jericho", "joshua-and-jericho", "Joshua near the walls of Jericho.", "Joshua 6:2-5", "premium", "8-12"),
    (20, "The Good Shepherd", "the-good-shepherd", "A shepherd caring for a sheep.", "John 10:11-14", "premium", "3-6"),
    (21, "Lions, Lambs, and Doves", "lions-lambs-and-doves", "Lions, lambs, and doves in peace.", "Isaiah 11:6-7", "premium", "3-6"),
    (22, "Fish and Loaves", "fish-and-loaves", "Fish and loaves in a simple arrangement.", "Matthew 14:17-19", "premium", "8-12"),
    (23, "Birds of the Air", "birds-of-the-air", "Birds flying and resting in open sky.", "Matthew 6:26", "premium", "8-12"),
    (24, "Creation Day Six Animals", "creation-day-six-animals", "Day six animals in a wide landscape.", "Genesis 1:24-31", "premium", "3-6"),
]

def svg_for(i):
    # simple bold-outline scene template with variation by index
    x = 180 + (i % 6) * 190
    y = 1220 + (i % 4) * 80
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}">
<rect width="100%" height="100%" fill="white"/>
<g fill="none" stroke="#000" stroke-width="14" stroke-linecap="round" stroke-linejoin="round">
<line x1="0" y1="1700" x2="{W}" y2="1700"/>
<circle cx="1240" cy="240" r="110"/>
<path d="M180 250 Q260 180 340 250 Q420 180 500 250"/>
<rect x="110" y="1220" width="90" height="470" rx="20"/>
<circle cx="155" cy="1110" r="145"/>
<circle cx="{x}" cy="{y}" r="70"/>
<rect x="{x-70}" y="{y+75}" width="140" height="250" rx="45"/>
<line x1="{x-95}" y1="{y+145}" x2="{x-165}" y2="{y+225}"/>
<line x1="{x+95}" y1="{y+145}" x2="{x+165}" y2="{y+225}"/>
<ellipse cx="{x+360}" cy="{y+185}" rx="130" ry="80"/>
<circle cx="{x+485}" cy="{y+160}" r="50"/>
<line x1="{x+295}" y1="{y+255}" x2="{x+295}" y2="{y+365}"/>
<line x1="{x+355}" y1="{y+255}" x2="{x+355}" y2="{y+365}"/>
<line x1="{x+415}" y1="{y+255}" x2="{x+415}" y2="{y+365}"/>
<line x1="{x+475}" y1="{y+255}" x2="{x+475}" y2="{y+365}"/>
</g>
</svg>'''

manifest_pages = []

for n, title, pid, desc, ref, tier, age in pages:
    (SVG_DIR / f"{pid}.svg").write_text(svg_for(n), encoding="utf-8")

    img = Image.new("RGBA", (TW, TH), (255, 255, 255, 255))
    d = ImageDraw.Draw(img)
    d.line((0, int(TH*0.83), TW, int(TH*0.83)), fill="black", width=4)
    d.ellipse((TW-120, 30, TW-30, 120), outline="black", width=4)
    cx = 70 + (n % 6) * 45
    cy = 290 + (n % 4) * 15
    d.ellipse((cx-24, cy-24, cx+24, cy+24), outline="black", width=4)
    d.rounded_rectangle((cx-30, cy+20, cx+30, cy+120), radius=15, outline="black", width=4)
    d.ellipse((cx+95, cy+70, cx+190, cy+130), outline="black", width=4)
    d.ellipse((cx+180, cy+55, cx+220, cy+95), outline="black", width=4)
    img.save(THUMB_DIR / f"{pid}.png")

    manifest_pages.append({
        "number": n,
        "title": title,
        "page_id": pid,
        "description": desc,
        "bible_reference": ref,
        "tier": tier,
        "age_group": age,
        "scene": pid
    })

manifest = {
    "format": {
        "layout_ratio": "3:4",
        "svg_canvas": {"width": W, "height": H},
        "thumbnail_png": {"width": TW, "height": TH},
        "background": "white",
        "line_style": "clean black outlines, no grayscale, no shading"
    },
    "notes": {
        "character_style": "cartoonish human faces",
        "theology_constraints": [
            "no direct depiction of God",
            "halos may appear in selected pages",
            "winged angels acceptable for younger kids",
            "crosses allowed"
        ]
    },
    "pages": manifest_pages
}

(OUT / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print("Generated", len(manifest_pages), "pages.")
