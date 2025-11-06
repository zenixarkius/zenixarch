// ========== UI / MISC TWEAKS ==========

// My preferred toolbar layout
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"urlbar-container\",\"fxa-toolbar-menu-button\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[],\"dirtyAreaCache\":[],\"currentVersion\":23,\"newElementCount\":3}");
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("extensions.unifiedExtensions.button.always_visible", false);

user_pref("clipboard.autocopy", false);
user_pref("middlemouse.paste", false);
user_pref("browser.download.dir", "/home/user/");
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.groups.enabled", false);

// ========== ADVANCED HARDENING ==========

// 1600x900 appears is arkenfox's default new window size, so is on so I enforce letterboxing to that.
user_pref("privacy.resistFingerprinting.letterboxing", true);
user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "1600x900");

user_pref("network.dns.disableIPv6", true);

// Stop firefox.settings.services.mozilla.com
user_pref("services.settings.server", "");

// Stop push.services.mozilla.com
user_pref("dom.push.connection.enabled", false);

// uBlock doesn't update enough to justify automatic connections
user_pref("extensions.update.enabled", false);

user_pref("browser.translations.enable", false);

user_pref("media.gmp-manager.url", "data:text/plain,");
user_pref("media.gmp-gmpopenh264.enabled", false);
user_pref("media.gmp-provider.enabled", false);

user_pref("extensions.ml.enabled", false);

user_pref("network.http.referer.XOriginPolicy", 2);

// ========== about:preferences#home ==========

user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.newtabpage.enabled", false);

user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);

// ========== about:preferences#search ==========

user_pref("browser.search.separatePrivateDefault", false);

user_pref("browser.urlbar.suggest.recentsearches", false);

user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quickactions", false);

// ========== about:preferences#privacy ==========

user_pref("privacy.globalprivacycontrol.enabled", false);

user_pref("signon.management.page.breach-alerts.enabled", false);

user_pref("places.history.enabled", false);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);

user_pref("network.trr.mode", 5);
