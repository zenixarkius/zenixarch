// ========== GENERAL ==========
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.groups.enabled", false);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.search.separatePrivateDefault", false);

// ========== TOOLBAR ==========
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("extensions.unifiedExtensions.button.always_visible", false);
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"fxa-toolbar-menu-button\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[],\"dirtyAreaCache\":[],\"currentVersion\":23,\"newElementCount\":3}");

// ========== PRIVACY ==========
user_pref("network.http.referer.XOriginPolicy", 2);
user_pref("privacy.globalprivacycontrol.enabled", false);
user_pref("places.history.enabled", false);
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);

// ========== AUTOMATIC CONNECTIONS ==========
user_pref("services.settings.server", ""); // firefox.settings.services.mozilla.com
user_pref("dom.push.connection.enabled", false); // push.services.mozilla.com
user_pref("extensions.update.enabled", false); // uBlock doesn't update enough to justify automatic connections

// ========== LETTERBOXING ==========
// 1600x900 is arkenfox's default new window size so I enforce letterboxing to that
user_pref("privacy.resistFingerprinting.letterboxing", true);
user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "1600x900");

// ========== IPV6 ==========
// I leave v6 off solely because I use a VPN, otherwise I would prefer it
user_pref("network.dns.disableIPv6", true);
user_pref("network.dns.preferIPv6", true);

// ========== WEBGL ==========
// WebGL in Librewolf is disabled by default, so force-enabled is here in case I ever turn it on for something.
user_pref("webgl.force-enabled", true);
user_pref("webgl.max-size", 16384);

// ========== WEBRENDER ==========
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.dcomp-video-hw-overlay-win-force-enabled", true);

// ========== CANVAS ==========
user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);

// ========== GPU ACCELERATION ==========
user_pref("layers.acceleration.force-enabled", true);
user_pref("layers.gpu-process.enabled", true);
user_pref("layers.gpu-process.force-enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.gpu-process-decoder", true);
user_pref("media.ffmpeg.vaapi.enabled", true);

// ========== CONTENT OPTIMIZATION ==========
user_pref("ui.submenuDelay", 0);
user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);
user_pref("gfx.content.skia-font-cache-size", 32);
user_pref("content.notify.interval", 100000);
user_pref("content.max.tokenizing.time", 2000000);
user_pref("content.interrupt.parsing", true);
user_pref("content.switch.threshold", 300000);
user_pref("content.maxtextrun", 8191);

// ========== MEMORY CACHE ==========
user_pref("browser.cache.memory.capacity", 131072);
user_pref("browser.cache.memory.max_entry_size", 153600);
user_pref("browser.sessionstore.interval", 60000);
user_pref("dom.storage.default_quota", 20480);
user_pref("dom.storage.shadow_writes", true);

// ========== MEDIA CACHE ==========
user_pref("media.memory_cache_max_size", 1048576);
user_pref("media.memory_caches_combined_limit_kb", 4194304);
user_pref("media.cache_readahead_limit", 7200);
user_pref("media.cache_resume_threshold", 3600);

// ========== IMAGE CACHE ==========
user_pref("image.cache.size", 10485760);
user_pref("image.mem.decode_bytes_at_a_time", 65536);
user_pref("image.mem.max_decoded_image_kb", 512000);
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000);

// ========== NETWORK CACHES ==========
user_pref("network.buffer.cache.size", 65535);
user_pref("network.buffer.cache.count", 48);
user_pref("network.dnsCacheEntries", 10000);
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.ssl_tokens_cache_capacity", 32768);

// ========== HTTP ==========
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.max-persistent-connections-per-proxy", 48);
user_pref("network.http.request.max-start-delay", 5);
user_pref("network.http.pacing.requests.enabled", false);

// ========== MISC ==========
user_pref("dom.ipc.keepProcessesAlive.web", 4);
user_pref("layout.css.grid-template-masonry-value.enabled", true);
