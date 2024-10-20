package body Webui is

   function Bind
     (Window : Window_Identifier; Element : String;
      Func   : access procedure (arg1 : access Event_t))
      return Bind_Identifier is
     (Bind (Window, C_Str.New_String (Element), Func));

   function Set_Root_Folder
     (Window : Window_Identifier; Path : String) return Boolean is
     (Boolean (Set_Root_Folder (Window, C_Str.New_String (Path))));

   function Set_Default_Root_Folder (Path : String) return Boolean is
      (Boolean (Set_Default_Root_Folder (C_Str.New_String (Path))));

   function Show
     (Window : Window_Identifier; Content : String) return Boolean is
     (Boolean (Show (Window, C_Str.New_String (Content))));

   function Show_Client
     (E : access Event_t; Content : String) return Boolean is
      (Boolean (Show_Client (E, C_Str.New_String (Content))));

   function Show_Browser
     (Window : Window_Identifier; Content : String; Browser : Browser_Kind)
      return Boolean is
     (Boolean (Show_Browser
           (Window, C_Str.New_String (Content), Browser_Kind'Pos (Browser))));

   function Start_Server
     (Window : Window_Identifier; Content : String) return String is
      (C_Str.Value (Start_Server (Window, C_Str.New_String (Content))));

   function Show_WV
     (Window : Window_Identifier; Content : String) return Boolean is
      (Boolean (Show_WV (Window, C_Str.New_String (Content))));

   function Browser_Exist (Browser : Browser_Kind) return Boolean is
     (Boolean (Browser_Exist (Browser_Kind'Pos (Browser))));

   procedure Set_Icon
     (Window : Window_Identifier; Icon : String; Icon_Type : String) is
   begin
      Set_Icon (Window, C_Str.New_String (Icon), C_Str.New_String (Icon_Type));
   end Set_Icon;

   procedure Send_Raw
     (Window : Window_Identifier; JS_Func : String; Raw : String) is
   begin
      Send_Raw
        (Window, C_Str.New_String (JS_Func), raw => Raw'Address,
         size => C.size_t (Raw'Length));
   end Send_Raw;

   procedure Send_Raw_Client
     (E : access Event_t; JS_Func : String; Raw : String) is
   begin
      Send_Raw_Client
        (E, C_Str.New_String (JS_Func), raw => Raw'Address,
         size => C.size_t (Raw'Length));
   end Send_Raw_Client;

   procedure Set_Profile
     (Window : Window_Identifier; Name : String; Path : String) is
   begin
      Set_Profile (Window, C_Str.New_String (Name), C_Str.New_String (Path));
   end Set_Profile;

   procedure Set_Proxy
     (Window : Window_Identifier; Proxy_Server : String) is
   begin
      Set_Proxy (Window, C_Str.New_String (Proxy_Server));
   end Set_Proxy;

   function Get_URL (Window : Window_Identifier) return String is
     (C_Str.Value (Get_URL (Window)));

   procedure Open_URL (URL : String) is
   begin
      Open_URL (C_Str.New_String (URL));
   end Open_URL;

   procedure Navigate (Window : Window_Identifier; URL : String) is
   begin
      Navigate (Window, C_Str.New_String (URL));
   end Navigate;

   procedure Navigate_Client (E : access Event_t; URL : String) is
   begin
      Navigate_Client (E, C_Str.New_String (URL));
   end Navigate_Client;

   procedure Set_Config (Option : Config_Kind; Status : Boolean) is
   begin
      Set_Config (Config_Range (Config_Kind'Pos (Option)), C_bool (Status));
   end Set_Config;

   function Get_Mime_Type (File : String) return String is
      (C_Str.Value (Get_Mime_Type (C_Str.New_String (File))));

   function Set_TLS_Certificate
     (Certificate_PEM : String; Private_Key_PEM : String)
      return Boolean is
     (Boolean (Set_TLS_Certificate (C_Str.New_String (Certificate_PEM),
      C_Str.New_String (Private_Key_PEM))));

   procedure Run
     (Window : Window_Identifier; Script : String) is
   begin
      Run (Window, C_Str.New_String (Script));
   end Run;

   procedure Run_Client (E : access Event_t; Script : String) is
   begin
      Run_Client (E, C_Str.New_String (Script));
   end Run_Client;

   function Script
     (Window :        Window_Identifier; Script : String; Timeout : size_t;
      Buffer : in out C.char_array) return Boolean is
     (Boolean (Webui.Script
      (Window, C_Str.New_String (Script), Timeout, Buffer, Buffer'Length)));

   function Script_Client
     (E : access Event_t; Script : String; Timeout : size_t;
      Buffer : in out C.char_array) return Boolean is
     (Boolean (Script_Client
      (E, C_Str.New_String (Script), Timeout, Buffer, Buffer'Length)));

   procedure Set_Runtime
     (Window : Window_Identifier; Runtime : Runtime_Kind) is
   begin
      Set_Runtime (Window, Runtime_Kind'Pos (Runtime));
   end Set_Runtime;

   function Get_String_At
     (E : access Event_t; Index : Arg_Count) return String is
     (C_Str.Value (Get_String_At (E, Index)));

   function Get_String (E : access Event_t) return String is
     (C_Str.Value (Get_String (E)));

   function Get_Bool_At
     (E : access Event_t; Index : Arg_Count) return Boolean is
     (Boolean (Get_C_Bool_At (E, Index)));

   function Get_Bool (E : access Event_t) return Boolean is
     (Boolean (Get_C_Bool (E)));

   procedure Return_String
     (E : access Event_t; S : String) is
   begin
      Return_String (E, C_Str.New_String (S));
   end Return_String;

   procedure Return_Bool
     (E : access Event_t; B : Boolean) is
   begin
      Return_Bool (E, C_bool (B));
   end Return_Bool;

   function Get_Best_Browser (Window : Window_Identifier) return Browser_Kind
   is
      Id : constant size_t := Get_Best_Browser (Window);
   begin
      return Browser_Kind'Val (Id);
   end Get_Best_Browser;

end Webui;
