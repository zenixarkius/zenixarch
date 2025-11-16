// ========== TOR ==========

user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "1400x900");
user_pref("extensions.hideNoScript", false);
user_pref("browser.security_level.security_slider", 1);
user_pref("torbrowser.settings.quickstart.enabled", true);

// ========== GENERAL ==========

user_pref("clipboard.autocopy", false);
user_pref("middlemouse.paste", false);

user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.groups.enabled", false);

user_pref("browser.search.separatePrivateDefault", false);
user_pref("browser.download.dir", "/home/user/");

// ========== UI ==========

user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.newtabpage.enabled", false);

user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("extensions.unifiedExtensions.button.always_visible", false);
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"fxa-toolbar-menu-button\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[],\"dirtyAreaCache\":[],\"currentVersion\":23,\"newElementCount\":3}");

// ========== PERFORMANCE ==========
// https://github.com/CachyOS/CachyOS-Browser-Settings/blob/master/cachyos.cfg#L549
// https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/Fastfox.js

user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);

user_pref("gfx.content.skia-font-cache-size", 32);

user_pref("content.notify.interval", 100000);
user_pref("content.max.tokenizing.time", 1000000);
user_pref("content.interrupt.parsing", true);

user_pref("content.switch.threshold", 300000);

user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.precache-shaders", true);

user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);

user_pref("browser.cache.memory.capacity", 131072);
user_pref("browser.cache.memory.max_entry_size", 153600);

user_pref("dom.storage.default_quota", 20480);
user_pref("dom.storage.shadow_writes", true);

user_pref("media.memory_cache_max_size", 262144);
user_pref("media.memory_caches_combined_limit_kb", 2560000);

user_pref("media.cache_readahead_limit", 7200);
user_pref("media.cache_resume_threshold", 3600);

user_pref("image.cache.size", 10485760);
user_pref("image.mem.decode_bytes_at_a_time", 65536);

user_pref("network.buffer.cache.size", 65535);
user_pref("network.buffer.cache.count", 48);

user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.max-persistent-connections-per-proxy", 48);
user_pref("network.http.request.max-start-delay", 5);

user_pref("network.http.pacing.requests.enabled", false);

user_pref("network.dnsCacheEntries", 10000);
user_pref("network.dnsCacheExpiration", 3600);

user_pref("network.ssl_tokens_cache_capacity", 10240);

user_pref("layout.css.grid-template-masonry-value.enabled", true);

// ========== HARDENING ==========

// Stop automatic connections
user_pref("services.settings.server", ""); // firefox.settings.services.mozilla.com
user_pref("dom.push.connection.enabled", false); // push.services.mozilla.com
user_pref("extensions.update.enabled", false); // uBlock doesn't update enough to justify automatic connections

// I leave v6 off solely because I use a VPN, otherwise I would prefer it
user_pref("network.dns.disableIPv6", true);
user_pref('network.dns.preferIPv6', true);

user_pref("network.http.referer.XOriginPolicy", 2);

// 1600x900 is arkenfox's default new window size so I enforce letterboxing to that
user_pref("privacy.resistFingerprinting.letterboxing", true);
user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "1600x900");

user_pref("browser.translations.enable", false);
user_pref("extensions.ml.enabled", false);

user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quickactions", false);

user_pref("privacy.globalprivacycontrol.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("places.history.enabled", false);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);
