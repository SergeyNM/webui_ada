------------------------------------------------------------------------------
--
--  WebUI_Ada is thin wrapper for WebUI Library
--  TODO: URL to git, crate ...
--
------------------------------------------------------------------------------
--
--  WebUI Library
--  https://webui.me
--  https://github.com/webui-dev/webui
--  Copyright (c) 2020-2024 Hassan Draga.
--  Licensed under MIT License.
--  All rights reserved.
--  Canada.
--
------------------------------------------------------------------------------

pragma Ada_2012;

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with System;

-----------
-- Webui --
-----------

--  Memo:
--  Avoiding warning 8-bit Ada Boolean return type, use Char
--  https://stackoverflow.com/questions/75516063/
--  avoiding-warning-8-bit-ada-boolean-return-type-use-char

package Webui is
   package C renames Interfaces.C;
   package C_Str renames Interfaces.C.Strings;

   VERSION : aliased constant String := "2.5.0-beta.2"
    & ASCII.NUL;  --  ./webui.h:14

   MAX_IDS : constant := (256);  --  ./webui.h:17
   MAX_ARG : constant := (16);   --  ./webui.h:20

  --  unsupported macro: WEBUI_EXPORT extern
  --  unsupported macro: WEBUI_GET_CURRENT_DIR getcwd
  --  unsupported macro: WEBUI_FILE_EXIST access
  --  unsupported macro: WEBUI_POPEN popen
  --  unsupported macro: WEBUI_PCLOSE pclose
  --  unsupported macro: WEBUI_MAX_PATH PATH_MAX
  --  TODO: ^ ?

  --  Max windows, servers and threads
  --  Max allowed argument's index
  --  Dynamic Library Exports
  -- -- C STD ---------------------------
  -- -- Windows -------------------------
  -- -- Linux ---------------------------
  -- -- Apple ---------------------------

   -- -- Enums ---------------------------
   --
   --  type Browser is
   type Browser_Kind is
     (NoBrowser,     --  0.  No web browser
      AnyBrowser,    --  1.  Default recommended web browser
      Chrome,        --  2.  Google Chrome
      Firefox,       --  3.  Mozilla Firefox
      Edge,          --  4.  Microsoft Edge
      Safari,        --  5.  Apple Safari
      Chromium,      --  6.  The Chromium Project
      Opera,         --  7.  Opera Browser
      Brave,         --  8.  The Brave Browser
      Vivaldi,       --  9.  The Vivaldi Browser
      Epic,          --  10. The Epic Browser
      Yandex,        --  11. The Yandex Browser
      ChromiumBased, --  12. Any Chromium based browser
      Webview        --  13. WebView (Non-web-browser)
     ) with
     Convention => C;  -- ./webui.h:118

   --  subtype Browser_Kind is Browser;
   --
   --  TODO: Replaced the definitions above in the file
   --  'type Browser is ..' to 'type Browser_Kind is ..'
   --
   --  subtype Browser is Browser_Kind;

   --  type Runtime is
   type Runtime_Kind is
     (None,   --  0. Prevent WebUI from using any runtime for .js and .ts files
      Deno,   --  1. Use Deno runtime for .js and .ts files
      NodeJS, --  2. Use Nodejs runtime for .js files
      Bun     --  3. Use Bun runtime for .js and .ts files
     ) with
     Convention => C;  -- ./webui.h:135

   type Event is
   --  type Event_Kind is
     (DISCONNECTED, --  0. Window disconnection event
      CONNECTED,    --  1. Window connection event
      MOUSE_CLICK,  --  2. Mouse click event
      NAVIGATION,   --  3. Window navigation event
      CALLBACK      --  4. Function call event
     ) with
     Convention => C;  -- ./webui.h:142

   --  type Config is
   type Config_Kind is
     (
      --  Control if `webui_show()`, `webui_show_browser()` and
      --  `webui_show_wv()` should wait for the window to connect
      --  before returns or not.
      --  Default: True
      show_wait_connection,
      --  Control if WebUI should block and process the UI events
      --  one a time in a single thread `True`, or process every
      --  event in a new non-blocking thread `False`. This updates
      --  all windows. You can use `webui_set_event_blocking()` for
      --  a specific single window update.
      --  Default: False
      ui_event_blocking,
      --  Automatically refresh the window UI when any file in the
      --  root folder gets changed.
      --  Default: False
      folder_monitor,
      --  Allow multiple clients to connect to the same window,
      --  This is helpful for web apps (non-desktop software),
      --  Please see the documentation for more details.
      --  Default: False
      multi_client,
      --  Allow multiple clients to connect to the same window,
      --  This is helpful for web apps (non-desktop software),
      --  Please see the documentation for more details.
      --  Default: False
      use_cookies) with
     Convention => C;  -- ./webui.h:182

   -- -- Structs -------------------------
   type Event_t is record
      window        : aliased size_t;  -- ./webui.h:186
      --  The window object number
      event_type    : aliased size_t;  -- ./webui.h:187
      --  Event type
      element       : C_Str.chars_ptr;  -- ./webui.h:188
      --  HTML element ID
      event_number  : aliased size_t;  -- ./webui.h:189
      --  Internal WebUI
      bind_id       : aliased size_t;  -- ./webui.h:190
      --  Bind ID
      client_id     : aliased size_t;  -- ./webui.h:191
      --  Client's unique ID
      connection_id : aliased size_t;  -- ./webui.h:192
      --  Client's connection ID
      cookies       : C_Str.chars_ptr;  -- ./webui.h:193
      --  Client's full cookies
   end record with
     Convention => C_Pass_By_Copy;  -- ./webui.h:185

   --  Ada bind subtypes : begin
   --
   subtype Window_Identifier is C.size_t range 1 .. MAX_IDS - 1;
   subtype Arg_Count is C.size_t range 1 .. MAX_ARG;

   subtype Network_Port is C.size_t range 0 .. 2 ** 16 - 1;
   --  Is a 16-bit unsigned integer, thus ranging from 0 to 65535.
   --   For TCP, port number 0 is reserved and cannot be used, while for UDP,
   --   the source port is optional and a value of zero means no port

   --  TODO: specify range?
   subtype Bind_Identifier is C.size_t;

   --  subtype Event_Kind is Event;

   type Config_Range is range
     Config_Kind'Pos (Config_Kind'First) .. Config_Kind'Pos (Config_Kind'Last);
   for Config_Range'Size use Config_Kind'Size;
   --
   --  Ada bind subtypes : end

   -- -- Definitions ---------------------

   --  @brief Create a new WebUI window object.
   --
   --  @return Returns the window number.
   --
   --  @example size_t myWindow = webui_new_window();
   function New_Window
     return Window_Identifier  -- ./webui.h:205
     with
       Import => True, Convention => C, External_Name => "webui_new_window";

   --  @brief Create a new webui window object using a specified window number.
   --
   --  @param window_number The window number
   --   (should be > 0, and < WEBUI_MAX_IDS)
   --
   --  @return Returns the same window number if success.
   --
   --  @example size_t myWindow = webui_new_window_id(123);
   function New_Window_Id
     (Window_Number : Window_Identifier)
    return Window_Identifier  -- ./webui.h:216
     with
       Import => True, Convention => C, External_Name => "webui_new_window_id";

   --  @brief Get a free window number that can be used with
   --  `webui_new_window_id()`.
   --
   --  @return Returns the first available free window number. Starting from 1.
   --
   --  @example size_t myWindowNumber = webui_get_new_window_id();
   function Get_New_Window_Id
     return Window_Identifier  -- ./webui.h:226
     with
       Import => True, Convention => C,
       External_Name => "webui_get_new_window_id";

   --  @brief Bind an HTML element and a JavaScript object with a backend
   --  function. Empty element name means all events.
   --
   --  @param window The window number
   --  @param element The HTML element / JavaScript object
   --  @param func The callback function
   --
   --  @return Returns a unique bind ID.
   --
   --  @example webui_bind(myWindow, "myFunction", myFunction);
   function Bind
     (Window : Window_Identifier; element : C_Str.chars_ptr;
      func   : access procedure (arg1 : access Event_t))
    return Bind_Identifier  -- ./webui.h:240
     with
       Import => True, Convention => C, External_Name => "webui_bind";

   function Bind
     (Window  : Window_Identifier;
      Element : String;
      Func    : access procedure (arg1 : access Event_t))
      return Bind_Identifier;

   --  @brief Get the recommended web browser ID to use. If you
   --  are already using one, this function will return the same ID.
   --
   --  @param window The window number
   --
   --  @return Returns a web browser ID.
   --
   --  @example size_t browserID = webui_get_best_browser(myWindow);
   function Get_Best_Browser
     (Window : Window_Identifier)
    return size_t  -- ./webui.h:252
     with
       Import => True, Convention => C,
       External_Name => "webui_get_best_browser";

   function Get_Best_Browser (Window : Window_Identifier) return Browser_Kind;

   --  @brief Show a window using embedded HTML, or a file. If the window is
   --  already open, it will be refreshed. This will refresh all windows in
   --  multi-client mode.
   --
   --  @param window The window number
   --  @param content The HTML, URL, Or a local file
   --
   --  @return Returns True if showing the window is successed.
   --
   --  @example webui_show(myWindow, "<html>...</html>"); |
   --   webui_show(myWindow, "index.html"); |
   --   webui_show(myWindow, "http://...");
   function Show
     (Window : Window_Identifier; content : C_Str.chars_ptr)
    return C_bool  --  ./webui.h:266
       with
         Import => True, Convention => C, External_Name => "webui_show";

   function Show
     (Window :  Window_Identifier; Content : String) return Boolean;

   --  @brief Show a window using embedded HTML, or a file. If the window is
   --  already open, it will be refreshed. Single client.
   --
   --  @param e The event struct
   --  @param content The HTML, URL, Or a local file
   --
   --  @return Returns True if showing the window is successed.
   --
   --  @example webui_show_client(e, "<html>...</html>"); |
   --  webui_show_client(e, "index.html"); |
   --  webui_show_client(e, "http://...");
   function Show_Client
     (e : access Event_t; content : C_Str.chars_ptr)
    return C_bool  --  ./webui.h:280
       with
         Import => True, Convention => C, External_Name => "webui_show_client";

   function Show_Client
     (E : access Event_t; Content : String) return Boolean;

   --  @brief Same as `webui_show()`. But using a specific web browser.
   --
   --  @param window The window number
   --  @param content The HTML, Or a local file
   --  @param browser The web browser to be used
   --
   --  @return Returns True if showing the window is successed.
   --
   --  @example webui_show_browser(myWindow, "<html>...</html>", Chrome); |
   --  webui_show(myWindow, "index.html", Firefox);
   function Show_Browser
     (Window : Window_Identifier; content : C_Str.chars_ptr;
      browser : size_t) return C_bool  --  ./webui.h:294
       with
       Import => True, Convention => C,
       External_Name => "webui_show_browser";

   function Show_Browser
     (Window : Window_Identifier;
      Content : String; Browser : Browser_Kind) return Boolean;

   --  @brief Same as `webui_show()`. But start only the web server and return
   --  the URL. No window will be shown.
   --
   --  @param window The window number
   --  @param content The HTML, Or a local file
   --
   --  @return Returns the url of this window server.
   --
   --  @example const char* url =
   --   webui_start_server(myWindow, "/full/root/path");
   function Start_Server
     (Window : Window_Identifier; content : C_Str.chars_ptr)
    return C_Str.chars_ptr  -- ./webui.h:307
       with
         Import => True, Convention => C,
         External_Name => "webui_start_server";

   function Start_Server
     (Window : Window_Identifier; Content : String) return String;

   --  @brief Show a WebView window using embedded HTML, or a file. If the
   --  window is already open, it will be refreshed. Note: Win32 need
   --  `WebView2Loader.dll`.
   --
   --  @param window The window number
   --  @param content The HTML, URL, Or a local file
   --
   --  @return Returns True if showing the WebView window is successed.
   --
   --  @example webui_show_wv(myWindow, "<html>...</html>"); |
   --   webui_show_wv(myWindow, "index.html"); |
   --   webui_show_wv(myWindow, "http://...");
   function Show_WV
     (Window : Window_Identifier; content : C_Str.chars_ptr)
    return C_bool  --  ./webui.h:321
       with
       Import => True, Convention => C,
       External_Name => "webui_show_wv";

   function Show_WV
     (Window : Window_Identifier; Content : String) return Boolean;

   --  @brief Set the window in Kiosk mode (Full screen).
   --
   --  @param window The window number
   --  @param status True or False
   --
   --  @example webui_set_kiosk(myWindow, true);
   procedure Set_Kiosk
     (Window : Window_Identifier; status : C_bool)  -- ./webui.h:331
     with
       Import => True, Convention => C, External_Name => "webui_set_kiosk";

   --  @brief Set the window with high-contrast support. Useful when you want
   --  to build a better high-contrast theme with CSS.
   --
   --  @param window The window number
   --  @param status True or False
   --
   --  @example webui_set_high_contrast(myWindow, true);
   procedure Set_High_Contrast
     (Window : Window_Identifier; status : C_bool)  -- ./webui.h:342
     with
       Import => True, Convention => C,
       External_Name => "webui_set_high_contrast";

   --  @brief Get OS high contrast preference.
   --
   --  @return Returns True if OS is using high contrast theme
   --
   --  @example bool hc = webui_is_high_contrast();
   function Is_High_Contrast return C_bool  --  ./webui.h:351
       with
       Import => True, Convention => C,
       External_Name => "webui_is_high_contrast";

   --  @brief Check if a web browser is installed.
   --
   --  @return Returns True if the specified browser is available
   --
   --  @example bool status = webui_browser_exist(Chrome);
   function Browser_Exist
     (browser : size_t) return C_bool  --  ./webui.h:360
       with
       Import => True, Convention => C,
       External_Name => "webui_browser_exist";

   function Browser_Exist (Browser : Browser_Kind) return Boolean;

   --  @brief Wait until all opened windows get closed.
   --
   --  @example webui_wait();
   procedure Wait  -- ./webui.h:367
     with
       Import => True, Convention => C, External_Name => "webui_wait";

   --  @brief Close a specific window only. The window object will still exist.
   --  All clients.
   --
   --  @param window The window number
   --
   --  @example webui_close(myWindow);
   procedure Close
     (Window : Window_Identifier)  -- ./webui.h:377
     with
       Import => True, Convention => C, External_Name => "webui_close";

   --  @brief Close a specific client.
   --
   --  @param e The event struct
   --
   --  @example webui_close_client(e);
   procedure Close_Client
     (E : access Event_t)  -- ./webui.h:386
     with
       Import => True, Convention => C, External_Name => "webui_close_client";

   --  @brief Close a specific window and free all memory resources.
   --
   --  @param window The window number
   --
   --  @example webui_destroy(myWindow);
   procedure Destroy
     (Window : Window_Identifier)  -- ./webui.h:395
     with
       Import => True, Convention => C, External_Name => "webui_destroy";

   --  @brief Close all open windows. `webui_wait()` will return (Break).
   --
   --  @example webui_exit();
   procedure Exit_All  -- ./webui.h:402
   --   procedure webui_exit  -- ./webui.h:402
     with
       Import => True, Convention => C, External_Name => "webui_exit";
   --  TODO: 'exit' - reserved word in Ada. Choose a name for 'webui_exit'

   --  @brief Set the web-server root folder path for a specific window.
   --
   --  @param window The window number
   --  @param path The local folder full path
   --
   --  @example webui_set_root_folder(myWindow, "/home/Foo/Bar/");
   function Set_Root_Folder
     (Window : Window_Identifier; path : C_Str.chars_ptr)
    return C_bool  -- ./webui.h:412
       with
       Import => True, Convention => C,
       External_Name => "webui_set_root_folder";

   function Set_Root_Folder (Window : Window_Identifier; Path : String)
    return Boolean;
    --  with Inline;  --  TODO: ?

   --  @brief Set the web-server root folder path for all windows. Should be
   --  used before `webui_show()`.
   --
   --  @param path The local folder full path
   --
   --  @example webui_set_default_root_folder("/home/Foo/Bar/");
   function Set_Default_Root_Folder
     (path : C_Str.chars_ptr) return C_bool  --  ./webui.h:422
       with
         Import        => True, Convention => C,
         External_Name => "webui_set_default_root_folder";

   function Set_Default_Root_Folder (Path : String) return Boolean;

   --  @brief Set a custom handler to serve files. This custom handler should
   --  return full HTTP header and body.
   --
   --  @param window The window number
   --  @param handler The handler function: `void myHandler(
   --  const char* filename, int* length)`
   --
   --  @example webui_set_file_handler(myWindow, myHandlerFunction);
   procedure Set_File_Handler
     (Window : Window_Identifier;
      handler : access function
        (arg1 : C_Str.chars_ptr; arg2 : access int)
      return System.Address)  -- ./webui.h:434
     with
       Import => True, Convention => C,
       External_Name => "webui_set_file_handler";

   --  @brief Check if the specified window is still running.
   --
   --  @param window The window number
   --
   --  @example webui_is_shown(myWindow);
   function Is_Shown
     (Window : Window_Identifier) return C_bool  --  ./webui.h:443
       with
         Import => True, Convention => C, External_Name => "webui_is_shown";

   --  @brief Set the maximum time in seconds to wait for the window to
   --   connect. This effect `show()` and `wait()`. Value of `0` means wait
   --   forever.
   --
   --  @param second The timeout in seconds
   --
   --  @example webui_set_timeout(30);
   procedure Set_Timeout
     (second : size_t)  -- ./webui.h:453
     with
       Import => True, Convention => C, External_Name => "webui_set_timeout";

   --  @brief Set the default embedded HTML favicon.
   --
   --  @param window The window number
   --  @param icon The icon as string: `<svg>...</svg>`
   --  @param icon_type The icon type: `image/svg+xml`
   --
   --  @example webui_set_icon(myWindow, "<svg>...</svg>", "image/svg+xml");
   procedure Set_Icon
     (Window : Window_Identifier; icon : C_Str.chars_ptr;
      icon_type : C_Str.chars_ptr)  -- ./webui.h:464
     with
       Import => True, Convention => C, External_Name => "webui_set_icon";

   procedure Set_Icon
     (Window : Window_Identifier; Icon : String; Icon_Type : String);

   --  @brief Encode text to Base64. The returned buffer need to be freed.
   --
   --  @param str The string to encode (Should be null terminated)
   --
   --  @return Returns the base64 encoded string
   --
   --  @example char* base64 = webui_encode("Foo Bar");
   function Encode
     (str : C_Str.chars_ptr)
    return C_Str.chars_ptr  -- ./webui.h:475
       with
         Import => True, Convention => C, External_Name => "webui_encode";

   --  @brief Decode a Base64 encoded text. The returned buffer need to be
   --   freed.
   --
   --  @param str The string to decode (Should be null terminated)
   --
   --  @return Returns the base64 decoded string
   --
   --  @example char* str = webui_decode("SGVsbG8=");
   function Decode
     (str : C_Str.chars_ptr)
    return C_Str.chars_ptr  -- ./webui.h:486
       with
         Import => True, Convention => C, External_Name => "webui_decode";

   --  @brief Safely free a buffer allocated by WebUI using `webui_malloc()`.
   --
   --  @param ptr The buffer to be freed
   --
   --  @example webui_free(myBuffer);
   procedure Free
     (ptr : System.Address)  -- ./webui.h:495
     with
       Import => True, Convention => C, External_Name => "webui_free";

   --  @brief Safely allocate memory using the WebUI memory management system.
   --  It can be safely freed using `webui_free()` at any time.
   --
   --  @param size The size of memory in bytes
   --
   --  @example char* myBuffer = (char*)webui_malloc(1024);
   function Malloc
     (size : size_t) return System.Address  -- ./webui.h:505
       with
         Import => True, Convention => C, External_Name => "webui_malloc";

   --  @brief Safely send raw data to the UI. All clients.
   --
   --  @param window The window number
   --  @param JS_Func The JavaScript function to receive raw data:
   --   `function myFunc(myData){}`
   --  @param raw The raw data buffer
   --  @param size The raw data size in bytes
   --
   --  @example webui_send_raw(myWindow, "myJavaScriptFunc", myBuffer, 64);
   procedure Send_Raw
     (Window : Window_Identifier; JS_Func : C_Str.chars_ptr;
      raw    : System.Address;
      size   : size_t)  -- ./webui.h:518
     with
       Import => True, Convention => C, External_Name => "webui_send_raw";

   procedure Send_Raw
     (Window : Window_Identifier; JS_Func : String; Raw : String);

   --  @brief Safely send raw data to the UI. Single client.
   --
   --  @param e The event struct
   --  @param JS_Func The JavaScript function to receive raw data:
   --   `function myFunc(myData){}`
   --  @param raw The raw data buffer
   --  @param size The raw data size in bytes
   --
   --  @example webui_send_raw_client(e, "myJavaScriptFunc", myBuffer, 64);
   procedure Send_Raw_Client
     (e    : access Event_t; JS_Func : C_Str.chars_ptr;
      raw  : System.Address;
      size : size_t)  -- ./webui.h:531
     with
       Import => True, Convention => C,
       External_Name => "webui_send_raw_client";

   procedure Send_Raw_Client
     (E : access Event_t; JS_Func : String; Raw : String);

   --  @brief Set a window in hidden mode. Should be called before
   --   `webui_show()`.
   --
   --  @param window The window number
   --  @param status The status: True or False
   --
   --  @example webui_set_hide(myWindow, True);
   procedure Set_Hide
     (Window : Window_Identifier; status : C_bool)  -- ./webui.h:542
     with
       Import => True, Convention => C, External_Name => "webui_set_hide";

   --  @brief Set the window size.
   --
   --  @param window The window number
   --  @param width The window width
   --  @param height The window height
   --
   --  @example webui_set_size(myWindow, 800, 600);
   procedure Set_Size
     (Window : Window_Identifier;
      width  : unsigned;
      height : unsigned)  -- ./webui.h:553
     with
       Import => True, Convention => C, External_Name => "webui_set_size";

   --  @brief Set the window position.
   --
   --  @param window The window number
   --  @param x The window X
   --  @param y The window Y
   --
   --  @example webui_set_position(myWindow, 100, 100);
   procedure Set_Position
     (Window : Window_Identifier;
      x      : unsigned;
      y      : unsigned)  -- ./webui.h:564
     with
       Import => True, Convention => C, External_Name => "webui_set_position";

   --  @brief Set the web browser profile to use. An empty `name` and `path`
   --  means the default user profile. Need to be called before `webui_show()`.
   --
   --  @param window The window number
   --  @param name The web browser profile name
   --  @param path The web browser profile full path
   --
   --  @example webui_set_profile(myWindow, "Bar", "/Home/Foo/Bar"); |
   --  webui_set_profile(myWindow, "", "");
   procedure Set_Profile
     (Window : Window_Identifier; name : C_Str.chars_ptr;
      path   : C_Str.chars_ptr)  -- ./webui.h:577
     with
       Import => True, Convention => C, External_Name => "webui_set_profile";

   procedure Set_Profile
     (Window : Window_Identifier; Name : String; Path : String);

   --  @brief Set the web browser proxy server to use. Need to be called before
   --  `webui_show()`.
   --
   --  @param window The window number
   --  @param proxy_server The web browser proxy_server
   --
   --  @example webui_set_proxy(myWindow, "http://127.0.0.1:8888");
   procedure Set_Proxy
     (Window : Window_Identifier;
      proxy_server : C_Str.chars_ptr)  -- ./webui.h:587
     with
       Import => True, Convention => C, External_Name => "webui_set_proxy";

   procedure Set_Proxy
     (Window : Window_Identifier; Proxy_Server : String);

   --  @brief Get current URL of a running window.
   --
   --  @param window The window number
   --
   --  @return Returns the full URL string
   --
   --  @example const char* url = webui_get_url(myWindow);
   function Get_URL
     (Window : Window_Identifier)
      return C_Str.chars_ptr  -- ./webui.h:598
       with
         Import => True, Convention => C, External_Name => "webui_get_url";

   function Get_URL (Window : Window_Identifier) return String;

   --  @brief Open an URL in the native default web browser.
   --
   --  @param url The URL to open
   --
   --  @example webui_open_url("https://webui.me");
   procedure Open_URL
     (url : C_Str.chars_ptr)  -- ./webui.h:607
     with
       Import => True, Convention => C, External_Name => "webui_open_url";

   procedure Open_URL (URL : String);

   --  @brief Allow a specific window address to be accessible from a public
   --  network.
   --
   --  @param window The window number
   --  @param status True or False
   --
   --  @example webui_set_public(myWindow, true);
   procedure Set_Public
     (Window : Window_Identifier; status : C_bool)  -- ./webui.h:617
     with
       Import => True, Convention => C, External_Name => "webui_set_public";

   --  @brief Navigate to a specific URL. All clients.
   --
   --  @param window The window number
   --  @param url Full HTTP URL
   --
   --  @example webui_navigate(myWindow, "http://domain.com");
   procedure Navigate
     (Window : Window_Identifier;
      url : C_Str.chars_ptr)  -- ./webui.h:627
     with
       Import => True, Convention => C, External_Name => "webui_navigate";

   procedure Navigate (Window : Window_Identifier; URL : String);

   --  @brief Navigate to a specific URL. Single client.
   --
   --  @param e The event struct
   --  @param url Full HTTP URL
   --
   --  @example webui_navigate_client(e, "http://domain.com");
   procedure Navigate_Client
     (e : access Event_t;
      url : C_Str.chars_ptr)  -- ./webui.h:637
     with
       Import => True, Convention => C,
       External_Name => "webui_navigate_client";

   procedure Navigate_Client (E : access Event_t; URL : String);

   --  @brief Free all memory resources. Should be called only at the end.
   --
   --  @example
   --  webui_wait();
   --  webui_clean();
   procedure Clean  -- ./webui.h:646
     with
       Import => True, Convention => C, External_Name => "webui_clean";

   --  @brief Delete all local web-browser profiles folder. It should be called
   --  at the end.
   --
   --  @example
   --  webui_wait();
   --  webui_delete_all_profiles();
   --  webui_clean();
   procedure Delete_All_Profiles  -- ./webui.h:657
     with
       Import        => True, Convention => C,
       External_Name => "webui_delete_all_profiles";

   --  @brief Delete a specific window web-browser local folder profile.
   --
   --  @param window The window number
   --
   --  @example
   --  webui_wait();
   --  webui_delete_profile(myWindow);
   --  webui_clean();
   --
   --  @note This can break functionality of other windows if using the same
   --  web-browser.
   procedure Delete_Profile
     (Window : Window_Identifier)  -- ./webui.h:672
     with
       Import => True, Convention => C,
       External_Name => "webui_delete_profile";

   --  @brief Get the ID of the parent process (The web browser may re-create
   --  another new process).
   --
   --  @param window The window number
   --
   --  @return Returns the the parent process id as integer
   --
   --  @example size_t id = webui_get_parent_process_id(myWindow);
   function Get_Parent_Process_Id
     (Window : Window_Identifier)
    return size_t  -- ./webui.h:684
     with
       Import        => True, Convention => C,
       External_Name => "webui_get_parent_process_id";

   --  @brief Get the ID of the last child process.
   --
   --  @param window The window number
   --
   --  @return Returns the the child process id as integer
   --
   --  @example size_t id = webui_get_child_process_id(myWindow);
   function Get_Child_Process_Id
     (Window : Window_Identifier)
    return size_t  -- ./webui.h:695
     with
       Import        => True, Convention => C,
       External_Name => "webui_get_child_process_id";

   --  @brief Get the network port of a running window.
   --  This can be useful to determine the HTTP link of `webui.js`
   --
   --  @param window The window number
   --
   --  @return Returns the network port of the window
   --
   --  @example size_t port = webui_get_port(myWindow);
   function Get_Port
     (Window : Window_Identifier)
    return Network_Port  -- ./webui.h:707
     with
       Import => True, Convention => C, External_Name => "webui_get_port";

   --  @brief Set a custom web-server/websocket network port to be used by
   --   WebUI. This can be useful to determine the HTTP link of `webui.js` in
   --   case you are trying to use WebUI with an external web-server like
   --   NGNIX.
   --
   --  @param window The window number
   --  @param port The web-server network port WebUI should use
   --
   --  @return Returns True if the port is free and usable by WebUI
   --
   --  @example bool ret = webui_set_port(myWindow, 8080);
   function Set_Port
     (Window : Window_Identifier; Port : Network_Port)
      return C_bool  --  ./webui.h:721
       with
         Import => True, Convention => C, External_Name => "webui_set_port";

   --  @brief Get an available usable free network port.
   --
   --  @return Returns a free port
   --
   --  @example size_t port = webui_get_free_port();

   function Get_Free_Port
     return Network_Port  -- ./webui.h:730
     with
       Import => True, Convention => C, External_Name => "webui_get_free_port";

   --  @brief Control the WebUI behaviour. It's recommended to be called at the
   --  beginning.
   --
   --  @param option The desired option from `Config` enum
   --  @param status The status of the option, `true` or `false`
   --
   --  @example webui_set_config(show_wait_connection, false);
   --
   --  FIXME: Check, option : Config_Kind | option : C.unsigned;
   --  Size of Enum Types in C language.
   --  An enum type is represented by an underlying integer type. The size of
   --   the integer type and whether it is signed is based on the range of
   --   values of the enumerated constants.
   --  How Big Is An Enum?
   --  https://embedded.fm/blog/2016/6/28/how-big-is-an-enum
   procedure Set_Config
     (option : Config_Range; status : C_bool)  -- ./webui.h:740
     with
       Import => True, Convention => C, External_Name => "webui_set_config";

   procedure Set_Config
     (Option : Config_Kind; Status : Boolean);

   --  @brief Control if UI events comming from this window should be processed
   --  one a time in a single blocking thread `True`, or process every event in
   --  a new non-blocking thread `False`. This update single window. You can
   --   use `webui_set_config(ui_event_blocking, ...)` to update all windows.
   --
   --  @param window The window number
   --  @param status The blocking status `true` or `false`
   --
   --  @example webui_set_event_blocking(myWindow, true);
   procedure Set_Event_Blocking
     (Window : Window_Identifier; status : C_bool)  -- ./webui.h:753
     with
       Import        => True, Convention => C,
       External_Name => "webui_set_event_blocking";

   --  @brief Get the HTTP mime type of a file.
   --
   --  @return Returns the HTTP mime string
   --
   --  @example const char* mime = webui_get_mime_type("foo.png");
   function Get_Mime_Type
     (file : C_Str.chars_ptr)
    return C_Str.chars_ptr  -- ./webui.h:762
       with
         Import => True, Convention => C,
         External_Name => "webui_get_mime_type";

   function Get_Mime_Type (File : String) return String;

   -- -- SSL/TLS -------------------------
   --  @brief Set the SSL/TLS certificate and the private key content, both in
   --  PEM format. This works only with `webui-2-secure` library. If set empty
   --  WebUI will generate a self-signed certificate.
   --
   --  @param certificate_pem The SSL/TLS certificate content in PEM format
   --  @param private_key_pem The private key content in PEM format
   --
   --  @return Returns True if the certificate and the key are valid.
   --
   --  @example bool ret = webui_set_tls_certificate("-----BEGIN
   --  CERTIFICATE-----\n...", "-----BEGIN PRIVATE KEY-----\n...");
   function Set_TLS_Certificate
     (certificate_pem : C_Str.chars_ptr;
      private_key_pem : C_Str.chars_ptr)
    return C_bool  --  ./webui.h:779
       with
         Import        => True, Convention => C,
         External_Name => "webui_set_tls_certificate";

   function Set_TLS_Certificate
     (Certificate_PEM : String; Private_Key_PEM : String)
      return Boolean;

   -- -- JavaScript ----------------------
   --  @brief Run JavaScript without waiting for the response. All clients.
   --
   --  @param window The window number
   --  @param script The JavaScript to be run
   --
   --  @example webui_run(myWindow, "alert('Hello');");
   procedure Run
     (Window : Window_Identifier;
      script : C_Str.chars_ptr)  -- ./webui.h:791
     with
       Import => True, Convention => C, External_Name => "webui_run";

   procedure Run (Window : Window_Identifier; Script : String);

   --  @brief Run JavaScript without waiting for the response. Single client.
   --
   --  @param e The event struct
   --  @param script The JavaScript to be run
   --
   --  @example webui_run_client(e, "alert('Hello');");
   procedure Run_Client
     (e : access Event_t;
      script : C_Str.chars_ptr)  -- ./webui.h:801
     with
       Import => True, Convention => C, External_Name => "webui_run_client";

   procedure Run_Client (E : access Event_t; Script : String);

   --  @brief Run JavaScript and get the response back. Work only in single
   --  client mode. Make sure your local buffer can hold the response.
   --
   --  @param window The window number
   --  @param script The JavaScript to be run
   --  @param timeout The execution timeout in seconds
   --  @param buffer The local buffer to hold the response
   --  @param buffer_length The local buffer size
   --
   --  @return Returns True if there is no execution error
   --
   --  @example bool err =
   --   webui_script(myWindow, "return 4 + 6;", 0, myBuffer, myBufferSize);
   function Script
     (Window : Window_Identifier;
      script : C_Str.chars_ptr;
      timeout : size_t;
      buffer : C_Str.chars_ptr; buffer_length : size_t)
    return C_bool  --  ./webui.h:817
       with
         Import => True, Convention => C, External_Name => "webui_script";

   function Script
     (Window : Window_Identifier;
      script : C_Str.chars_ptr;
      timeout : size_t;
      buffer : in out Interfaces.C.char_array; buffer_length : size_t)
    return C_bool  --  ./webui.h:817
       with
         Import => True, Convention => C, External_Name => "webui_script";

   function Script
     (Window : Window_Identifier; Script : String;
      Timeout : size_t;
      Buffer : in out C.char_array)
      return Boolean;

   --  @brief Run JavaScript and get the response back. Single client.
   --  Make sure your local buffer can hold the response.
   --
   --  @param e The event struct
   --  @param script The JavaScript to be run
   --  @param timeout The execution timeout in seconds
   --  @param buffer The local buffer to hold the response
   --  @param buffer_length The local buffer size
   --
   --  @return Returns True if there is no execution error
   --
   --  @example bool err =
   --   webui_script_client(e, "return 4 + 6;", 0, myBuffer, myBufferSize);
   function Script_Client
     (e             : access Event_t; script : C_Str.chars_ptr;
      timeout       : size_t; buffer : C_Str.chars_ptr;
      buffer_length : size_t) return C_bool  --  ./webui.h:834
       with
       Import => True, Convention => C,
       External_Name => "webui_script_client";

   --  TODO: C.char_array vs C_Str.chars_ptr
   function Script_Client
     (E : access Event_t;
      script : C_Str.chars_ptr;
      timeout : size_t;
      buffer : in out Interfaces.C.char_array; buffer_length : size_t)
      return C_bool  --  ./webui.h:817
       with
         Import => True, Convention => C, External_Name => "webui_script";

   function Script_Client
     (E : access Event_t; Script : String;
      Timeout : size_t;
      Buffer : in out C.char_array)
     return Boolean;

   --  @brief Chose between Deno and Nodejs as runtime for .js and .ts files.
   --
   --  @param window The window number
   --  @param runtime Deno | Bun | Nodejs | None
   --
   --  @example webui_set_runtime(myWindow, Deno);
   procedure Set_Runtime
     (Window : Window_Identifier;
      runtime : size_t)  -- ./webui.h:845
     with
       Import => True, Convention => C, External_Name => "webui_set_runtime";

   procedure Set_Runtime
     (Window : Window_Identifier;
      Runtime : Runtime_Kind);

   --  @brief Get how many arguments there are in an event.
   --
   --  @param e The event struct
   --
   --  @return Returns the arguments count.
   --
   --  @example size_t count = webui_get_count(e);
   function Get_Count
     (e : access Event_t)
    return Arg_Count  -- ./webui.h:856
     with
       Import => True, Convention => C, External_Name => "webui_get_count";

   --  @brief Get an argument as integer at a specific index.
   --
   --  @param e The event struct
   --  @param index The argument position starting from 0
   --
   --  @return Returns argument as integer
   --
   --  @example long long int myNum = webui_get_int_at(e, 0);
   function Get_Int_At
     (e     : access Event_t;
      index : Arg_Count)
    return Long_Long_Integer  -- ./webui.h:868
     with
       Import => True, Convention => C, External_Name => "webui_get_int_at";

   --  @brief Get the first argument as integer.
   --
   --  @param e The event struct
   --
   --  @return Returns argument as integer
   --
   --  @example long long int myNum = webui_get_int(e);
   function Get_Int
     (e : access Event_t)
    return Long_Long_Integer  -- ./webui.h:879
     with
       Import => True, Convention => C, External_Name => "webui_get_int";

   --  @brief Get an argument as float at a specific index.
   --
   --  @param e The event struct
   --  @param index The argument position starting from 0
   --
   --  @return Returns argument as float
   --
   --  @example double myNum = webui_get_float_at(e, 0);
   function Get_Float_At
     (e     : access Event_t;
      index : Arg_Count)
    return Long_Float  -- ./webui.h:891
     with
       Import => True, Convention => C, External_Name => "webui_get_float_at";

   --  @brief Get the first argument as float.
   --
   --  @param e The event struct
   --
   --  @return Returns argument as float
   --
   --  @example double myNum = webui_get_float(e);
   function Get_Float
     (e : access Event_t)
    return Long_Float  -- ./webui.h:902
     with
       Import => True, Convention => C, External_Name => "webui_get_float";

   --  @brief Get an argument as string at a specific index.
   --
   --  @param e The event struct
   --  @param index The argument position starting from 0
   --
   --  @return Returns argument as string
   --
   --  @example const char* myStr = webui_get_string_at(e, 0);
   function Get_String_At
     (e : access Event_t; index : Arg_Count)
    return C_Str.chars_ptr  -- ./webui.h:914
       with
         Import => True, Convention => C,
         External_Name => "webui_get_string_at";

   function Get_String_At
     (E : access Event_t; Index : Arg_Count) return String;

   --  @brief Get the first argument as string.
   --
   --  @param e The event struct
   --
   --  @return Returns argument as string
   --
   --  @example const char* myStr = webui_get_string(e);
   function Get_String
     (e : access Event_t)
    return C_Str.chars_ptr  -- ./webui.h:925
       with
         Import => True, Convention => C, External_Name => "webui_get_string";

   function Get_String (E : access Event_t) return String;

   --  @brief Get an argument as boolean at a specific index.
   --
   --  @param e The event struct
   --  @param index The argument position starting from 0
   --
   --  @return Returns argument as boolean
   --
   --  @example bool myBool = webui_get_bool_at(e, 0);
   function Get_C_Bool_At
     (e : access Event_t; index : Arg_Count) return C_bool  --  ./webui.h:937
       with
         Import => True, Convention => C, External_Name => "webui_get_bool_at";

   function Get_Bool_At (E : access Event_t; Index : Arg_Count) return Boolean;

   --  @brief Get the first argument as boolean.
   --
   --  @param e The event struct
   --
   --  @return Returns argument as boolean
   --
   --  @example bool myBool = webui_get_bool(e);
   function Get_C_Bool
     (e : access Event_t) return C_bool  --  ./webui.h:948
       with
         Import => True, Convention => C, External_Name => "webui_get_bool";

   function Get_Bool (E : access Event_t) return Boolean;

   --  @brief Get the size in bytes of an argument at a specific index.
   --
   --  @param e The event struct
   --  @param index The argument position starting from 0
   --
   --  @return Returns size in bytes
   --
   --  @example size_t argLen = webui_get_size_at(e, 0);
   function Get_Size_At
     (e     : access Event_t;
      index : Arg_Count)
    return size_t  -- ./webui.h:960
     with
       Import => True, Convention => C, External_Name => "webui_get_size_at";

   --  @brief Get size in bytes of the first argument.
   --
   --  @param e The event struct
   --
   --  @return Returns size in bytes
   --
   --  @example size_t argLen = webui_get_size(e);
   function Get_Size
     (e : access Event_t)
    return size_t  -- ./webui.h:971
     with
       Import => True, Convention => C, External_Name => "webui_get_size";

   --  @brief Return the response to JavaScript as integer.
   --
   --  @param e The event struct
   --  @param n The integer to be send to JavaScript
   --
   --  @example webui_return_int(e, 123);
   procedure Return_Int
     (e : access Event_t;
      n : Long_Long_Integer)  -- ./webui.h:981
     with
       Import => True, Convention => C, External_Name => "webui_return_int";

   --  @brief Return the response to JavaScript as float.
   --
   --  @param e The event struct
   --  @param f The float number to be send to JavaScript
   --
   --  @example webui_return_float(e, 123.456);
   procedure Return_Float
     (e : access Event_t;
      --  f : double  --  TODO: ? 'f : Long_Float'
      f : double)  -- ./webui.h:991
     with
       Import => True, Convention => C, External_Name => "webui_return_float";

   --  @brief Return the response to JavaScript as string.
   --
   --  @param e The event struct
   --  @param n The string to be send to JavaScript
   --
   --  @example webui_return_string(e, "Response...");
   procedure Return_String
     (e : access Event_t;
      s : C_Str.chars_ptr)  -- ./webui.h:1001
     with
       Import => True, Convention => C, External_Name => "webui_return_string";

   procedure Return_String
     (E : access Event_t; S : String);

   --  @brief Return the response to JavaScript as boolean.
   --
   --  @param e The event struct
   --  @param n The boolean to be send to JavaScript
   --
   --  @example webui_return_bool(e, true);
   procedure Return_Bool
     (e : access Event_t; b : C_bool)  -- ./webui.h:1011
     with
       Import => True, Convention => C, External_Name => "webui_return_bool";

   procedure Return_Bool
     (E : access Event_t; B : Boolean);

   -- -- Wrapper's Interface -------------
   --  @brief Bind a specific HTML element click event with a function. Empty
   --  element means all events.
   --
   --  @param window The window number
   --  @param element The element ID
   --  @param func The callback as
   --   myFunc(Window, EventType, Element, EventNumber, BindID)
   --
   --  @return Returns unique bind ID
   --
   --  @example size_t id = webui_interface_bind(myWindow, "myID", myCallback);
   function Interface_Bind
     (Window : Window_Identifier; element : C_Str.chars_ptr;
      func   : access procedure
        (arg1 : size_t; arg2 : size_t; arg3 : C_Str.chars_ptr;
         arg4 : size_t; arg5 : size_t))
    return size_t  -- ./webui.h:1026
     with
       Import => True, Convention => C,
       External_Name => "webui_interface_bind";

   --  @brief When using `webui_interface_bind()`, you may need this function
   --  to easily set a response.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param response The response as string to be send to JavaScript
   --
   --  @example
   --   webui_interface_set_response(myWindow, e->event_number, "Response...");
   procedure Interface_Set_Response
     (Window : Window_Identifier; event_number : size_t;
      response : C_Str.chars_ptr)  -- ./webui.h:1038
     with
       Import        => True, Convention => C,
       External_Name => "webui_interface_set_response";

   --  @brief Check if the app still running.
   --
   --  @return Returns True if app is running
   --
   --  @example bool status = webui_interface_is_app_running();
   function Interface_Is_App_Running return C_bool  --  ./webui.h:1047
       with
         Import        => True, Convention => C,
         External_Name => "webui_interface_is_app_running";

   --  @brief Get a unique window ID.
   --
   --  @param window The window number
   --
   --  @return Returns the unique window ID as integer
   --
   --  @example size_t id = webui_interface_get_window_id(myWindow);
   function Interface_Get_Window_Id
     (Window : Window_Identifier)
    return size_t  -- ./webui.h:1058
     with
       Import        => True, Convention => C,
       External_Name => "webui_interface_get_window_id";

   --  @brief Get an argument as string at a specific index.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param index The argument position
   --
   --  @return Returns argument as string
   --
   --  @example const char* myStr = webui_interface_get_string_at
   --  (myWindow, e->event_number, 0);
   function Interface_Get_String_At
     (Window : Window_Identifier; event_number : size_t; index : Arg_Count)
    return C_Str.chars_ptr  -- ./webui.h:1071
       with
         Import        => True, Convention => C,
         External_Name => "webui_interface_get_string_at";

   --  @brief Get an argument as integer at a specific index.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param index The argument position
   --
   --  @return Returns argument as integer
   --
   --  @example long long int myNum =
   --   webui_interface_get_int_at(myWindow, e->event_number, 0);
   function Interface_Get_Int_At
     (Window : Window_Identifier; event_number : size_t; index : Arg_Count)
    return Long_Long_Integer  -- ./webui.h:1084
     with
       Import        => True, Convention => C,
       External_Name => "webui_interface_get_int_at";

   --  @brief Get an argument as float at a specific index.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param index The argument position
   --
   --  @return Returns argument as float
   --
   --  @example double myFloat =
   --   webui_interface_get_int_at(myWindow, e->event_number, 0);
   function Interface_Get_Float_At
     (Window : Window_Identifier;
      event_number : size_t;
      index : Arg_Count)
    return Long_Float  -- ./webui.h:1097
     with
       Import        => True, Convention => C,
       External_Name => "webui_interface_get_float_at";

   --  @brief Get an argument as boolean at a specific index.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param index The argument position
   --
   --  @return Returns argument as boolean
   --
   --  @example bool myBool =
   --   webui_interface_get_bool_at(myWindow, e->event_number, 0);
   function Interface_Get_Bool_At
     (Window : Window_Identifier; event_number : size_t; index : Arg_Count)
    return C_bool  --  ./webui.h:1110
       with
         Import        => True, Convention => C,
         External_Name => "webui_interface_get_bool_at";

   --  @brief Get the size in bytes of an argument at a specific index.
   --
   --  @param window The window number
   --  @param event_number The event number
   --  @param index The argument position
   --
   --  @return Returns size in bytes
   --
   --  @example size_t argLen
   --   = webui_interface_get_size_at(myWindow, e->event_number, 0);
   function Interface_Get_Size_At
     (Window : Window_Identifier;
      event_number : size_t;
      index : Arg_Count)
    return size_t  -- ./webui.h:1123
     with
       Import        => True, Convention => C,
       External_Name => "webui_interface_get_size_at";

end Webui;
