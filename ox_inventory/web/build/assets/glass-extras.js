/* ox_inventory — glass extras: header, item search, cash pills, clothing toggles & outfits.
   Plain JS on top of the compiled React UI. Talks to modules/clothing/client.lua via NUI callbacks. */
(() => {
  'use strict';

  const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'ox_inventory';
  const nui = (event, data) =>
    fetch(`https://${RES}/${event}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data || {}),
    }).then((r) => r.json()).catch(() => null);

  const svg = (inner) => `<svg class="ic" viewBox="0 0 24 24">${inner}</svg>`;
  const IC = {
    search: svg('<circle cx="10" cy="10" r="7"/><path d="M21 21l-6-6"/>'),
    close: svg('<path d="M6 6l12 12M18 6L6 18"/>'),
    trash: svg('<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>'),
    wear: svg('<path d="M5 12l5 5L20 7"/>'),
    plus: svg('<path d="M12 5v14M5 12h14"/>'),
    bag: svg('<rect x="5" y="8" width="14" height="13" rx="3"/><path d="M9 8V6a3 3 0 0 1 6 0v2M9 14h6"/>'),
    shirt: svg('<path d="M8 4L3 7l2 4 3-1v10h8V10l3 1 2-4-5-3a4 4 0 0 1-8 0z"/>'),
    cash: svg('<rect x="3" y="6" width="18" height="12" rx="3"/><circle cx="12" cy="12" r="2.5"/>'),
    box: svg('<path d="M12 3l8 4v10l-8 4-8-4V7z"/><path d="M4 7l8 4 8-4M12 11v10"/>'),
    hanger: svg('<path d="M12 8a2.5 2.5 0 1 0-2.5-2.5"/><path d="M12 8v2.5L3 17a1.5 1.5 0 0 0 1 2.7h16a1.5 1.5 0 0 0 1-2.7l-9-6.5"/>'),
  };
  const SLOT_ICON = {
    hat: svg('<path d="M5 15a7 7 0 0 1 14 0"/><path d="M3 15h18l-1 3H4z"/>'),
    glasses: svg('<circle cx="7" cy="14" r="3.5"/><circle cx="17" cy="14" r="3.5"/><path d="M10.5 14h3M3.5 14L5 7M20.5 14L19 7"/>'),
    ears: svg('<circle cx="12" cy="8" r="2"/><path d="M12 10v3"/><circle cx="12" cy="16.5" r="2.5"/>'),
    mask: svg('<path d="M4 8c3-2 13-2 16 0v4c0 4-3 7-8 7s-8-3-8-7z"/><path d="M8 12h2M14 12h2"/>'),
    top: IC.shirt,
    vest: svg('<path d="M12 3l7 3v6c0 4-3 7-7 9-4-2-7-5-7-9V6z"/>'),
    pants: svg('<path d="M7 3h10l1 18h-4l-2-9-2 9H6z"/>'),
    shoes: svg('<path d="M3 17v-4l5-1 3-4 3 3 6 1v5z"/><path d="M3 17h18"/>'),
    bag: IC.bag,
    chain: svg('<path d="M5 5c0 8 3 13 7 13s7-5 7-13"/><circle cx="12" cy="19.5" r="1.8"/>'),
    watch: svg('<rect x="7" y="7" width="10" height="10" rx="3"/><path d="M9 7l1-4h4l1 4M9 17l1 4h4l1-4M12 10v2l1.5 1"/>'),
    bracelet: svg('<ellipse cx="12" cy="11" rx="8" ry="4"/><path d="M4 11v3c0 2 4 4 8 4s8-2 8-4v-3"/>'),
  };

  const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const money = (n) => '$' + Math.floor(n || 0).toLocaleString('en-US');

  let root, top, panel, toastEl, searchEl, cashEl, dirtyEl;
  let isOpen = false;
  let view = 'items'; // items | clothes
  let panelTab = 'wearing'; // wearing | outfits
  let S = null; // last state from the game
  let toastTimer = 0;

  /* ------------------------------------------------------------------ build */
  function build() {
    root = document.createElement('div');
    root.id = 'gx';
    root.className = 'hidden';
    root.innerHTML = `
      <header class="gx-top" id="gxTop">
        <span class="pill pill-lg">Inventory</span>
        <div class="gx-tabs">
          <button class="chip active" data-view="items">${IC.box}Items</button>
          <button class="chip" data-view="clothes">${IC.hanger}Clothing</button>
        </div>
        <label class="gx-search">
          ${IC.search}
          <input id="gxSearch" type="text" placeholder="Search items" autocomplete="off" spellcheck="false">
        </label>
        <span class="pill pill-num" id="gxCash">${IC.cash}<span>$0</span></span>
        <span class="pill pill-dirty hidden" id="gxDirty">${IC.cash}<span>$0</span></span>
      </header>
      <section class="gx-panel hidden" id="gxPanel"></section>
      <div id="gxToast"></div>`;
    document.body.appendChild(root);

    top = root.querySelector('#gxTop');
    panel = root.querySelector('#gxPanel');
    toastEl = root.querySelector('#gxToast');
    searchEl = root.querySelector('#gxSearch');
    cashEl = root.querySelector('#gxCash span');
    dirtyEl = root.querySelector('#gxDirty');

    top.addEventListener('click', (e) => {
      const b = e.target.closest('[data-view]');
      if (b) setView(b.dataset.view);
    });
    searchEl.addEventListener('input', applySearch);
    panel.addEventListener('click', onPanelClick);
    panel.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' && e.target.id === 'gxName') saveOutfit();
    });
  }

  /* ----------------------------------------------------------------- layout */
  // Align the header with the two inventory panels and the clothing panel with the right-hand one.
  function layout() {
    if (!isOpen) return;
    const grids = document.querySelectorAll('.inventory-wrapper > .inventory-grid-wrapper');
    if (!grids.length) return;

    const first = grids[0].getBoundingClientRect();
    const last = grids[grids.length - 1].getBoundingClientRect();
    const left = Math.min(first.left, last.left);
    const right = Math.max(first.right, last.right);
    const topY = Math.min(first.top, last.top);

    root.style.setProperty('--gx-x', left + 'px');
    root.style.setProperty('--gx-w', right - left + 'px');
    root.style.setProperty('--gx-y', Math.max(8, topY - 62) + 'px');

    const r = grids.length > 1 ? last : first;
    root.style.setProperty('--px', r.left + 'px');
    root.style.setProperty('--py', r.top + 'px');
    root.style.setProperty('--pw', r.width + 'px');
    root.style.setProperty('--ph', r.height + 'px');
  }

  /* ------------------------------------------------------------------ views */
  function setView(next) {
    view = next;
    document.body.classList.toggle('gx-clothes', view === 'clothes');
    top.querySelectorAll('[data-view]').forEach((b) => b.classList.toggle('active', b.dataset.view === view));
    panel.classList.toggle('hidden', view !== 'clothes');
    if (view === 'clothes') {
      layout();
      refresh();
    }
  }

  function toast(msg, ok) {
    if (!msg) return;
    toastEl.textContent = msg;
    toastEl.className = 'show ' + (ok === false ? 'bad' : 'good');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => (toastEl.className = ''), 1800);
  }

  /* ------------------------------------------------------------ game state */
  function apply(state, showToast) {
    if (!state || typeof state !== 'object') return;
    S = state;
    cashEl.textContent = money(S.cash);
    const hasDirty = (S.dirty || 0) > 0;
    dirtyEl.classList.toggle('hidden', !hasDirty);
    if (hasDirty) dirtyEl.querySelector('span').textContent = money(S.dirty);
    if (view === 'clothes') renderPanel();
    if (showToast && S.msg) toast(S.msg, S.ok);
  }

  const refresh = () => nui('glass:state').then((s) => apply(s));
  let refreshTimer = 0;
  const refreshSoon = () => {
    clearTimeout(refreshTimer);
    refreshTimer = setTimeout(refresh, 180);
  };

  /* ---------------------------------------------------------- clothing panel */
  function renderPanel() {
    const head = (sub) => `
      <div class="gx-ph">
        <span class="pill pill-lg">Clothing</span>
        ${sub ? `<span class="pill pill-soft">${sub}</span>` : ''}
        <span class="gx-grow"></span>
        <button class="chip icon" data-act="items" title="Back to items">${IC.close}</button>
      </div>`;

    if (!S) {
      panel.innerHTML = head('') + '<div class="gx-empty">Loading…</div>';
      return;
    }
    if (!S.supported) {
      panel.innerHTML =
        head('') +
        `<div class="gx-empty">${IC.shirt}<span>Clothing options need a freemode character<br>(mp_m_freemode_01 / mp_f_freemode_01).</span></div>`;
      return;
    }

    const worn = S.slots.filter((s) => s.worn).length;
    const outfits = S.outfits || [];
    const keepScroll = panel.querySelector('.gx-body')?.scrollTop || 0;

    let body;
    let foot = '';
    if (panelTab === 'wearing') {
      body = `<div class="gx-toggles">${S.slots
        .map((s) => {
          const state = s.worn ? 'Worn' : s.stored ? 'Taken off' : 'Nothing';
          return `<button class="toggle ${s.worn ? 'on' : ''}" data-act="toggle" data-id="${esc(s.id)}" ${!s.worn && !s.stored ? 'data-empty' : ''}>
            <span class="badge">${SLOT_ICON[s.id] || IC.shirt}</span>
            <span class="t"><b>${esc(s.label)}</b><small>${state}</small></span>
            <span class="switch"><i></i></span>
          </button>`;
        })
        .join('')}</div>`;
      foot = `<div class="gx-foot"><button class="btn" data-act="all">${worn ? 'Take off all' : 'Put all back'}</button></div>`;
    } else {
      const full = outfits.length >= (S.maxOutfits || 6);
      body = `
        <div class="gx-save">
          <input id="gxName" type="text" maxlength="24" placeholder="${full ? 'All outfit slots are used' : 'Outfit name'}" autocomplete="off" spellcheck="false" ${full ? 'disabled' : ''}>
          <button class="btn primary" data-act="save" ${full ? 'disabled' : ''}>${IC.plus}Save</button>
        </div>
        <div class="gx-sec"><span>Saved outfits</span><span>${outfits.length}/${S.maxOutfits || 6}</span></div>
        ${
          outfits.length
            ? `<div class="gx-outfits">${outfits
                .map(
                  (o, i) => `<div class="outfit">
                    <span class="badge">${i + 1}</span>
                    <span class="t"><b>${esc(o.name)}</b><small>Saved outfit</small></span>
                    <button class="row-act" data-act="wear" data-i="${i + 1}" title="Wear">${IC.wear}</button>
                    <button class="row-act del" data-act="del" data-i="${i + 1}" title="Delete">${IC.trash}</button>
                  </div>`
                )
                .join('')}</div>`
            : `<div class="gx-empty">${IC.hanger}<span>No saved outfits yet.<br>Dress how you like, name it, hit Save.</span></div>`
        }`;
    }

    panel.innerHTML = `
      ${head(`${worn}/${S.slots.length} worn`)}
      <div class="gx-tabs2">
        <button class="tab ${panelTab === 'wearing' ? 'active' : ''}" data-tab="wearing">Wearing</button>
        <button class="tab ${panelTab === 'outfits' ? 'active' : ''}" data-tab="outfits">Outfits<sup>${outfits.length}</sup></button>
      </div>
      <div class="gx-body">${body}</div>
      ${foot}`;
    const bodyEl = panel.querySelector('.gx-body');
    if (bodyEl) bodyEl.scrollTop = keepScroll;
  }

  function saveOutfit() {
    const input = panel.querySelector('#gxName');
    const name = input ? input.value : '';
    nui('glass:save', { name }).then((s) => apply(s, true));
  }

  function onPanelClick(e) {
    const tab = e.target.closest('[data-tab]');
    if (tab) {
      panelTab = tab.dataset.tab;
      renderPanel();
      return;
    }
    const el = e.target.closest('[data-act]');
    if (!el) return;
    switch (el.dataset.act) {
      case 'items':
        return setView('items');
      case 'toggle':
        return nui('glass:toggle', { id: el.dataset.id }).then((s) => apply(s, true));
      case 'all':
        return nui('glass:all').then((s) => apply(s, true));
      case 'save':
        return saveOutfit();
      case 'wear':
        return nui('glass:wear', { index: Number(el.dataset.i) }).then((s) => apply(s, true));
      case 'del':
        return nui('glass:delete', { index: Number(el.dataset.i) }).then((s) => apply(s, true));
    }
  }

  /* ------------------------------------------------- search & weight colouring */
  function applySearch() {
    const q = (searchEl.value || '').trim().toLowerCase();
    document.querySelectorAll('.inventory-slot').forEach((slot) => {
      const label = slot.querySelector('.inventory-slot-label-text');
      if (!q || !label) {
        slot.removeAttribute('data-gx-dim');
        slot.removeAttribute('data-gx-hit');
        return;
      }
      if (label.textContent.toLowerCase().includes(q)) {
        slot.removeAttribute('data-gx-dim');
        slot.setAttribute('data-gx-hit', '1');
      } else {
        slot.setAttribute('data-gx-dim', '1');
        slot.removeAttribute('data-gx-hit');
      }
    });
  }

  function colourWeightBars() {
    document.querySelectorAll('.weight-bar').forEach((bar) => {
      const fill = bar.firstElementChild;
      const pct = fill ? parseFloat(fill.style.width) : NaN;
      const lv = isNaN(pct) ? '' : pct >= 95 ? 'full' : pct >= 75 ? 'warn' : '';
      if (lv) bar.setAttribute('data-lv', lv);
      else bar.removeAttribute('data-lv');
    });
  }

  let tick = 0;
  function onDomChange() {
    if (tick) return;
    tick = requestAnimationFrame(() => {
      tick = 0;
      if (!isOpen) return;
      applySearch();
      colourWeightBars();
      layout();
    });
  }

  /* ------------------------------------------------------------ lifecycle */
  function open() {
    isOpen = true;
    root.classList.remove('hidden');
    setView('items');
    refresh();
    [60, 450, 900].forEach((ms) => setTimeout(layout, ms));
  }

  function close() {
    isOpen = false;
    root.classList.add('hidden');
    document.body.classList.remove('gx-clothes');
    searchEl.value = '';
    panelTab = 'wearing';
    S = null;
  }

  window.addEventListener('message', (e) => {
    const action = e.data && e.data.action;
    if (action === 'setupInventory') open();
    else if (action === 'closeInventory') close();
    else if (action === 'refreshSlots' && isOpen) refreshSoon();
  });
  window.addEventListener('resize', () => isOpen && layout());

  build();
  const appRoot = document.getElementById('root');
  if (appRoot) new MutationObserver(onDomChange).observe(appRoot, { childList: true, subtree: true });
})();
