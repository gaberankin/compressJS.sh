> It's interesting, looking back at older things i've messed with.  Nowadays, sane programmers use things like gulp or webpack to do what this script is doing, and you can use those tools to much greater effect, including your own workflows.  a single word on the command line now packs all the files in your project into something that *this* script does with several more moments on the keyboard.
> What an age we live in.  Next thing you know, we'll have robots that tell us dad-jokes.  Oh [wait](https://www.reddit.com/r/amazonecho/comments/2v15fx/list_of_known_easter_eggs_for_amazon_echo_so_far/).

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
$ ./compressjs.sh jquery-ui-1.8.16.custom.min.js chat-widget.js templ.min.js -o outputfile.js
```

The script will prompt you if the file already exists (but only if you specify the output file.  otherwise, it just uses the auto-generated filename based on the date as normal.  this is a todo item that I plan to fix).

If you need to automate the action but don't want to have to confirm everytime you want to overwrite the file, add `-y` to the argument list:

```bash
$ ./compressjs.sh -y jquery-ui-1.8.16.custom.min.js chat-widget.js templ.min.js -o outputfile.js
```

Sure you can use wildcards in file names:

```bash
$ ./compressjs.sh scripts/*.js
```

## Home page

[Home page].

[Home page]: http://dfsq.info/site/read/bash-google-closure-compiler
