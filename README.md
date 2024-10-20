# Compile WebUI
Clone [WebUI](https://webui.me) from the GitHub.

```
cd <some_projects_path>
git clone https://github.com/webui-dev/webui.git

cd ./webui
```

Compile with toolchain from the preferred Ada compiler.
With Alire package manager it is look like:
```
<some_projects_path>/webui$ make CC=/home/<current_user>/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/bin/gcc
```

The compiled libraries are saved in the directory ./dist
```
cd ./dist
<some_projects_path>/webui/dist$ ls -la
total 548
drwxrwxr-x  2 <current_user> <current_user>   4096 авг 21 18:12 .
drwxrwxr-x 10 <current_user> <current_user>   4096 авг 21 18:12 ..
-rw-rw-r--  1 <current_user> <current_user> 285966 авг 21 18:12 libwebui-2-static.a
-rwxrwxr-x  1 <current_user> <current_user> 265064 авг 21 18:12 webui-2.so
```

# Compile WebUI_Ada
Clone [WebUI_Ada](https://github.com/SergeyNM/webui_ada) from the GitHub.

```
cd <some_projects_path>
git clone https://github.com/SergeyNM/webui_ada.git

cd ./webui_ada
```
```
alr update
alr build
```

# WebUI_Ada_Examples
Examples can be found in [WebUI_Ada_Examples](https://github.com/SergeyNM/webui_ada_examples). Clone them from the GitHub.

```
cd <some_projects_path>
git clone https://github.com/SergeyNM/webui_ada_examples.git

cd ./webui_ada_examples
```
```
alr update
alr build
cd ./bin
```
