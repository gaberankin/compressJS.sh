# CompressJS - make single javascript file ready for production

Very simple bash script which compresses javascript files with Google Closure Compiler and then make a single file of them. Reduce file sizes and save bandwidth with just one simple command.

## Important

This is a fork of @dfsq's version.  My co-worker and I preferred to be able to specify an exact filename as the output.

## Usage

Files you want to compress and add to the resulting file are separated with spaces. Run next command in terminal:

```bash
$ ./compressjs.sh jquery-ui-1.8.16.custom.min.js chat-widget.js templ.min.js
```

to specify an output file, use the `-o` option:

```bash
$ ./compressjs.hs jquery-ui-1.8.16.custom.min.js chat-widget.js templ.min.js -o outputfile.js
```

The script will prompt you if the file already exists (but only if you specify the output file.  otherwise, it just uses the auto-generated filename based on the date as normal.  this is a todo item that I plan to fix).

If you need to automate the action but don't want to have to confirm everytime you want to overwrite the file, add `-y` to the argument list:

```bash
$ ./compressjs.hs -y jquery-ui-1.8.16.custom.min.js chat-widget.js templ.min.js -o outputfile.js
```

Sure you can use wildcards in file names:

```bash
$ ./compressjs.sh scripts/*.js
```

## Home page

[Home page].

[Home page]: http://dfsq.info/site/read/bash-google-closure-compiler
