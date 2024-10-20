pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C; use Interfaces.C;
with stddef_h;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;
with System;

package webui_h is

   WEBUI_VERSION : aliased constant String := "2.5.0-beta.2" & ASCII.NUL;  --  ./webui.h:14

   WEBUI_MAX_IDS : constant := (256);  --  ./webui.h:17

   WEBUI_MAX_ARG : constant := (16);  --  ./webui.h:20
   --  unsupported macro: WEBUI_EXPORT extern
   --  unsupported macro: WEBUI_GET_CURRENT_DIR getcwd
   --  unsupported macro: WEBUI_FILE_EXIST access
   --  unsupported macro: WEBUI_POPEN popen
   --  unsupported macro: WEBUI_PCLOSE pclose
   --  unsupported macro: WEBUI_MAX_PATH PATH_MAX

  --  WebUI Library
  --  https://webui.me
  --  https://github.com/webui-dev/webui
  --  Copyright (c) 2020-2024 Hassan Draga.
  --  Licensed under MIT License.
  --  All rights reserved.
  --  Canada.
  -- 

  -- Max windows, servers and threads
  -- Max allowed argument's index
  -- Dynamic Library Exports
  -- -- C STD ---------------------------
  -- -- Windows -------------------------
  -- -- Linux ---------------------------
  -- -- Apple ---------------------------
  -- -- Enums ---------------------------
   type webui_browser is 
     (NoBrowser,
      AnyBrowser,
      Chrome,
      Firefox,
      Edge,
      Safari,
      Chromium,
      Opera,
      Brave,
      Vivaldi,
      Epic,
      Yandex,
      ChromiumBased,
      Webview)
   with Convention => C;  -- ./webui.h:118

  -- 0. No web browser
  -- 1. Default recommended web browser
  -- 2. Google Chrome
  -- 3. Mozilla Firefox
  -- 4. Microsoft Edge
  -- 5. Apple Safari
  -- 6. The Chromium Project
  -- 7. Opera Browser
  -- 8. The Brave Browser
  -- 9. The Vivaldi Browser
  -- 10. The Epic Browser
  -- 11. The Yandex Browser
  -- 12. Any Chromium based browser
  -- 13. WebView (Non-web-browser)
   type webui_runtime is 
     (None,
      Deno,
      NodeJS,
      Bun)
   with Convention => C;  -- ./webui.h:135

  -- 0. Prevent WebUI from using any runtime for .js and .ts files
  -- 1. Use Deno runtime for .js and .ts files
  -- 2. Use Nodejs runtime for .js files
  -- 3. Use Bun runtime for .js and .ts files
   type webui_event is 
     (WEBUI_EVENT_DISCONNECTED,
      WEBUI_EVENT_CONNECTED,
      WEBUI_EVENT_MOUSE_CLICK,
      WEBUI_EVENT_NAVIGATION,
      WEBUI_EVENT_CALLBACK)
   with Convention => C;  -- ./webui.h:142

  -- 0. Window disconnection event
  -- 1. Window connection event
  -- 2. Mouse click event
  -- 3. Window navigation event
  -- 4. Function call event
  -- Control if `webui_show()`, `webui_show_browser()` and
  -- `webui_show_wv()` should wait for the window to connect
  -- before returns or not.
  -- Default: True
  -- Control if WebUI should block and process the UI events
  -- one a time in a single thread `True`, or process every
  -- event in a new non-blocking thread `False`. This updates
  -- all windows. You can use `webui_set_event_blocking()` for
  -- a specific single window update.
  -- Default: False
  -- Automatically refresh the window UI when any file in the
  -- root folder gets changed.
  -- Default: False
  -- Allow multiple clients to connect to the same window,
  -- This is helpful for web apps (non-desktop software),
  -- Please see the documentation for more details.
  -- Default: False
  -- Allow multiple clients to connect to the same window,
  -- This is helpful for web apps (non-desktop software),
  -- Please see the documentation for more details.
  -- Default: False
   type webui_config is 
     (show_wait_connection,
      ui_event_blocking,
      folder_monitor,
      multi_client,
      use_cookies)
   with Convention => C;  -- ./webui.h:182

  -- -- Structs -------------------------
  -- The window object number
   type webui_event_t is record
      window : aliased stddef_h.size_t;  -- ./webui.h:186
      event_type : aliased stddef_h.size_t;  -- ./webui.h:187
      element : Interfaces.C.Strings.chars_ptr;  -- ./webui.h:188
      event_number : aliased stddef_h.size_t;  -- ./webui.h:189
      bind_id : aliased stddef_h.size_t;  -- ./webui.h:190
      client_id : aliased stddef_h.size_t;  -- ./webui.h:191
      connection_id : aliased stddef_h.size_t;  -- ./webui.h:192
      cookies : Interfaces.C.Strings.chars_ptr;  -- ./webui.h:193
   end record
   with Convention => C_Pass_By_Copy;  -- ./webui.h:185

  -- Event type
  -- HTML element ID
  -- Internal WebUI
  -- Bind ID
  -- Client's unique ID
  -- Client's connection ID
  -- Client's full cookies
  -- -- Definitions ---------------------
  --*
  -- * @brief Create a new WebUI window object.
  -- *
  -- * @return Returns the window number.
  -- *
  -- * @example size_t myWindow = webui_new_window();
  --  

   function webui_new_window return stddef_h.size_t  -- ./webui.h:205
   with Import => True, 
        Convention => C, 
        External_Name => "webui_new_window";

  --*
  -- * @brief Create a new webui window object using a specified window number.
  -- *
  -- * @param window_number The window number (should be > 0, and < WEBUI_MAX_IDS)
  -- *
  -- * @return Returns the same window number if success.
  -- *
  -- * @example size_t myWindow = webui_new_window_id(123);
  --  

   function webui_new_window_id (window_number : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:216
   with Import => True, 
        Convention => C, 
        External_Name => "webui_new_window_id";

  --*
  -- * @brief Get a free window number that can be used with
  -- * `webui_new_window_id()`.
  -- *
  -- * @return Returns the first available free window number. Starting from 1.
  -- *
  -- * @example size_t myWindowNumber = webui_get_new_window_id();
  --  

   function webui_get_new_window_id return stddef_h.size_t  -- ./webui.h:226
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_new_window_id";

  --*
  -- * @brief Bind an HTML element and a JavaScript object with a backend function. Empty
  -- * element name means all events.
  -- *
  -- * @param window The window number
  -- * @param element The HTML element / JavaScript object
  -- * @param func The callback function
  -- *
  -- * @return Returns a unique bind ID.
  -- *
  -- * @example webui_bind(myWindow, "myFunction", myFunction);
  --  

   function webui_bind
     (window : stddef_h.size_t;
      element : Interfaces.C.Strings.chars_ptr;
      func : access procedure (arg1 : access webui_event_t)) return stddef_h.size_t  -- ./webui.h:240
   with Import => True, 
        Convention => C, 
        External_Name => "webui_bind";

  --*
  -- * @brief Get the recommended web browser ID to use. If you 
  -- * are already using one, this function will return the same ID.
  -- * 
  -- * @param window The window number
  -- * 
  -- * @return Returns a web browser ID.
  -- * 
  -- * @example size_t browserID = webui_get_best_browser(myWindow);
  --  

   function webui_get_best_browser (window : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:252
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_best_browser";

  --*
  -- * @brief Show a window using embedded HTML, or a file. If the window is already
  -- * open, it will be refreshed. This will refresh all windows in multi-client mode.
  -- *
  -- * @param window The window number
  -- * @param content The HTML, URL, Or a local file
  -- *
  -- * @return Returns True if showing the window is successed.
  -- *
  -- * @example webui_show(myWindow, "<html>...</html>"); | 
  -- * webui_show(myWindow, "index.html"); | webui_show(myWindow, "http://...");
  --  

   function webui_show (window : stddef_h.size_t; content : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:266
   with Import => True, 
        Convention => C, 
        External_Name => "webui_show";

  --*
  -- * @brief Show a window using embedded HTML, or a file. If the window is already
  -- * open, it will be refreshed. Single client.
  -- *
  -- * @param e The event struct
  -- * @param content The HTML, URL, Or a local file
  -- *
  -- * @return Returns True if showing the window is successed.
  -- *
  -- * @example webui_show_client(e, "<html>...</html>"); | 
  -- * webui_show_client(e, "index.html"); | webui_show_client(e, "http://...");
  --  

   function webui_show_client (e : access webui_event_t; content : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:280
   with Import => True, 
        Convention => C, 
        External_Name => "webui_show_client";

  --*
  -- * @brief Same as `webui_show()`. But using a specific web browser.
  -- *
  -- * @param window The window number
  -- * @param content The HTML, Or a local file
  -- * @param browser The web browser to be used
  -- *
  -- * @return Returns True if showing the window is successed.
  -- *
  -- * @example webui_show_browser(myWindow, "<html>...</html>", Chrome); |
  -- * webui_show(myWindow, "index.html", Firefox);
  --  

   function webui_show_browser
     (window : stddef_h.size_t;
      content : Interfaces.C.Strings.chars_ptr;
      browser : stddef_h.size_t) return Extensions.bool  -- ./webui.h:294
   with Import => True, 
        Convention => C, 
        External_Name => "webui_show_browser";

  --*
  -- * @brief Same as `webui_show()`. But start only the web server and return the URL.
  -- * No window will be shown.
  -- *
  -- * @param window The window number
  -- * @param content The HTML, Or a local file
  -- *
  -- * @return Returns the url of this window server.
  -- *
  -- * @example const char* url = webui_start_server(myWindow, "/full/root/path");
  --  

   function webui_start_server (window : stddef_h.size_t; content : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:307
   with Import => True, 
        Convention => C, 
        External_Name => "webui_start_server";

  --*
  -- * @brief Show a WebView window using embedded HTML, or a file. If the window is already
  -- * open, it will be refreshed. Note: Win32 need `WebView2Loader.dll`.
  -- *
  -- * @param window The window number
  -- * @param content The HTML, URL, Or a local file
  -- *
  -- * @return Returns True if showing the WebView window is successed.
  -- *
  -- * @example webui_show_wv(myWindow, "<html>...</html>"); | webui_show_wv(myWindow,
  -- * "index.html"); | webui_show_wv(myWindow, "http://...");
  --  

   function webui_show_wv (window : stddef_h.size_t; content : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:321
   with Import => True, 
        Convention => C, 
        External_Name => "webui_show_wv";

  --*
  -- * @brief Set the window in Kiosk mode (Full screen).
  -- *
  -- * @param window The window number
  -- * @param status True or False
  -- *
  -- * @example webui_set_kiosk(myWindow, true);
  --  

   procedure webui_set_kiosk (window : stddef_h.size_t; status : Extensions.bool)  -- ./webui.h:331
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_kiosk";

  --*
  -- * @brief Set the window with high-contrast support. Useful when you want to 
  -- * build a better high-contrast theme with CSS.
  -- *
  -- * @param window The window number
  -- * @param status True or False
  -- *
  -- * @example webui_set_high_contrast(myWindow, true);
  --  

   procedure webui_set_high_contrast (window : stddef_h.size_t; status : Extensions.bool)  -- ./webui.h:342
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_high_contrast";

  --*
  -- * @brief Get OS high contrast preference.
  -- *
  -- * @return Returns True if OS is using high contrast theme
  -- *
  -- * @example bool hc = webui_is_high_contrast();
  --  

   function webui_is_high_contrast return Extensions.bool  -- ./webui.h:351
   with Import => True, 
        Convention => C, 
        External_Name => "webui_is_high_contrast";

  --*
  -- * @brief Check if a web browser is installed.
  -- *
  -- * @return Returns True if the specified browser is available
  -- *
  -- * @example bool status = webui_browser_exist(Chrome);
  --  

   function webui_browser_exist (browser : stddef_h.size_t) return Extensions.bool  -- ./webui.h:360
   with Import => True, 
        Convention => C, 
        External_Name => "webui_browser_exist";

  --*
  -- * @brief Wait until all opened windows get closed.
  -- *
  -- * @example webui_wait();
  --  

   procedure webui_wait  -- ./webui.h:367
   with Import => True, 
        Convention => C, 
        External_Name => "webui_wait";

  --*
  -- * @brief Close a specific window only. The window object will still exist.
  -- * All clients.
  -- *
  -- * @param window The window number
  -- *
  -- * @example webui_close(myWindow);
  --  

   procedure webui_close (window : stddef_h.size_t)  -- ./webui.h:377
   with Import => True, 
        Convention => C, 
        External_Name => "webui_close";

  --*
  -- * @brief Close a specific client.
  -- *
  -- * @param e The event struct
  -- *
  -- * @example webui_close_client(e);
  --  

   procedure webui_close_client (e : access webui_event_t)  -- ./webui.h:386
   with Import => True, 
        Convention => C, 
        External_Name => "webui_close_client";

  --*
  -- * @brief Close a specific window and free all memory resources.
  -- *
  -- * @param window The window number
  -- *
  -- * @example webui_destroy(myWindow);
  --  

   procedure webui_destroy (window : stddef_h.size_t)  -- ./webui.h:395
   with Import => True, 
        Convention => C, 
        External_Name => "webui_destroy";

  --*
  -- * @brief Close all open windows. `webui_wait()` will return (Break).
  -- *
  -- * @example webui_exit();
  --  

   procedure webui_exit  -- ./webui.h:402
   with Import => True, 
        Convention => C, 
        External_Name => "webui_exit";

  --*
  -- * @brief Set the web-server root folder path for a specific window.
  -- *
  -- * @param window The window number
  -- * @param path The local folder full path
  -- *
  -- * @example webui_set_root_folder(myWindow, "/home/Foo/Bar/");
  --  

   function webui_set_root_folder (window : stddef_h.size_t; path : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:412
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_root_folder";

  --*
  -- * @brief Set the web-server root folder path for all windows. Should be used
  -- * before `webui_show()`.
  -- *
  -- * @param path The local folder full path
  -- *
  -- * @example webui_set_default_root_folder("/home/Foo/Bar/");
  --  

   function webui_set_default_root_folder (path : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:422
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_default_root_folder";

  --*
  -- * @brief Set a custom handler to serve files. This custom handler should
  -- * return full HTTP header and body.
  -- *
  -- * @param window The window number
  -- * @param handler The handler function: `void myHandler(const char* filename,
  -- * int* length)`
  -- *
  -- * @example webui_set_file_handler(myWindow, myHandlerFunction);
  --  

   procedure webui_set_file_handler (window : stddef_h.size_t; handler : access function (arg1 : Interfaces.C.Strings.chars_ptr; arg2 : access int) return System.Address)  -- ./webui.h:434
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_file_handler";

  --*
  -- * @brief Check if the specified window is still running.
  -- *
  -- * @param window The window number
  -- *
  -- * @example webui_is_shown(myWindow);
  --  

   function webui_is_shown (window : stddef_h.size_t) return Extensions.bool  -- ./webui.h:443
   with Import => True, 
        Convention => C, 
        External_Name => "webui_is_shown";

  --*
  -- * @brief Set the maximum time in seconds to wait for the window to connect.
  -- * This effect `show()` and `wait()`. Value of `0` means wait forever.
  -- *
  -- * @param second The timeout in seconds
  -- *
  -- * @example webui_set_timeout(30);
  --  

   procedure webui_set_timeout (second : stddef_h.size_t)  -- ./webui.h:453
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_timeout";

  --*
  -- * @brief Set the default embedded HTML favicon.
  -- *
  -- * @param window The window number
  -- * @param icon The icon as string: `<svg>...</svg>`
  -- * @param icon_type The icon type: `image/svg+xml`
  -- *
  -- * @example webui_set_icon(myWindow, "<svg>...</svg>", "image/svg+xml");
  --  

   procedure webui_set_icon
     (window : stddef_h.size_t;
      icon : Interfaces.C.Strings.chars_ptr;
      icon_type : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:464
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_icon";

  --*
  -- * @brief Encode text to Base64. The returned buffer need to be freed.
  -- *
  -- * @param str The string to encode (Should be null terminated)
  -- *
  -- * @return Returns the base64 encoded string
  -- * 
  -- * @example char* base64 = webui_encode("Foo Bar");
  --  

   function webui_encode (str : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:475
   with Import => True, 
        Convention => C, 
        External_Name => "webui_encode";

  --*
  -- * @brief Decode a Base64 encoded text. The returned buffer need to be freed.
  -- *
  -- * @param str The string to decode (Should be null terminated)
  -- * 
  -- * @return Returns the base64 decoded string
  -- *
  -- * @example char* str = webui_decode("SGVsbG8=");
  --  

   function webui_decode (str : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:486
   with Import => True, 
        Convention => C, 
        External_Name => "webui_decode";

  --*
  -- * @brief Safely free a buffer allocated by WebUI using `webui_malloc()`.
  -- *
  -- * @param ptr The buffer to be freed
  -- *
  -- * @example webui_free(myBuffer);
  --  

   procedure webui_free (ptr : System.Address)  -- ./webui.h:495
   with Import => True, 
        Convention => C, 
        External_Name => "webui_free";

  --*
  -- * @brief Safely allocate memory using the WebUI memory management system. It
  -- * can be safely freed using `webui_free()` at any time.
  -- *
  -- * @param size The size of memory in bytes
  -- *
  -- * @example char* myBuffer = (char*)webui_malloc(1024);
  --  

   function webui_malloc (size : stddef_h.size_t) return System.Address  -- ./webui.h:505
   with Import => True, 
        Convention => C, 
        External_Name => "webui_malloc";

  --*
  -- * @brief Safely send raw data to the UI. All clients.
  -- *
  -- * @param window The window number
  -- * @param function The JavaScript function to receive raw data: `function
  -- * myFunc(myData){}`
  -- * @param raw The raw data buffer
  -- * @param size The raw data size in bytes
  -- *
  -- * @example webui_send_raw(myWindow, "myJavaScriptFunc", myBuffer, 64);
  --  

   procedure webui_send_raw
     (window : stddef_h.size_t;
      c_function : Interfaces.C.Strings.chars_ptr;
      raw : System.Address;
      size : stddef_h.size_t)  -- ./webui.h:518
   with Import => True, 
        Convention => C, 
        External_Name => "webui_send_raw";

  --*
  -- * @brief Safely send raw data to the UI. Single client.
  -- *
  -- * @param e The event struct
  -- * @param function The JavaScript function to receive raw data: `function
  -- * myFunc(myData){}`
  -- * @param raw The raw data buffer
  -- * @param size The raw data size in bytes
  -- *
  -- * @example webui_send_raw_client(e, "myJavaScriptFunc", myBuffer, 64);
  --  

   procedure webui_send_raw_client
     (e : access webui_event_t;
      c_function : Interfaces.C.Strings.chars_ptr;
      raw : System.Address;
      size : stddef_h.size_t)  -- ./webui.h:531
   with Import => True, 
        Convention => C, 
        External_Name => "webui_send_raw_client";

  --*
  -- * @brief Set a window in hidden mode. Should be called before `webui_show()`.
  -- *
  -- * @param window The window number
  -- * @param status The status: True or False
  -- *
  -- * @example webui_set_hide(myWindow, True);
  --  

   procedure webui_set_hide (window : stddef_h.size_t; status : Extensions.bool)  -- ./webui.h:542
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_hide";

  --*
  -- * @brief Set the window size.
  -- *
  -- * @param window The window number
  -- * @param width The window width
  -- * @param height The window height
  -- *
  -- * @example webui_set_size(myWindow, 800, 600);
  --  

   procedure webui_set_size
     (window : stddef_h.size_t;
      width : unsigned;
      height : unsigned)  -- ./webui.h:553
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_size";

  --*
  -- * @brief Set the window position.
  -- *
  -- * @param window The window number
  -- * @param x The window X
  -- * @param y The window Y
  -- *
  -- * @example webui_set_position(myWindow, 100, 100);
  --  

   procedure webui_set_position
     (window : stddef_h.size_t;
      x : unsigned;
      y : unsigned)  -- ./webui.h:564
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_position";

  --*
  -- * @brief Set the web browser profile to use. An empty `name` and `path` means
  -- * the default user profile. Need to be called before `webui_show()`.
  -- *
  -- * @param window The window number
  -- * @param name The web browser profile name
  -- * @param path The web browser profile full path
  -- *
  -- * @example webui_set_profile(myWindow, "Bar", "/Home/Foo/Bar"); |
  -- * webui_set_profile(myWindow, "", "");
  --  

   procedure webui_set_profile
     (window : stddef_h.size_t;
      name : Interfaces.C.Strings.chars_ptr;
      path : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:577
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_profile";

  --*
  -- * @brief Set the web browser proxy server to use. Need to be called before `webui_show()`.
  -- *
  -- * @param window The window number
  -- * @param proxy_server The web browser proxy_server
  -- *
  -- * @example webui_set_proxy(myWindow, "http://127.0.0.1:8888"); 
  --  

   procedure webui_set_proxy (window : stddef_h.size_t; proxy_server : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:587
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_proxy";

  --*
  -- * @brief Get current URL of a running window.
  -- *
  -- * @param window The window number
  -- *
  -- * @return Returns the full URL string
  -- *
  -- * @example const char* url = webui_get_url(myWindow);
  --  

   function webui_get_url (window : stddef_h.size_t) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:598
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_url";

  --*
  -- * @brief Open an URL in the native default web browser.
  -- *
  -- * @param url The URL to open
  -- *
  -- * @example webui_open_url("https://webui.me");
  --  

   procedure webui_open_url (url : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:607
   with Import => True, 
        Convention => C, 
        External_Name => "webui_open_url";

  --*
  -- * @brief Allow a specific window address to be accessible from a public network.
  -- *
  -- * @param window The window number
  -- * @param status True or False
  -- *
  -- * @example webui_set_public(myWindow, true);
  --  

   procedure webui_set_public (window : stddef_h.size_t; status : Extensions.bool)  -- ./webui.h:617
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_public";

  --*
  -- * @brief Navigate to a specific URL. All clients.
  -- *
  -- * @param window The window number
  -- * @param url Full HTTP URL
  -- *
  -- * @example webui_navigate(myWindow, "http://domain.com");
  --  

   procedure webui_navigate (window : stddef_h.size_t; url : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:627
   with Import => True, 
        Convention => C, 
        External_Name => "webui_navigate";

  --*
  -- * @brief Navigate to a specific URL. Single client.
  -- *
  -- * @param e The event struct
  -- * @param url Full HTTP URL
  -- *
  -- * @example webui_navigate_client(e, "http://domain.com");
  --  

   procedure webui_navigate_client (e : access webui_event_t; url : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:637
   with Import => True, 
        Convention => C, 
        External_Name => "webui_navigate_client";

  --*
  -- * @brief Free all memory resources. Should be called only at the end.
  -- *
  -- * @example
  -- * webui_wait();
  -- * webui_clean();
  --  

   procedure webui_clean  -- ./webui.h:646
   with Import => True, 
        Convention => C, 
        External_Name => "webui_clean";

  --*
  -- * @brief Delete all local web-browser profiles folder. It should be called at the
  -- * end.
  -- *
  -- * @example
  -- * webui_wait();
  -- * webui_delete_all_profiles();
  -- * webui_clean();
  --  

   procedure webui_delete_all_profiles  -- ./webui.h:657
   with Import => True, 
        Convention => C, 
        External_Name => "webui_delete_all_profiles";

  --*
  -- * @brief Delete a specific window web-browser local folder profile.
  -- *
  -- * @param window The window number
  -- *
  -- * @example
  -- * webui_wait();
  -- * webui_delete_profile(myWindow);
  -- * webui_clean();
  -- *
  -- * @note This can break functionality of other windows if using the same
  -- * web-browser.
  --  

   procedure webui_delete_profile (window : stddef_h.size_t)  -- ./webui.h:672
   with Import => True, 
        Convention => C, 
        External_Name => "webui_delete_profile";

  --*
  -- * @brief Get the ID of the parent process (The web browser may re-create
  -- * another new process).
  -- *
  -- * @param window The window number
  -- *
  -- * @return Returns the the parent process id as integer
  -- *
  -- * @example size_t id = webui_get_parent_process_id(myWindow);
  --  

   function webui_get_parent_process_id (window : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:684
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_parent_process_id";

  --*
  -- * @brief Get the ID of the last child process.
  -- *
  -- * @param window The window number
  -- *
  -- * @return Returns the the child process id as integer
  -- *
  -- * @example size_t id = webui_get_child_process_id(myWindow);
  --  

   function webui_get_child_process_id (window : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:695
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_child_process_id";

  --*
  -- * @brief Get the network port of a running window.
  -- * This can be useful to determine the HTTP link of `webui.js`
  -- *
  -- * @param window The window number
  -- * 
  -- * @return Returns the network port of the window
  -- *
  -- * @example size_t port = webui_get_port(myWindow);
  --  

   function webui_get_port (window : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:707
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_port";

  --*
  -- * @brief Set a custom web-server/websocket network port to be used by WebUI.
  -- * This can be useful to determine the HTTP link of `webui.js` in case
  -- * you are trying to use WebUI with an external web-server like NGNIX.
  -- *
  -- * @param window The window number
  -- * @param port The web-server network port WebUI should use
  -- *
  -- * @return Returns True if the port is free and usable by WebUI
  -- *
  -- * @example bool ret = webui_set_port(myWindow, 8080);
  --  

   function webui_set_port (window : stddef_h.size_t; port : stddef_h.size_t) return Extensions.bool  -- ./webui.h:721
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_port";

  --*
  -- * @brief Get an available usable free network port.
  -- *
  -- * @return Returns a free port
  -- *
  -- * @example size_t port = webui_get_free_port();
  --  

   function webui_get_free_port return stddef_h.size_t  -- ./webui.h:730
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_free_port";

  --*
  -- * @brief Control the WebUI behaviour. It's recommended to be called at the beginning.
  -- *
  -- * @param option The desired option from `webui_config` enum
  -- * @param status The status of the option, `true` or `false`
  -- *
  -- * @example webui_set_config(show_wait_connection, false);
  --  

   procedure webui_set_config (option : webui_config; status : Extensions.bool)  -- ./webui.h:740
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_config";

  --*
  -- * @brief Control if UI events comming from this window should be processed
  -- * one a time in a single blocking thread `True`, or process every event in
  -- * a new non-blocking thread `False`. This update single window. You can use 
  -- * `webui_set_config(ui_event_blocking, ...)` to update all windows.
  -- *
  -- * @param window The window number
  -- * @param status The blocking status `true` or `false`
  -- *
  -- * @example webui_set_event_blocking(myWindow, true);
  --  

   procedure webui_set_event_blocking (window : stddef_h.size_t; status : Extensions.bool)  -- ./webui.h:753
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_event_blocking";

  --*
  -- * @brief Get the HTTP mime type of a file.
  -- *
  -- * @return Returns the HTTP mime string
  -- *
  -- * @example const char* mime = webui_get_mime_type("foo.png");
  --  

   function webui_get_mime_type (file : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:762
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_mime_type";

  -- -- SSL/TLS -------------------------
  --*
  -- * @brief Set the SSL/TLS certificate and the private key content, both in PEM
  -- * format. This works only with `webui-2-secure` library. If set empty WebUI
  -- * will generate a self-signed certificate.
  -- *
  -- * @param certificate_pem The SSL/TLS certificate content in PEM format
  -- * @param private_key_pem The private key content in PEM format
  -- *
  -- * @return Returns True if the certificate and the key are valid.
  -- *
  -- * @example bool ret = webui_set_tls_certificate("-----BEGIN
  -- * CERTIFICATE-----\n...", "-----BEGIN PRIVATE KEY-----\n...");
  --  

   function webui_set_tls_certificate (certificate_pem : Interfaces.C.Strings.chars_ptr; private_key_pem : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- ./webui.h:779
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_tls_certificate";

  -- -- JavaScript ----------------------
  --*
  -- * @brief Run JavaScript without waiting for the response. All clients.
  -- *
  -- * @param window The window number
  -- * @param script The JavaScript to be run
  -- *
  -- * @example webui_run(myWindow, "alert('Hello');");
  --  

   procedure webui_run (window : stddef_h.size_t; script : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:791
   with Import => True, 
        Convention => C, 
        External_Name => "webui_run";

  --*
  -- * @brief Run JavaScript without waiting for the response. Single client.
  -- *
  -- * @param e The event struct
  -- * @param script The JavaScript to be run
  -- *
  -- * @example webui_run_client(e, "alert('Hello');");
  --  

   procedure webui_run_client (e : access webui_event_t; script : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:801
   with Import => True, 
        Convention => C, 
        External_Name => "webui_run_client";

  --*
  -- * @brief Run JavaScript and get the response back. Work only in single client mode.
  -- * Make sure your local buffer can hold the response.
  -- *
  -- * @param window The window number
  -- * @param script The JavaScript to be run
  -- * @param timeout The execution timeout in seconds
  -- * @param buffer The local buffer to hold the response
  -- * @param buffer_length The local buffer size
  -- *
  -- * @return Returns True if there is no execution error
  -- *
  -- * @example bool err = webui_script(myWindow, "return 4 + 6;", 0, myBuffer, myBufferSize);
  --  

   function webui_script
     (window : stddef_h.size_t;
      script : Interfaces.C.Strings.chars_ptr;
      timeout : stddef_h.size_t;
      buffer : Interfaces.C.Strings.chars_ptr;
      buffer_length : stddef_h.size_t) return Extensions.bool  -- ./webui.h:817
   with Import => True, 
        Convention => C, 
        External_Name => "webui_script";

  --*
  -- * @brief Run JavaScript and get the response back. Single client.
  -- * Make sure your local buffer can hold the response.
  -- *
  -- * @param e The event struct
  -- * @param script The JavaScript to be run
  -- * @param timeout The execution timeout in seconds
  -- * @param buffer The local buffer to hold the response
  -- * @param buffer_length The local buffer size
  -- *
  -- * @return Returns True if there is no execution error
  -- *
  -- * @example bool err = webui_script_client(e, "return 4 + 6;", 0, myBuffer, myBufferSize);
  --  

   function webui_script_client
     (e : access webui_event_t;
      script : Interfaces.C.Strings.chars_ptr;
      timeout : stddef_h.size_t;
      buffer : Interfaces.C.Strings.chars_ptr;
      buffer_length : stddef_h.size_t) return Extensions.bool  -- ./webui.h:834
   with Import => True, 
        Convention => C, 
        External_Name => "webui_script_client";

  --*
  -- * @brief Chose between Deno and Nodejs as runtime for .js and .ts files.
  -- *
  -- * @param window The window number
  -- * @param runtime Deno | Bun | Nodejs | None
  -- *
  -- * @example webui_set_runtime(myWindow, Deno);
  --  

   procedure webui_set_runtime (window : stddef_h.size_t; runtime : stddef_h.size_t)  -- ./webui.h:845
   with Import => True, 
        Convention => C, 
        External_Name => "webui_set_runtime";

  --*
  -- * @brief Get how many arguments there are in an event.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns the arguments count.
  -- *
  -- * @example size_t count = webui_get_count(e);
  --  

   function webui_get_count (e : access webui_event_t) return stddef_h.size_t  -- ./webui.h:856
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_count";

  --*
  -- * @brief Get an argument as integer at a specific index.
  -- *
  -- * @param e The event struct
  -- * @param index The argument position starting from 0
  -- *
  -- * @return Returns argument as integer
  -- *
  -- * @example long long int myNum = webui_get_int_at(e, 0);
  --  

   function webui_get_int_at (e : access webui_event_t; index : stddef_h.size_t) return Long_Long_Integer  -- ./webui.h:868
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_int_at";

  --*
  -- * @brief Get the first argument as integer.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns argument as integer
  -- *
  -- * @example long long int myNum = webui_get_int(e);
  --  

   function webui_get_int (e : access webui_event_t) return Long_Long_Integer  -- ./webui.h:879
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_int";

  --*
  -- * @brief Get an argument as float at a specific index.
  -- *
  -- * @param e The event struct
  -- * @param index The argument position starting from 0
  -- *
  -- * @return Returns argument as float
  -- *
  -- * @example double myNum = webui_get_float_at(e, 0);
  --  

   function webui_get_float_at (e : access webui_event_t; index : stddef_h.size_t) return double  -- ./webui.h:891
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_float_at";

  --*
  -- * @brief Get the first argument as float.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns argument as float
  -- *
  -- * @example double myNum = webui_get_float(e);
  --  

   function webui_get_float (e : access webui_event_t) return double  -- ./webui.h:902
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_float";

  --*
  -- * @brief Get an argument as string at a specific index.
  -- *
  -- * @param e The event struct
  -- * @param index The argument position starting from 0
  -- *
  -- * @return Returns argument as string
  -- *
  -- * @example const char* myStr = webui_get_string_at(e, 0);
  --  

   function webui_get_string_at (e : access webui_event_t; index : stddef_h.size_t) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:914
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_string_at";

  --*
  -- * @brief Get the first argument as string.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns argument as string
  -- *
  -- * @example const char* myStr = webui_get_string(e);
  --  

   function webui_get_string (e : access webui_event_t) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:925
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_string";

  --*
  -- * @brief Get an argument as boolean at a specific index.
  -- *
  -- * @param e The event struct
  -- * @param index The argument position starting from 0
  -- *
  -- * @return Returns argument as boolean
  -- *
  -- * @example bool myBool = webui_get_bool_at(e, 0);
  --  

   function webui_get_bool_at (e : access webui_event_t; index : stddef_h.size_t) return Extensions.bool  -- ./webui.h:937
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_bool_at";

  --*
  -- * @brief Get the first argument as boolean.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns argument as boolean
  -- *
  -- * @example bool myBool = webui_get_bool(e);
  --  

   function webui_get_bool (e : access webui_event_t) return Extensions.bool  -- ./webui.h:948
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_bool";

  --*
  -- * @brief Get the size in bytes of an argument at a specific index.
  -- *
  -- * @param e The event struct
  -- * @param index The argument position starting from 0
  -- *
  -- * @return Returns size in bytes
  -- *
  -- * @example size_t argLen = webui_get_size_at(e, 0);
  --  

   function webui_get_size_at (e : access webui_event_t; index : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:960
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_size_at";

  --*
  -- * @brief Get size in bytes of the first argument.
  -- *
  -- * @param e The event struct
  -- *
  -- * @return Returns size in bytes
  -- *
  -- * @example size_t argLen = webui_get_size(e);
  --  

   function webui_get_size (e : access webui_event_t) return stddef_h.size_t  -- ./webui.h:971
   with Import => True, 
        Convention => C, 
        External_Name => "webui_get_size";

  --*
  -- * @brief Return the response to JavaScript as integer.
  -- *
  -- * @param e The event struct
  -- * @param n The integer to be send to JavaScript
  -- *
  -- * @example webui_return_int(e, 123);
  --  

   procedure webui_return_int (e : access webui_event_t; n : Long_Long_Integer)  -- ./webui.h:981
   with Import => True, 
        Convention => C, 
        External_Name => "webui_return_int";

  --*
  -- * @brief Return the response to JavaScript as float.
  -- *
  -- * @param e The event struct
  -- * @param f The float number to be send to JavaScript
  -- *
  -- * @example webui_return_float(e, 123.456);
  --  

   procedure webui_return_float (e : access webui_event_t; f : double)  -- ./webui.h:991
   with Import => True, 
        Convention => C, 
        External_Name => "webui_return_float";

  --*
  -- * @brief Return the response to JavaScript as string.
  -- *
  -- * @param e The event struct
  -- * @param n The string to be send to JavaScript
  -- *
  -- * @example webui_return_string(e, "Response...");
  --  

   procedure webui_return_string (e : access webui_event_t; s : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:1001
   with Import => True, 
        Convention => C, 
        External_Name => "webui_return_string";

  --*
  -- * @brief Return the response to JavaScript as boolean.
  -- *
  -- * @param e The event struct
  -- * @param n The boolean to be send to JavaScript
  -- *
  -- * @example webui_return_bool(e, true);
  --  

   procedure webui_return_bool (e : access webui_event_t; b : Extensions.bool)  -- ./webui.h:1011
   with Import => True, 
        Convention => C, 
        External_Name => "webui_return_bool";

  -- -- Wrapper's Interface -------------
  --*
  -- * @brief Bind a specific HTML element click event with a function. Empty element means all events.
  -- *
  -- * @param window The window number
  -- * @param element The element ID
  -- * @param func The callback as myFunc(Window, EventType, Element, EventNumber, BindID)
  -- *
  -- * @return Returns unique bind ID
  -- *
  -- * @example size_t id = webui_interface_bind(myWindow, "myID", myCallback);
  --  

   function webui_interface_bind
     (window : stddef_h.size_t;
      element : Interfaces.C.Strings.chars_ptr;
      func : access procedure
        (arg1 : stddef_h.size_t;
         arg2 : stddef_h.size_t;
         arg3 : Interfaces.C.Strings.chars_ptr;
         arg4 : stddef_h.size_t;
         arg5 : stddef_h.size_t)) return stddef_h.size_t  -- ./webui.h:1026
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_bind";

  --*
  -- * @brief When using `webui_interface_bind()`, you may need this function to easily set a response.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param response The response as string to be send to JavaScript
  -- *
  -- * @example webui_interface_set_response(myWindow, e->event_number, "Response...");
  --  

   procedure webui_interface_set_response
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      response : Interfaces.C.Strings.chars_ptr)  -- ./webui.h:1038
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_set_response";

  --*
  -- * @brief Check if the app still running.
  -- *
  -- * @return Returns True if app is running
  -- *
  -- * @example bool status = webui_interface_is_app_running();
  --  

   function webui_interface_is_app_running return Extensions.bool  -- ./webui.h:1047
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_is_app_running";

  --*
  -- * @brief Get a unique window ID.
  -- *
  -- * @param window The window number
  -- *
  -- * @return Returns the unique window ID as integer
  -- *
  -- * @example size_t id = webui_interface_get_window_id(myWindow);
  --  

   function webui_interface_get_window_id (window : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:1058
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_window_id";

  --*
  -- * @brief Get an argument as string at a specific index.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param index The argument position
  -- *
  -- * @return Returns argument as string
  -- *
  -- * @example const char* myStr = webui_interface_get_string_at(myWindow, e->event_number, 0);
  --  

   function webui_interface_get_string_at
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      index : stddef_h.size_t) return Interfaces.C.Strings.chars_ptr  -- ./webui.h:1071
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_string_at";

  --*
  -- * @brief Get an argument as integer at a specific index.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param index The argument position
  -- *
  -- * @return Returns argument as integer
  -- *
  -- * @example long long int myNum = webui_interface_get_int_at(myWindow, e->event_number, 0);
  --  

   function webui_interface_get_int_at
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      index : stddef_h.size_t) return Long_Long_Integer  -- ./webui.h:1084
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_int_at";

  --*
  -- * @brief Get an argument as float at a specific index.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param index The argument position
  -- *
  -- * @return Returns argument as float
  -- *
  -- * @example double myFloat = webui_interface_get_int_at(myWindow, e->event_number, 0);
  --  

   function webui_interface_get_float_at
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      index : stddef_h.size_t) return double  -- ./webui.h:1097
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_float_at";

  --*
  -- * @brief Get an argument as boolean at a specific index.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param index The argument position
  -- *
  -- * @return Returns argument as boolean
  -- *
  -- * @example bool myBool = webui_interface_get_bool_at(myWindow, e->event_number, 0);
  --  

   function webui_interface_get_bool_at
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      index : stddef_h.size_t) return Extensions.bool  -- ./webui.h:1110
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_bool_at";

  --*
  -- * @brief Get the size in bytes of an argument at a specific index.
  -- *
  -- * @param window The window number
  -- * @param event_number The event number
  -- * @param index The argument position
  -- *
  -- * @return Returns size in bytes
  -- *
  -- * @example size_t argLen = webui_interface_get_size_at(myWindow, e->event_number, 0);
  --  

   function webui_interface_get_size_at
     (window : stddef_h.size_t;
      event_number : stddef_h.size_t;
      index : stddef_h.size_t) return stddef_h.size_t  -- ./webui.h:1123
   with Import => True, 
        Convention => C, 
        External_Name => "webui_interface_get_size_at";

end webui_h;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
