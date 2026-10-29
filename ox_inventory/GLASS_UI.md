# ox_inventory — glass UI + clothing

Restyled to match ox_doorlock (dark glass, pill controls, green `#3ddc84` accent, Bahnschrift).

## What changed
| File | Change |
|---|---|
| `web/build/assets/glass-theme.css` | NEW – re-skins the whole inventory: panels, slots, hotbar, tooltips, context menu, help dialog |
| `web/build/assets/glass-extras.js` | NEW – header (Items / Clothing tabs), item search, cash pills, clothing panel, outfits, toasts |
| `modules/clothing/client.lua` | NEW – clothing toggles, saved outfits, `/wear`, export |
| `web/build/index.html` | loads the two new files, Google Fonts request removed |
| `client.lua` | one line: `require 'modules.clothing.client'` |

The compiled React bundle is untouched, so ox_inventory updates only need those 3 small edits re-applied.

## Features
- **Clothing tab** – toggle hat, glasses, earrings, mask, top, vest, pants, shoes, bag, chain, watch, bracelet. Taking something off remembers exactly what was worn and puts it back.
- **Take off all / Put all back**
- **Outfits** – save up to 6 per character (stored per character in client KVP), wear or delete from the Outfits tab. Pieces that are currently taken off are saved as worn.
- **Item search** – dims everything that doesn't match, highlights matches.
- **Cash + dirty money pills** in the header (dirty only shows when you have some).
- Weight bar turns amber at 75% and red at 95%.
- Short clothing animations (hat, glasses, mask, pants, shoes, generic).
- `/wear <slot>` command and `exports.ox_inventory:toggleClothing('hat')`.

## Config (top of `modules/clothing/client.lua`)
- `animations`, `maxOutfits`
- `cashItems` / `dirtyItems` – item names counted for the pills
- `blank` – the drawable id meaning "nothing worn" per freemode model. If a piece doesn't visually come off
  with your clothing pack, change its id here (e.g. male pants `[4] = 61`).

Works with illenium-appearance / any appearance script (it only uses ped natives). Freemode peds only.
